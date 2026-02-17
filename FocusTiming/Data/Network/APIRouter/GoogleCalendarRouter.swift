//
//  GoogleCalendarRouter.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

enum GoogleCalendarRouter: APIRouter {
    
    case nextEvent(accessToken: String)
    case calendarList(accessToken: String)
    case events(calendarId: String, accessToken: String)
    
    var baseURL: String {
        "https://www.googleapis.com"
    }
    
    var path: String {
        switch self {
        case .nextEvent:
            return "/calendar/v3/calendars/primary/events"
        case .calendarList:
            return "/calendar/v3/users/me/calendarList"
        case .events(let calendarId, _):
            let encodedId = calendarId.addingPercentEncoding(
                withAllowedCharacters: .alphanumerics
            ) ?? calendarId
            
            return "/calendar/v3/calendars/\(encodedId)/events"
        }
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
            URLQueryItem(name: "maxResults", value: "10")
        ]
    }
    
    var headers: [String: String]? {
        switch self {
        case .nextEvent(let token),
             .calendarList(let token),
             .events(_, let token):
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
        }
    }
}
