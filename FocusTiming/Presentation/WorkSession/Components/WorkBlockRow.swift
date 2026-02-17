//
//  WorkBlockRow.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import SwiftUI

struct WorkBlockRow: View {
    
    let title: String
    let durationHours: Double
    let isActive: Bool
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            
            statusIndicator
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: isActive ? .semibold : .regular))
                    .foregroundStyle(isCompleted ? .gray : .white)
                
                Text("\(Int(durationHours)) horas")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.gray.opacity(0.7))
            }
            
            Spacer()
            
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.green)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(backgroundStyle)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    
    // MARK: - Indicator
    
    private var statusIndicator: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    isActive ? Color.blue :
                    isCompleted ? Color.green :
                    Color.gray.opacity(0.3),
                    lineWidth: 2
                )
                .frame(width: 18, height: 18)
            
            if isCompleted {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
            
            if isActive && !isCompleted {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            }
        }
    }
    
    
    // MARK: - Background
    
    private var backgroundStyle: some View {
        Group {
            if isActive {
                Color.white.opacity(0.05)
            } else {
                Color.white.opacity(0.02)
            }
        }
    }
}
