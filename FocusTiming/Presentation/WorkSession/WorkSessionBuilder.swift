//
//  WorkSessionBuilder.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

struct WorkSessionBuilder {
    
    static func buildSession(
        tasks: [(title: String, hours: Double)],
        startDate: Date = Date()
    ) -> WorkSession {
        
        var blocks: [WorkBlock] = []
        var currentStart = startDate
        
        for task in tasks {
            
            let duration = task.hours * 3600
            
            let block = WorkBlock(
                title: task.title,
                duration: duration,
                startDate: currentStart
            )
            
            blocks.append(block)
            currentStart = block.endDate
        }
        
        return WorkSession(startDate: startDate, blocks: blocks)
    }
}
