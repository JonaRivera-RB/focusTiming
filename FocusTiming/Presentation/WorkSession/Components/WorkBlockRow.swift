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
        HStack {
            
            Circle()
                .fill(isCompleted ? Color.green :
                        isActive ? Color.blue :
                        Color.gray.opacity(0.4))
                .frame(width: 10, height: 10)
            
            Text(title)
                .fontWeight(isActive ? .bold : .regular)
            
            Spacer()
            
            Text("\(Int(durationHours))h")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
