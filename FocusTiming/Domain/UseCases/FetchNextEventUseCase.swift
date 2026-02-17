//
//  FetchNextEventUseCase.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

final class FetchNextEventUseCase {
    
    private let repository: CalendarRepositoryProtocol
    
    init(repository: CalendarRepositoryProtocol = CalendarRepository()) {
        self.repository = repository
    }
    
    func executeAll(token: String) async throws -> [Event] {
        
        let calendars = try await repository.fetchCalendarList(token: token)

        return try await withThrowingTaskGroup(of: [Event].self) { group in
            
            for calendar in calendars {
                group.addTask {
                    try await self.repository.fetchEvents(
                        calendarId: calendar.id,
                        token: token
                    )
                }
            }
            
            var combined: [Event] = []
            
            for try await events in group {
                combined.append(contentsOf: events)
            }
            
            return combined
        }
    }
}
