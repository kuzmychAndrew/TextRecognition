

import AVKit
import Foundation
import SwiftUI
import VisionKit
import FirebaseDatabase



@MainActor
final class FeaturesViewModel: ObservableObject {
    
    
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .text
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItems = true
    @Published var texts:[ScanData] = []
    let ref = Database.database().reference(withPath: "Recognition")

    
    var recognizedDataType: DataScannerViewController.RecognizedDataType
    {
         .text(textContentType: textContentType)
    }
    
    var headerText: String {
        if recognizedItems.isEmpty {
            return "Scanning \(scanType.rawValue)"
        } else {
            return "Recognized \(recognizedItems.count) item(s)"
        }
    }
    
      var dataScannerViewId: Int {
        var hasher = Hasher()
        hasher.combine(scanType)
        hasher.combine(recognizesMultipleItems)
        if let textContentType {
            hasher.combine(textContentType)
        }
        return hasher.finalize()
    }
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        
        default: break
            
        }
    }
    func loadToDataBase(item: ScanData){
        let textItemRef = self.ref.child(item.id)
        textItemRef.setValue(item.content)
    }
    func fetchData(){
        ref.observe(.value) { snapshot in
            guard let child = snapshot.children.allObjects as? [DataSnapshot] else{
                return
            }
            self.texts = child.compactMap({ snapshot in
                return ScanData(id: snapshot.key, content: snapshot.value as! String)
                
            })
            print(self.texts)
        }
    }
    func remove(id: String){
        print(id)
        ref.child(id).setValue(nil)
    }
}
