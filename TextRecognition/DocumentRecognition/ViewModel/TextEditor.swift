//
//  TextEditor.swift
//  TextRecognition
//
//  Created by Андрій Кузьмич on 28.10.2022.
//

import SwiftUI

struct TextEditorView: View {
    @State var textEditorText: String
    @State var savedText: String = ""
    init(textEditorText: String ) {
        self.textEditorText = textEditorText
    }
    var body: some View {
        NavigationView {
            VStack{
                VStack{
                    ScrollView{
                        VStack{
                            TextEditor(text: $textEditorText)
                                .background(Color(.orange))
                            
                        }
                        .frame(height: 500)

                    }
                }
                .frame(height: 500,alignment: .top)
                .cornerRadius(10)
                .border(.gray,width: 2)
                Button {
                    savedText = textEditorText
                    NavigationLink {
                        MainView()
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBlue))
                            .cornerRadius(10)

                    }

                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                        
                }

            }
        }
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(textEditorText: "")
    }
}
