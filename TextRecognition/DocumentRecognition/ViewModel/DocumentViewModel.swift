//
//  TextRecognizer.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 26.10.2022.
//

import Foundation
import VisionKit
import Vision

final class DocumentViewModel{
    let cameraForDocumentScan: VNDocumentCameraScan
    init(cameraForDocumentScan: VNDocumentCameraScan) {
        self.cameraForDocumentScan = cameraForDocumentScan
    }

    func recognizeeText(withCompetionHandler comletionHabdler: @escaping([String])-> Void) {
        DispatchQueue.main.async {
            let images = (0..<self.cameraForDocumentScan.pageCount).compactMap({
                self.cameraForDocumentScan.imageOfPage(at:$0).cgImage
                
            })
            
            let imagesAndRequest = images.map({(image: $0, request:VNRecognizeTextRequest())})
            let resultText = imagesAndRequest.map{image,request->String in
                let handler = VNImageRequestHandler(cgImage: image, options: [:])
                do{
                    try handler.perform([request] as! [VNRequest])
                    guard let observations = request.results as? [VNRecognizedTextObservation] else {return ""}
                    return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
                }catch{
                    print(error)
                    return ""
                }
            }
            DispatchQueue.main.async {
                comletionHabdler(resultText)
            }
            
        }
    }
}

