//
//  CalendarRepository.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

protocol CalendarRepositoryProtocol {
    func fetchUpcomingEvents(token: String) async throws -> [Event]
}

final class CalendarRepository: CalendarRepositoryProtocol {
    
    private let network: NetworkClientProtocol
    
    init(network: NetworkClientProtocol = NetworkClient()) {
        self.network = network
    }
    
    func fetchUpcomingEvents(token: String) async throws -> [Event] {
        let router = GoogleCalendarRouter.nextEvent(accessToken: token)
        let response: NextEventResponse = try await network.request(router)
        return response.items
    }
}
