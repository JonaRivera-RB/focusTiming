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
                guard let start1 = parse($0.start.dateTime),
                      let start2 = parse($1.start.dateTime) else { return false }
                return start1 < start2
            }

            upcomingEvents = []

            for event in sortedEvents {
                guard let start = parse(event.start.dateTime),
                      let end = parse(event.end.dateTime) else { continue }

                if now >= start && now <= end {
                    currentEvent = event
                } else if start > now {
                    if nextEvent == nil {
                        nextEvent = event
                    }
                    upcomingEvents.append(event)
                }
            }

            startTimer()
            state = .loaded

        } catch is CancellationError {
            
            print("ℹ️ Task cancelled safely")
            return
            
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
        
        if let event = currentEvent,
           let start = parse(event.start.dateTime),
           let end = parse(event.end.dateTime) {
            
            elapsedTime = now.timeIntervalSince(start)
            currentEventRemaining = end.timeIntervalSince(now)
        }
        
        if let event = nextEvent,
           let start = parse(event.start.dateTime) {
            
            nextEventRemaining = start.timeIntervalSince(now)
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
    
    private func parse(_ dateString: String?) -> Date? {
        guard let dateString else { return nil }
        return isoFormatter.date(from: dateString)
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
        guard let start = parse(event.start.dateTime),
              let end = parse(event.end.dateTime) else {
            return ""
        }
        
        return "\(timeFormatter.string(from: start)) - \(timeFormatter.string(from: end))"
    }
}
