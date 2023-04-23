//
//  Coordinator.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 02.12.2022.
//

import Foundation
import VisionKit
import SwiftUI

final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate{
    private let competionHandler: ([String]?) -> Void
    
    init(completion: @escaping ([String]?) -> Void)
    {
        self.competionHandler = completion
    }
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let recognizer = DocumentViewModel(cameraForDocumentScan: scan)
        recognizer.recognizeeText(withCompetionHandler: competionHandler)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        competionHandler(nil)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        competionHandler(nil)
    }
}
