//
//  StartView.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 28.11.2022.
//

//import SwiftUI
//
//struct StartView: View {
//    @State var selection: Int? = nil
//    @StateObject private var vm = AppViewModel()
//
//    var body: some View {
//        NavigationView {
//            VStack{
//                Text("Recognizer")
//                    .font(.system(size: 30))
//                    .padding(.bottom, 50)
//                Text("Beginning to recognize your text")
//                    .font(.system(size: 20))
//                    .padding(.bottom, 100)
//                HStack{
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 25, style: .continuous)
//                                        .fill(.red)
//                                        .frame(width: 200, height: 100)
//
//                        NavigationLink {
//                            ContentView()
//                        } label: {
//                            Text("DocumentRecognition")
//                        }
//                        .padding()
//                        .foregroundColor(.black)
//                        
//                        
//                    }
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 25, style: .continuous)
//                                        .fill(.red)
//                                        .frame(width: 200, height: 100)
//
//                        NavigationLink {
//                            BarcodeContentView()
//                                .environmentObject(vm)
//                                .task {
//                                    await vm.requestDataScannerAccessStatus()
//                                }
//                                
//
//                        } label: {
//                            Text("BarcodeRecognition")
//                        }
//                        .foregroundColor(.black)
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct StartView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
