//
//  otherTextModel.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 02.12.2022.
//

import Foundation

enum ScanType: String {
    case text
}

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

 struct CardDetailsModel {
     var number: String?
     var name: String?
     var expiryDate: String?

}
