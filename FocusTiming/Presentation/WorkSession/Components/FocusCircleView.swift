//
//  FocusCircleView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import SwiftUI

struct FocusCircleView: View {
    
    let progress: Double
    let timeString: String
    let taskName: String
    let blockIndex: Int
    let totalBlocks: Int
    
    private let circleSize: CGFloat = 260
    private let ringWidth: CGFloat = 18
    
    var body: some View {
        VStack(spacing: 32) {
            
            ZStack {
                
                // MARK: - Glass Background
                
                Circle()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.35),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .black.opacity(0.25), radius: 30, x: 0, y: 20)
                
                
                // MARK: - Track
                
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: ringWidth)
                
                
                // MARK: - Progress
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(
                            lineWidth: ringWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: .blue.opacity(0.35), radius: 10)
                    .animation(.easeInOut(duration: 0.4), value: progress)
                
                
                // MARK: - Center Content (con margen interno real)
                
                VStack(spacing: 14) {
                    
                    Text(timeString)
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundStyle(.primary)
                    
                    Text(taskName)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Text("Bloque \(blockIndex) de \(totalBlocks)")
                        .font(.caption)
                        .foregroundStyle(.secondary.opacity(0.7))
                }
                .frame(width: circleSize * 0.62) // 🔥 clave para que no pegue
            }
            .frame(width: circleSize, height: circleSize)
        }
    }
}
