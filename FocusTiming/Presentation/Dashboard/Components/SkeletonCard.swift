//
//  SkeletonCard.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

struct SkeletonCard: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.05),
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(20))
                    .offset(x: isAnimating ? 300 : -300)
            )
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 1.2)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
            .frame(height: 140)
    }
}
