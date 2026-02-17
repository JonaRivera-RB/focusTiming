//
//  CalendarListResponse.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

struct CalendarListResponse: Decodable {
    let items: [CalendarItem]
}

struct CalendarItem: Decodable {
    let id: String
    let summary: String
    let accessRole: String
}
