//
//  DayProgressView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import SwiftUI

struct DayProgressView: View {
    
    let progress: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            HStack {
                Text("Progreso del día")
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            
            ZStack(alignment: .leading) {
                
                // Track
                Capsule()
                    .fill(Color.white.opacity(0.08))
                    .frame(height: 12)
                
                // Progress
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, CGFloat(progress)) * UIScreen.main.bounds.width * 0.75,
                           height: 12)
                    .animation(.easeInOut(duration: 0.4), value: progress)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 20, x: 0, y: 15)
        )
    }
}
