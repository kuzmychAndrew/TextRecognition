//
//  ScannerView.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 26.10.2022.
//

import SwiftUI
import VisionKit

struct DocumentScannerView: UIViewControllerRepresentable{
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: competionHandler)
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = VNDocumentCameraViewController
    private let competionHandler: ([String]?) -> Void
    
    init(completion: @escaping ([String]?) -> Void) {
        self.competionHandler = completion
    }
    
    
}


//final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate{
//    private let competionHandler: ([String]?) -> Void
//
//    init(completion: @escaping ([String]?) -> Void)
//    {
//        self.competionHandler = completion
//    }
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//        let recognizer = TextRecognizer(cameraScan: scan)
//        recognizer.recognizeeText(withCompetionHandler: competionHandler)
//    }
//
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
//        competionHandler(nil)
//    }
//
//    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
//        competionHandler(nil)
//    }
//}
