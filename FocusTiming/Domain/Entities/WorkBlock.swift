//
//  WorkBlock.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

struct WorkBlock: Identifiable, Codable {
    
    let id: UUID
    let title: String
    let duration: TimeInterval
    
    var startDate: Date
    var endDate: Date
    
    init(title: String, duration: TimeInterval, startDate: Date) {
        self.id = UUID()
        self.title = title
        self.duration = duration
        self.startDate = startDate
        self.endDate = startDate.addingTimeInterval(duration)
    }
}
