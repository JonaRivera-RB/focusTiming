//
//  NextEventResponse.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

struct NextEventResponse: Codable {
    let items: [Event]
}

struct Event: Codable, Identifiable {
    
    var id: String {
        start.dateTime ?? UUID().uuidString
    }
    
    let summary: String?
    let start: EventDate
    let end: EventDate
}

struct EventDate: Codable {
    let dateTime: String?
}
