//
//  ScanData.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 26.10.2022.
//

import Foundation

struct ScanData: Identifiable {
    var id:String
    let content: String
    
    init(id: String, content: String) {
        self.id = id
        self.content = content
    }
}
