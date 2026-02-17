//
//  UpcomingEventRow.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import SwiftUI

struct UpcomingEventRow: View {
    
    let title: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(time)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardBackground)
        )
    }
}
