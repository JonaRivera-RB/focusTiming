//
//  CircularProgressRing.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import SwiftUI

struct CircularProgressRing: View {
    
    var progress: Double   // 0...1
    
    var body: some View {
        
        ZStack {
            
            // MARK: Background Track
            
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.06),
                            Color.white.opacity(0.02)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 18
                )
            
            // MARK: Progress Ring
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color.blue,
                            Color.purple,
                            Color.blue
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 18,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Color.blue.opacity(0.35), radius: 8, x: 0, y: 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.85), value: progress)
        }
        .drawingGroup() // mejora suavidad del gradient
    }
}
