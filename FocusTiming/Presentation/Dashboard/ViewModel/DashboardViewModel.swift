//
//  DashboardViewModel.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

enum DashboardState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}

@MainActor
final class DashboardViewModel: ObservableObject {
    
    // MARK: - Published State
    
    @Published var currentEvent: Event?
    @Published var nextEvent: Event?
    
    @Published var elapsedTime: TimeInterval = 0
    @Published var currentEventRemaining: TimeInterval = 0
    @Published var nextEventRemaining: TimeInterval = 0
    @Published var state: DashboardState = .idle
    @Published var upcomingEvents: [Event] = []

    // MARK: - Private
    
    private var timer: Timer?
    private let useCase = FetchNextEventUseCase()
    private var loadTask: Task<Void, Never>?
    
    private lazy var isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        
        formatter.formatOptions = [.withInternetDateTime]
       
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "hh:mm a"
        formatter.locale = Locale(identifier: "es_MX")
    
        return formatter
    }()

    
    
    // MARK: - Load Events

    func loadEvents() {
        
        loadTask?.cancel()
        
        loadTask = Task { [weak self] in
            guard let self else { return }
            await self.performLoad()
        }
    }
    
    
    // MARK: - Private Async Work
    
    private func performLoad() async {
        
        print("Task is cancelled at start:", Task.isCancelled)

        guard let token = AuthTokenManager.shared.retrieveToken() else {
            state = .error("No authentication token found")
            return
        }
        
        reset()
        state = .loading

        do {
            let events = try await useCase.executeAll(token: token)
            let now = Date()

            guard !events.isEmpty else {
                state = .empty
                return
            }

            let sortedEvents = events.sorted {
                (parse($0.start) ?? .distantFuture) <
                (parse($1.start) ?? .distantFuture)
            }

            // 3️⃣ Evento actual (primero que contenga now)
            currentEvent = sortedEvents.first { event in
                guard let start = parse(event.start),
                      let end = parse(event.end) else { return false }
                return now >= start && now <= end
            }

            let futureEvents = sortedEvents.filter { event in
                guard let start = parse(event.start) else { return false }
                return start > now
            }

            nextEvent = futureEvents.first
            upcomingEvents = Array(futureEvents.dropFirst())

            if currentEvent == nil && nextEvent == nil {
                state = .empty
                return
            }

            startTimer()
            state = .loaded

        } catch {
            
            print("Task cancelled inside catch:", Task.isCancelled)
            state = .error(error.localizedDescription)
        }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            
            Task { @MainActor in
                self.updateTime()
            }
        }
    }
    
    private func updateTime() {
        
        let now = Date()
        
        // 🔹 Evento actual
        if let event = currentEvent,
           let start = parse(event.start),
           let end = parse(event.end) {
            
            elapsedTime = max(0, now.timeIntervalSince(start))
            currentEventRemaining = max(0, end.timeIntervalSince(now))
        } else {
            elapsedTime = 0
            currentEventRemaining = 0
        }
        
        // 🔹 Próximo evento
        if let event = nextEvent,
           let start = parse(event.start) {
            
            nextEventRemaining = max(0, start.timeIntervalSince(now))
        } else {
            nextEventRemaining = 0
        }
    }
    
    // MARK: - Reset
    
    func reset() {
        timer?.invalidate()
        timer = nil
        
        currentEvent = nil
        nextEvent = nil
        elapsedTime = 0
        currentEventRemaining = 0
        nextEventRemaining = 0
    }
    
    // MARK: - Helpers
    
    private func parse(_ eventDate: EventDate) -> Date? {
        
        if let dateTime = eventDate.dateTime {
            return isoFormatter.date(from: dateTime)
        }
        
        if let date = eventDate.date {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            return formatter.date(from: date)
        }
        
        return nil
    }
    
    func format(_ interval: TimeInterval) -> String {
        guard interval > 0 else { return "00:00:00" }
        
        let totalSeconds = Int(interval)
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func formattedTime(for event: Event) -> String {
        
        // 🔹 Evento all-day
        if event.start.date != nil {
            return "Todo el día"
        }
        
        guard let start = parse(event.start),
              let end = parse(event.end) else {
            return ""
        }
        
        return "\(timeFormatter.string(from: start)) - \(timeFormatter.string(from: end))"
    }
}
