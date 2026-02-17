//
//  WorkBlocksSection.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import SwiftUI

struct WorkSessionScreen: View {
    
    @StateObject private var manager = WorkSessionManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                
                if let session = manager.session {
                    
                    FocusCircleView(
                        progress: manager.blockProgress,
                        timeString: format(manager.elapsedTime),
                        taskName: manager.currentBlock?.title ?? "",
                        blockIndex: (manager.currentBlockIndex ?? 0) + 1,
                        totalBlocks: session.blocks.count
                    )
                    
                    DayProgressView(progress: manager.totalProgress)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Bloques de hoy")
                            .font(.headline)
                        
                        ForEach(session.blocks.indices, id: \.self) { index in
                            
                            let block = session.blocks[index]
                            
                            WorkBlockRow(
                                title: block.title,
                                durationHours: block.duration / 3600,
                                isActive: manager.currentBlockIndex == index,
                                isCompleted: index < (manager.currentBlockIndex ?? 0)
                            )
                        }
                    }
                    
                    Button("Finalizar jornada") {
                        manager.finishSessionManually()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
        .onAppear {
            manager.restoreSession()
        }
    }
    
    private func format(_ interval: TimeInterval) -> String {
        let total = Int(interval)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
