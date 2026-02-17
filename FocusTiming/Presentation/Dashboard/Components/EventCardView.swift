//
//  EventCardView.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

enum EventCardStyle {
    case active
    case upcoming
    
    var accentColor: Color {
        switch self {
        case .active:
            return .green
        case .upcoming:
            return .blue
        }
    }
    
    var timerFont: Font {
        switch self {
        case .active:
            return .system(size: 42, weight: .bold, design: .monospaced)
        case .upcoming:
            return .system(size: 34, weight: .semibold, design: .monospaced)
        }
    }
}

struct EventCardView: View {
    
    let title: String
    let eventName: String
    let timeLabel: String
    let timeValue: String
    let style: EventCardStyle
    
    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                
                // Header
                HStack {
                    Text(title)
                        .font(AppTypography.sectionTitle)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Circle()
                        .fill(style.accentColor)
                        .frame(width: 8, height: 8)
                }
                
                // Event name
                Text(eventName)
                    .font(AppTypography.eventTitle)
                
                // Timer label
                Text(timeLabel)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                
                // Timer value
                Text(timeValue)
                    .font(style.timerFont)
                    .foregroundColor(style.accentColor)
            }
        }
    }
}
