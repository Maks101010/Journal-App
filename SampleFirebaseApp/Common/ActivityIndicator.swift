//
//
// ActivityIndicator.swift
// FireBaseIntegration
//
// Created by Shubh Magdani on 31/12/24
// Copyright © 2024 Differenz System Pvt. Ltd. All rights reserved.
//


import Foundation
import SwiftUI

///`View Modifier`
extension View {
    func activityIndicator(show: Bool) -> some View {
        self.modifier(ActivityIndicatorExt(show: show))
    }
}

///`ActivityIndicatorExt`
struct ActivityIndicatorExt: ViewModifier {
    
    @State private var isCircleRotating: Bool = false
    @State private var animateStart: Bool = false
    @State private var animateEnd: Bool = true
    
    var show: Bool
    var message: String = ""
    
    func body(content: Content) -> some View {
        
        ZStack {
            content
                .blur(radius: show ? 10 : 0)
            if self.show {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                    
                
                VStack(spacing: 0.0) {
                    
//                    Circle()
//                        .trim(from: self.animateStart ? 1/3 : 1/9, to: self.animateEnd ? 2/5 : 1.0)
//                        .stroke(lineWidth:   2.5)
//                        .rotationEffect(.degrees(self.isCircleRotating ? 360.0 : 0))
//                        .frame(width:  40.0, height: 40.0)
//                        .padding(20.0)
//                        .foregroundColor(UserDefaults.themeColor)
//                        .onAppear {
//
//                            DispatchQueue.main.async {
//
//                                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
//                                    self.isCircleRotating.toggle()
//                                }
//
//                                withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
//                                    self.animateStart.toggle()
//                                }
//
//                                withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
//                                    self.animateEnd.toggle()
//                                }
//                            }
//
//                        }.onDisappear {
//                            self.isCircleRotating.toggle()
//                        }
//
//                    if message != "" {
//
//                        Text(message)
//                            .padding(.bottom, 8.0)
//                            .padding(.horizontal, 8.0)
//
//                    }
                    preloader()
                    
                }
//                .background(Color.black)
//                .cornerRadius(15.0)
                
            }
        }
    }
}

///`Indicator`
struct Indicator {
    static func show()  { NotificationCenter.default.post(name: .showLoader, object: [true]) }
    static func hide() {  NotificationCenter.default.post(name: .showLoader, object: [false]) }
}

