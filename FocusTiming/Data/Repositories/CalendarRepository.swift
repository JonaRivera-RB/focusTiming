//
//  CalendarRepository.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

protocol CalendarRepositoryProtocol {
    func fetchCalendarList(token: String) async throws -> [CalendarItem]
    func fetchEvents(calendarId: String, token: String) async throws -> [Event]
}

final class CalendarRepository: CalendarRepositoryProtocol {
    
    private let network: NetworkClientProtocol
    
    init(network: NetworkClientProtocol = NetworkClient()) {
        self.network = network
    }
    
    func fetchCalendarList(token: String) async throws -> [CalendarItem] {
        let router = GoogleCalendarRouter.calendarList(accessToken: token)
        let response: CalendarListResponse = try await network.request(router)
        return response.items
    }

    func fetchEvents(calendarId: String, token: String) async throws -> [Event] {
        let router = GoogleCalendarRouter.events(
            calendarId: calendarId,
            accessToken: token
        )
        
        let response: NextEventResponse = try await network.request(router)
        
        return response.items.map { item in
            Event(
                id: item.id,
                summary: item.summary,
                start: item.start,
                end: item.end,
                calendarId: calendarId
            )
        }
    }
}
