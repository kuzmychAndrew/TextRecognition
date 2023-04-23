//
//  CardView.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 07.02.2023.
//

import SwiftUI
import UIKit
import Vision
import VisionKit


public struct CardReaderView: UIViewControllerRepresentable {
    
    private let completionHandler: (String?) -> Void
     
    init(completionHandler: @escaping (String?) -> Void) {
        self.completionHandler = completionHandler
    }
     
    public typealias UIViewControllerType = VNDocumentCameraViewController
     
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CardReaderView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
     
    public func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<CardReaderView>) {
        
    }
     
    public func makeCoordinator() -> Coordinator {
        Coordinator(completionHandler: completionHandler)
    }
     
    final public class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate, ImageTextRecognizable {
        private let completionHandler: (String?) -> Void
         
        init(completionHandler: @escaping (String?) -> Void) {
            self.completionHandler = completionHandler
        }
         
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            print("Document camera view controller did finish with ", scan)
            let image = scan.imageOfPage(at: 0)
            validateImage(image: image) { cardDetails in
                self.completionHandler(cardDetails)
            }
        }
         
        public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
        }
         
        public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
    }
}
//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
//}
public protocol ImageTextRecognizable: VNDocumentCameraViewControllerDelegate { }

public extension ImageTextRecognizable {
    
    func validateImage(image: UIImage?, completion: @escaping (String?) -> Void) {
        guard let cgImage = image?.cgImage else { return completion(nil) }
        
        var recognizedText = [String]()
        
        var textRecognitionRequest = VNRecognizeTextRequest()
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = CardType.allCases.map { $0.rawValue } + ["Expiry Date"]
        textRecognitionRequest = VNRecognizeTextRequest() { (request, error) in
            guard let results = request.results,
                  !results.isEmpty,
                  let requestResults = request.results as? [VNRecognizedTextObservation]
            else { return completion(nil) }
            recognizedText = requestResults.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
            completion(parseResults(for: recognizedText))
        } catch {
            print(error)
        }
    }
    
    func parseResults(for recognizedText: [String]) -> String {
        // Credit Card Number
        let creditCardNumber = recognizedText.first(where: { $0.count >= 14 && ["4", "5", "3", "6"].contains($0.first) })
        
        // Expiry Date
        let expiryDateString = recognizedText.first(where: { $0.count > 4 && $0.contains("/") })
        let expiryDate = expiryDateString?.filter({ $0.isNumber || $0 == "/" })
        
        // Name
        let ignoreList = ["GOOD THRU", "GOOD", "THRU", "Gold", "GOLD", "Standard", "STANDARD", "Platinum",
                          "PLATINUM", "WORLD ELITE", "WORLD", "ELITE", "World Elite", "World", "Elite"]
        let wordsToAvoid = [creditCardNumber, expiryDateString] +
            ignoreList +
            CardType.allCases.map { $0.rawValue } +
            CardType.allCases.map { $0.rawValue.lowercased() } +
            CardType.allCases.map { $0.rawValue.uppercased() }
        let name = recognizedText.filter({ !wordsToAvoid.contains($0) }).last
        let results =
        """
        Card Number: \(creditCardNumber ?? "")
        Name: \(name ?? "" ) 
        ExpiryDate: \(expiryDate ?? "")
        """
        return results

    }
}
