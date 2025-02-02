//
//  ContentView.swift
//  CustomAlert
//
//  Created by A'zamjon Abdumuxtorov on 02/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    var body: some View {
        NavigationStack{
            List{
                Button("Show Alert"){
                    showAlert.toggle()
                }
                .alert(isPresented: $showAlert) {
                    CustomDialog(
                        title: "Folder Name",
                        content: "Enter a file Name",
                        image: .init(
                            content: "folder.fill.badge.plus",
                            tint: .blue,
                            foreground: .white
                        ),
                        button1: .init(
                            content: "Save Folder",
                            tint: .blue,
                            foreground: .white,
                            action: {_ in
                                let folder = "Your folder name here"
                                print(folder)
                                showAlert = false
                            }
                        ),
                        button2: .init(
                            content: "Cancel",
                            tint: .red,
                            foreground: .white,
                            action: { _ in
                                showAlert = false
                            }
                        ),
                        addTextField: true,
                        textFieldHint: "Personal Documents"
                    )
//                    .transition(.blurReplace.combined(with: .push(from: .bottom)))
                } background: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                }
                
            }
            .navigationTitle("Custom Alert")
        }
    }
}

#Preview {
    ContentView()
}


struct CustomDialog:View{
    var title:String
    var content:String?
    var image:Config
    var button1:Config
    var button2:Config?
    var addTextField:Bool = false
    var textFieldHint:String = ""
    @State var textFieldValue:String = ""
    var body: some View{
        VStack(spacing: 15){
            Image(systemName: image.content)
                .font(.title)
                .foregroundColor(image.foreground)
                .frame(width: 65,height: 65)
                .background(image.tint.gradient, in: .circle)
                .background(
                    Circle()
                        .stroke(.background, lineWidth: 8)
                )
            
            if let content = content{
                Text(content)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
                    .padding(.vertical,4)
            }
            
            if addTextField{
                TextField(textFieldHint, text: $textFieldValue)
                    .padding(.vertical,12)
                    .padding(.horizontal,15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.1))
                    )
                    .padding(.bottom,5)
            }
            
            ButtonView(button1)
            
            if let button2{
                ButtonView(button2)
            }
        }
        .padding([.horizontal,.bottom],15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .padding(.top,30)
        )
        .frame(maxWidth: 310)
        .compositingGroup()
        
    }
    
    @ViewBuilder
    private func ButtonView(_ config:Config)->some View{
        Button {
            config.action(addTextField ? title : "")
        } label: {
            Text(config.content)
                .fontWeight(.bold)
                .foregroundColor(config.foreground)
                .padding(.vertical ,10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }
        
    }
    
    struct Config{
        var content: String
        var tint : Color
        var foreground: Color
        var action: (String)->() = {_ in }
    }
}
