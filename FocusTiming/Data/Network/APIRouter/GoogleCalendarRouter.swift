//
//  GoogleCalendarRouter.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

enum GoogleCalendarRouter: APIRouter {
    
    case nextEvent(accessToken: String)
    
    var baseURL: String {
        "https://www.googleapis.com"
    }
    
    var path: String {
        "/calendar/v3/calendars/primary/events"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        let nowISO = ISO8601DateFormatter().string(from: Date())
        
        return [
            URLQueryItem(name: "timeMin", value: nowISO),
            URLQueryItem(name: "singleEvents", value: "true"),
            URLQueryItem(name: "orderBy", value: "startTime"),
            URLQueryItem(name: "maxResults", value: "5")
        ]
    }
    
    var headers: [String : String]? {
        switch self {
        case .nextEvent(let token):
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        }
    }
}
