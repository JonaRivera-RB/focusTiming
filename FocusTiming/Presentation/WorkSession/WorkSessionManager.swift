//
//  WorkSessionManager.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation
import UIKit

@MainActor
final class WorkSessionManager: ObservableObject {
    
    @Published private(set) var session: WorkSession?
    @Published private(set) var currentBlockIndex: Int?
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var totalElapsed: TimeInterval = 0
    
    private var timer: Timer?
    
    private var lastNotifiedBlockIndex: Int?
    private var fiveMinuteWarningTriggered = false
    
    // MARK: - Start
    
    // MARK: - Start
    
    func startSession(tasks: [(title: String, hours: Double)]) {
        
        session = WorkSessionBuilder.buildSession(tasks: tasks)
        
        startTimer()
        persist()
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.update()
        }
    }
    
    private func update() {
        guard let session else { return }
        
        let now = Date()
        totalElapsed = now.timeIntervalSince(session.startDate)
        
        // 🔥 Si ya terminó completamente
        if totalElapsed >= session.totalDuration {
            completeSession()
            return
        }
        
        // 🔥 Detectar bloque actual
        for (index, block) in session.blocks.enumerated() {
            
            if now >= block.startDate && now <= block.endDate {
                
                if currentBlockIndex != index {
                    handleBlockChange(to: index)
                }
                
                currentBlockIndex = index
                elapsedTime = now.timeIntervalSince(block.startDate)
                
                checkFiveMinuteWarning(for: block)
                
                return
            }
        }
    }
    
    private func handleBlockChange(to index: Int) {
        
        print("➡️ Changed to block \(index + 1)")
        
        fiveMinuteWarningTriggered = false
    }
    
    private func checkFiveMinuteWarning(for block: WorkBlock) {
        
        let now = Date()
        let remaining = block.endDate.timeIntervalSince(now)
        //300
        if remaining <= 10 && !fiveMinuteWarningTriggered {
            
            fiveMinuteWarningTriggered = true
            
            print("⏰ 5 minutes remaining in block")
            
            scheduleBlockNotifications()
        }
    }
    
    private func completeSession() {
        
        guard var session else { return }
        
        if session.state == .completed { return }
        
        session.state = .completed
        self.session = session
        
        currentBlockIndex = nil
        elapsedTime = session.totalDuration
        totalElapsed = session.totalDuration
        
        print("🎉 Session completed")
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        persist()
        timer?.invalidate()
    }
    
    
    // MARK: - Progress
    
    var totalProgress: Double {
        guard let session else { return 0 }
        return min(totalElapsed / session.totalDuration, 1)
    }
    
    var blockProgress: Double {
        guard let block = currentBlock else { return 0 }
        return min(elapsedTime / block.duration, 1)
    }
    
    var currentBlock: WorkBlock? {
        guard let session,
              let index = currentBlockIndex,
              session.blocks.indices.contains(index) else {
            return nil
        }
        
        return session.blocks[index]
    }
    
    // MARK: - Persistence
    
    private func persist() {
        guard let session else { return }
        
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: "activeWorkSession")
        }
    }
    
    func restoreSession() {
        
        guard let data = UserDefaults.standard.data(forKey: "activeWorkSession"),
              let savedSession = try? JSONDecoder().decode(WorkSession.self, from: data)
        else { return }
        
        self.session = savedSession
        
        // 🔥 Forzar recalculo inmediato
        update()
        
        if savedSession.state == .active {
            startTimer()
        }
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        
        session = nil
        currentBlockIndex = nil
        elapsedTime = 0
        totalElapsed = 0
        
        UserDefaults.standard.removeObject(forKey: "activeWorkSession")
        
        LocalNotificationManager.shared.cancelAll()
    }
    
    func finishSessionManually() {
        
        guard var session else { return }
        
        if session.state == .completed { return }
        
        session.state = .completed
        self.session = session
        
        timer?.invalidate()
        timer = nil
        
        currentBlockIndex = nil
        totalElapsed = min(totalElapsed, session.totalDuration)
        
        print("🛑 Session manually finished")
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        LocalNotificationManager.shared.cancelAll()
        
        persist()
    }
    
    private func scheduleBlockNotifications() {
        
        guard let session else { return }
        
        LocalNotificationManager.shared.cancelAll()
        
        for (index, block) in session.blocks.enumerated() {
            
            let title = "Tarea completada"
            let body = "Terminaste: \(block.title)"
            
            LocalNotificationManager.shared.scheduleBlockCompletionNotification(
                title: title,
                body: body,
                at: block.endDate,
                identifier: "work_block_\(index)"
            )
        }
    }
}
