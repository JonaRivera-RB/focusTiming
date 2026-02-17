//
//  WorkSession.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

struct WorkSession: Codable {
    
    let startDate: Date
    var blocks: [WorkBlock]
    var state: WorkSessionState = .active
    
    var totalDuration: TimeInterval {
        blocks.reduce(0) { $0 + $1.duration }
    }
}
