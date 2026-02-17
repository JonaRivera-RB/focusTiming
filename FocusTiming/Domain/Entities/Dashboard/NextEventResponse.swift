//
//  NextEventResponse.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

struct NextEventResponse: Codable {
    let items: [Event]
    let nextPageToken: String?
}

struct Event: Codable, Identifiable {
    
    let id: String
    let summary: String?
    let start: EventDate
    let end: EventDate
    let calendarId: String?
}

struct EventDate: Codable {
    let dateTime: String?
    let date: String?
}
