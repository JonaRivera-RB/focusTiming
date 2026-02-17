//
//  CircularProgressRing.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import SwiftUI

struct CircularProgressRing: View {
    
    var progress: Double
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 18)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 18,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: progress)
        }
    }
}
