//
//  FocusCircleView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import SwiftUI

struct FocusCircleView: View {
    
    let progress: Double      // 0...1
    let timeString: String
    let taskName: String
    let blockIndex: Int
    let totalBlocks: Int
    
    var body: some View {
        VStack(spacing: 16) {
            
            ZStack {
                
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 20)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            center: .center
                        ),
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: progress)
                
                VStack(spacing: 6) {
                    Text(timeString)
                        .font(.system(size: 42, weight: .bold, design: .monospaced))
                    
                    Text(taskName)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Bloque \(blockIndex) de \(totalBlocks)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 240, height: 240)
        }
    }
}
