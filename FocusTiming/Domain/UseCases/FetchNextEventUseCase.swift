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
        try await repository.fetchUpcomingEvents(token: token)
    }
}
