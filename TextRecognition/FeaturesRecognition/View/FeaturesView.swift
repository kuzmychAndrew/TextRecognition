//
//  ContentView.swift
//  BarcodeTextScanner
//
//  Created by Alfian Losari on 6/25/22.
//

import SwiftUI
import VisionKit

struct FeaturesView: View {
    
    @EnvironmentObject var vm: FeaturesViewModel
    
    var body: some View {
        if vm.dataScannerAccessStatus == .scannerAvailable{
            barcodeRegonizerView
        }else{
            Text("Error")
        }
    }
    
    private var barcodeRegonizerView: some View {
        
        FeaturesScannerView(
            recognizedItems: $vm.recognizedItems,
            recognizedDataType: vm.recognizedDataType,
            recognizesMultipleItems: vm.recognizesMultipleItems)
        .background { Color.gray.opacity(0.3) }
        .ignoresSafeArea(edges: .horizontal)
        .id(vm.dataScannerViewId)
        .sheet(isPresented: .constant(true)) {
            featuresView
                .background(.ultraThinMaterial)
                .presentationDetents([.medium, .fraction(0.25)])
        }
        .onChange(of: vm.scanType) { _ in vm.recognizedItems = [] }
        .onChange(of: vm.textContentType) { _ in vm.recognizedItems = [] }
        .onChange(of: vm.recognizesMultipleItems) { _ in vm.recognizedItems = []}
    }
    
    private var featuresView: some View {
        VStack {
            VStack {
                HStack {
//                    Picker("Scan Type", selection: $vm.scanType) {
//                        Text("Barcode").tag(ScanType.barcode)
//                        Text("Text").tag(ScanType.text)
//                    }.pickerStyle(.segmented)
//
                    Toggle("Scan multiple", isOn: $vm.recognizesMultipleItems)
                }.padding(.top)
                
                if vm.scanType == .text {
                    Picker("Text content type", selection: $vm.textContentType) {
                        ForEach(textContentTypes, id: \.self.textContentType) { option in
                            Text(option.title).tag(option.textContentType)
                        }
                    }.pickerStyle(.segmented)
                }
                
                Text(vm.headerText).padding(.top)
            }.padding(.horizontal)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.recognizedItems) { item in
                        switch item {
                        case .barcode(let barcode):
                            Text(barcode.payloadStringValue ?? "Unknown barcode")
                            
                        case .text(let text):
                            Text(text.transcript)
                            
                        @unknown default:
                            Text("Unknown")
                        }
                    }
                }
                .padding()
            }
        }
    }
    private let textContentTypes: [(title: String, textContentType: DataScannerViewController.TextContentType?)] = [
        ("Text", .none),
        ("URL", .URL),
        ("Phone", .telephoneNumber),
        ("Email", .emailAddress),
        ("Address", .fullStreetAddress)
    ]
    
}
