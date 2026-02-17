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
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Progreso del día")
                .font(.headline)
            
            ProgressView(value: progress)
                .progressViewStyle(.linear)
            
            Text("\(Int(progress * 100))% completado")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
