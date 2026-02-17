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
            VStack(spacing: 48) {
                
                if let session = manager.session {
                    
                    FocusCircleView(
                        progress: manager.blockProgress,
                        timeString: format(manager.elapsedTime),
                        taskName: manager.currentBlock?.title ?? "",
                        blockIndex: (manager.currentBlockIndex ?? 0) + 1,
                        totalBlocks: session.blocks.count
                    )
                    
                    DayProgressView(progress: manager.totalProgress)
                    
                    blocksSection(session: session)
                    
                    finishButton
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 40)
        }
        .background(Color.black)
        .foregroundStyle(.white)
        .onAppear {
            manager.restoreSession()
        }
    }
    
    
    // MARK: - Blocks Section
    
    private func blocksSection(session: WorkSession) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Bloques de hoy")
                .font(.system(size: 18, weight: .semibold))
                .opacity(0.9)
            
            VStack(spacing: 16) {
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
        }
    }
    
    
    // MARK: - Finish Button
    
    private var finishButton: some View {
        Button(action: {
            manager.finishSessionManually()
        }) {
            Text("Finalizar jornada")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.top, 12)
    }
    
    
    // MARK: - Formatter
    
    private func format(_ interval: TimeInterval) -> String {
        let total = Int(interval)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
