//
//
// SplashView.swift
// SampleFirebaseApp
//
// Created by Shubh Magdani on 15/01/25
// Copyright © 2025 Differenz System Pvt. Ltd. All rights reserved.
//
import Foundation
import SwiftUI
import Combine
struct SplashView: View {
    @Binding var isExiting: Bool
    @State private var isAnimating = false
    @State private var isColorChanged = false
    @State private var isFadingOut = false
    @State private var colorChangeEffect = false

    var body: some View {
        ZStack {
            glitchText(color: isColorChanged ? .white : FireBaseAppModel.shared.themeColor, offset: CGSize(width: 0, height: 2))
            glitchText(color: isColorChanged ? .white : FireBaseAppModel.shared.themeColor, offset: CGSize(width: -2, height: 0))
            glitchText(color: isColorChanged ? FireBaseAppModel.shared.themeColor : FireBaseAppModel.shared.themeColor, offset: CGSize(width: 2, height: 0))
            
            Text("Journal App")
                .bold()
                .fontWidth(.expanded)
                .font(.largeTitle)
                .textCase(.uppercase)
                .foregroundColor(isColorChanged ? .white : FireBaseAppModel.shared.themeColor)
                .opacity(isAnimating ? 1 : 0)
                .rotationEffect(.degrees(isAnimating ? 0 : -15))
                .animation(
                    .interpolatingSpring(stiffness: 70, damping: 7)
                        .delay(0.3),
                    value: isAnimating
                )
                .scaleEffect(colorChangeEffect ? 1.1 : 1) // Brief scale effect
                .animation(.easeInOut(duration: 0.5), value: colorChangeEffect)
                .scaleEffect(isExiting ? 1.6 : 1)
                .opacity(isFadingOut ? 0 : 1)
                .animation(.easeOut(duration: 0.6), value: isExiting)
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
            
            // Trigger a color change animation with a brief scale effect
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    colorChangeEffect = true
                    isColorChanged = true
                }
                
                // Reverse the scale effect after color change
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        colorChangeEffect = false
                    }
                }
            }
            
            // Fade out the text after it has changed color
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.6)) {
                    isFadingOut = true
                }
            }
        }
    }
    
    private func glitchText(color: Color, offset: CGSize) -> some View {
        Text("Journal App")
            .bold()
            .fontWidth(.expanded)
            .font(.largeTitle)
            .textCase(.uppercase)
            .foregroundColor(color)
            .offset(offset)
            .opacity(isAnimating ? 0.7 : 0)
            .rotationEffect(.degrees(isAnimating ? 0 : -15))
            .animation(
                .interpolatingSpring(stiffness: 70, damping: 7)
                .delay(0.3),
                value: isAnimating
            )
            .scaleEffect(isExiting ? 60 : 1)
            .opacity(isExiting ? 0 : 0.7)
            .animation(.easeOut(duration: 0.6), value: isExiting)
    }
}
