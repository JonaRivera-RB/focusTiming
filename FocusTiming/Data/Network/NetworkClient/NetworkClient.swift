//
//  NetworkClient.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 16/02/26.
//

import Foundation

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ router: APIRouter) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    
    func request<T: Decodable>(_ router: APIRouter) async throws -> T {
        
        let request = try router.asURLRequest()
        
        logRequest(request)
        
        let startTime = Date()
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let duration = Date().timeIntervalSince(startTime)
            
            logResponse(data: data, response: response, duration: duration)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                logHTTPError(data: data, response: httpResponse)
                throw URLError(.badServerResponse)
            }
            
            return try JSONDecoder().decode(T.self, from: data)
            
        } catch {
            logError(error, request: request)
            throw error
        }
    }
}

private extension NetworkClient {
    
    // MARK: - REQUEST LOG
    
    func logRequest(_ request: URLRequest) {
        
        print("\n🚀 REQUEST")
        print("────────────────────────────────────────")
        
        if let curl = request.cURLDescription {
            print(curl)
        }
        
        print("────────────────────────────────────────\n")
    }
    
    
    // MARK: - RESPONSE LOG
    
    func logResponse(data: Data, response: URLResponse) {
        
        print("📡 RESPONSE")
        print("────────────────────────────────────────")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status:", httpResponse.statusCode)
        }
        
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: .prettyPrinted
           ),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            
            print(prettyString)
        } else if let rawString = String(data: data, encoding: .utf8) {
            print(rawString)
        }
        
        print("────────────────────────────────────────\n")
    }
}

private extension URLRequest {
    
    var cURLDescription: String? {
        
        guard let url = url else { return nil }
        
        var components = ["curl -X \(httpMethod ?? "GET")"]
        
        components.append("\"\(url.absoluteString)\"")
        
        allHTTPHeaderFields?.forEach {
            components.append("-H \"\($0.key): \($0.value)\"")
        }
        
        if let body = httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            components.append("-d \"\(bodyString)\"")
        }
        
        return components.joined(separator: " \\\n")
    }
}

private extension NetworkClient {
    
    // MARK: - RESPONSE LOG
    
    func logResponse(data: Data, response: URLResponse, duration: TimeInterval) {
        
        print("📡 RESPONSE")
        print("────────────────────────────────────────")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status:", httpResponse.statusCode)
        }
        
        print("Duration:", String(format: "%.3f ms", duration * 1000))
        
        prettyPrintJSON(data)
        
        print("────────────────────────────────────────\n")
    }
    
    
    // MARK: - ERROR LOG
    
    func logError(_ error: Error, request: URLRequest) {
        
        print("❌ ERROR")
        print("────────────────────────────────────────")
        
        if let nsError = error as NSError? {
            
            print("Domain:", nsError.domain)
            print("Code:", nsError.code)
            print("Description:", nsError.localizedDescription)
            
            if nsError.domain == NSURLErrorDomain,
               nsError.code == NSURLErrorCancelled {
                print("⚠️ Request was cancelled (not a real failure)")
            }
        } else {
            print(error.localizedDescription)
        }
        
        if let curl = request.cURLDescription {
            print("\nReproduce with cURL:")
            print(curl)
        }
        
        print("────────────────────────────────────────\n")
    }
    
    
    // MARK: - HTTP ERROR BODY
    
    func logHTTPError(data: Data, response: HTTPURLResponse) {
        
        print("🚨 HTTP ERROR")
        print("────────────────────────────────────────")
        print("Status:", response.statusCode)
        prettyPrintJSON(data)
        print("────────────────────────────────────────\n")
    }
    
    
    // MARK: - JSON PRETTY PRINT
    
    func prettyPrintJSON(_ data: Data) {
        
        if let jsonObject = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: .prettyPrinted
           ),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            
            print(prettyString)
            
        } else if let rawString = String(data: data, encoding: .utf8) {
            print(rawString)
        }
    }
}
