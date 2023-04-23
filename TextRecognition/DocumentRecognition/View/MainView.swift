//
//  ContentView.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 26.10.2022.
//

import SwiftUI

struct MainView: View {
    @State private var showScannerSheet = false
    @State private var showCreditCardScannerSheet = false
    //@State private var texts:[ScanData] = []
    @StateObject private var vm = FeaturesViewModel()
    var body: some View {
        NavigationView {
            VStack {
                if vm.texts.count > 0{
                    List{
                        ForEach(vm.texts) { text in
                            NavigationLink {
                                TextEditorView(textEditorText: text.content)
                            } label: {
                                Text(text.content).lineLimit(1)
                            }
                        }
                        .onDelete(perform: deleteRow)
                        
                    }
                    
                    
                } else {
                    Spacer()
                    Text("Add your first recognized text")
                }
                Spacer()
                HStack{
                    Button(action: {
                        self.showScannerSheet = true
                    }, label: {
                        VStack{
                            Image(systemName: "plus.rectangle")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                            Text("Scan Document")
                                .foregroundColor(.black)
                        }
                    })
                    .sheet(isPresented: $showScannerSheet, content: {
                        makeScunnerView()
                    })
                    .padding(.horizontal)
                    NavigationLink {
                        FeaturesView()
                            .environmentObject(vm)
                            .task {
                                await vm.requestDataScannerAccessStatus()
                            }
                        
                        
                    } label: {
                        VStack{
                            Image(systemName: "plus.rectangle")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                            Text("Scan typed text")
                        }
                    }
                    .foregroundColor(.black)
                    Button(action: {
                        self.showCreditCardScannerSheet = true
                    }, label: {
                        VStack{
                            Image(systemName: "plus.rectangle")
                                .font(.system(size: 40))
                                .foregroundColor(.black)
                            Text("Scan Card")
                                .foregroundColor(.black)
                        }
                    })
                    .sheet(isPresented: $showCreditCardScannerSheet, content: {
                        //
                        makeCardScannerView()
                    })
                    .padding(.horizontal)
                    //                    NavigationLink {
                    //                        //CardFormView(completion: {_ in})
                    ////                            .environmentObject(vm)
                    ////                            .task {
                    ////                                await vm.requestDataScannerAccessStatus()
                    ////                            }
                    //                            CardFormView(completion: {_ in})
                    //
                    //                    } label: {
                    //                        VStack{
                    //                            Image(systemName: "plus.rectangle")
                    //                                .font(.system(size: 40))
                    //                                .foregroundColor(.black)
                    //                            Text("Scan card text")
                    //                        }
                    //                    }
                    //                    .foregroundColor(.black)
                }
            }
            .onAppear{
                vm.fetchData()
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Scan Text")
                        .font(.title)
                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Menu("Scan"){
//                        Button {
//                            self.showScannerSheet = true
//                        } label: {
//                            Text("Scan Document")
//                                .foregroundColor(.black)
//                        }
//                        .sheet(isPresented: $showScannerSheet, content: {
//                            makeScunnerView()
//                        })
//                        Button {
//                            self.showCreditCardScannerSheet = true
//                        } label: {
//                            Text("Scan Card")
//                                .foregroundColor(.black)
//                        }
//                        .sheet(isPresented: $showCreditCardScannerSheet, content: {
//                            //
//                            makeCardScannerView()
//                        })
//                        NavigationLink {
//                            FeaturesView()
//                                .environmentObject(vm)
//                                .task {
//                                    await vm.requestDataScannerAccessStatus()
//                                }
//                        } label: {
//                            Text("Scan small text")
//
//                        }
//                        .foregroundColor(.black)
//                    }
//                }
            }
            
        }
    }
    private func deleteRow(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let taskId = vm.texts[index].id
        vm.remove(id: taskId)
    }
    
    func makeCardScannerView()-> CardReaderView{
        CardReaderView { cardDetail in
            if let outputText = cardDetail {
                let newScanData = ScanData(id: UUID().uuidString, content: outputText)
                vm.texts.append(newScanData)
                vm.loadToDataBase(item: newScanData)
            }
            self.showCreditCardScannerSheet = false
        }
    }
    
    private func makeScunnerView()-> DocumentScannerView {
        DocumentScannerView(completion:  { textPerPage in
            if let outputText = textPerPage?.joined(separator: "/n").trimmingCharacters(in: .whitespaces){
                let newScanData = ScanData(id: UUID().uuidString, content: outputText)
                vm.texts.append(newScanData)
                vm.loadToDataBase(item: newScanData)
            }
            self.showScannerSheet = false
        })
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
