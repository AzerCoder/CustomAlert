//
//  CustomAlert.swift
//  CustomAlert
//
//  Created by A'zamjon Abdumuxtorov on 02/02/25.
//

import SwiftUI

extension View{
    @ViewBuilder
    func alert<Content:View,Background:View>(
        isPresented:Binding<Bool>,
        @ViewBuilder content: @escaping()->Content,
        @ViewBuilder background: @escaping()->Background
    )->some View{
        self
            .modifier(CustomAlertModifier(isPresented: isPresented, alertContent: content, background: background))
    }
}


fileprivate struct CustomAlertModifier<AlertContent: View,Background: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder var alertContent: AlertContent
    @ViewBuilder var background: Background
    
    @State private var showFullScrenCover = false
    @State private var animatedValue = false
    @State private var allowHitTesting = false
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $showFullScrenCover) {
                ZStack{
                    if animatedValue{
                        alertContent
                            .allowsTightening(allowHitTesting)
                    }
                }
                .presentationBackground{
                    background
                        .allowsTightening(allowHitTesting)
                        .opacity(animatedValue ? 1 : 0)
                }
                .task {
                    try? await Task.sleep(for: .seconds(0.05))
                    withAnimation(.easeInOut(duration: 0.3)){
                        animatedValue = true
                    }
                    
                    try? await Task.sleep(for: .seconds(0.3))
                    allowHitTesting = true
                }
            }
            .onChange(of: isPresented) { oldValue, newValue in
                var transaction = Transaction()
                transaction.disablesAnimations = true
                
                if newValue{
                    withTransaction(transaction) {
                        showFullScrenCover = true
                    }
                }else{
                    allowHitTesting = false
                    withAnimation(.easeInOut(duration: 0.3),completionCriteria: .removed){
                        animatedValue = false
                    } completion: {
                        withTransaction(transaction) {
                            showFullScrenCover = false
                        }
                    }
                }
            }
    }
    
    
}


#Preview {
    ContentView()
}
