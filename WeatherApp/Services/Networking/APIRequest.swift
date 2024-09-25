//
//  APIRequest.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/24/24.
//

import Foundation


protocol APIRequest {
    
    associatedtype Response: Codable
    
    static var acceptableStatusCode: Set<Int> {get}

    var method: String {get}
    var host: String {get}
    var path: String {get}
    var body: Data? {get}
    var queryItems: [URLQueryItem] {set get}
    
}

extension APIRequest {

    var host: String {Constants.weatherAPIhost.rawValue}
    var path: String {Constants.weatherAPIPath.rawValue}
    var method: String {return "GET" }
    var body: Data? { return nil }
    var queryItems: [URLQueryItem] {return []}
    static var acceptableStatusCode: Set<Int> {return Set([200])}
    
}

extension APIRequest {
    
    func with(queryItems: [URLQueryItem]) throws -> URLRequest {
        
        guard let escapedPath = path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            throw APIRequestError.pathEncodingFailed(path)
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.percentEncodedPath =  escapedPath
        components.queryItems = queryItems
        
        guard let requestUrl = components.url else {
            throw APIRequestError.urlBuildFailed
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method
        request.httpBody = body
        
        return request
    }
}

class WeatherAPIRequest: APIRequest {
    
    typealias Response = WeatherData
    var queryItems: [URLQueryItem] = []
    
}

enum APIRequestError: Error, LocalizedError{
    
    case pathEncodingFailed(String), urlBuildFailed
    
    var errorDescription: String? {
        switch self {
        case .pathEncodingFailed(let path):
            return "Failed to add percent escapes to path \(path)"
        case .urlBuildFailed:
            return "Failed to build url"
        }
    }
}



