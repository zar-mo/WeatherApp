//
//  APIClient.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/24/24.
//

import Foundation


protocol NetworkClient: AnyObject {
    func fetchData<T: APIRequest>(_ request: T) async throws -> T.Response
}

class APIClient: NetworkClient {
 
    
    func fetchData<T>(_ request: T) async throws -> T.Response where T: APIRequest {
        
        
        let urlRequest = try request.with(queryItems: request.queryItems)
        
        guard let url = urlRequest.url else {
            throw APIClientError.apiEndpointInvalid
        }
        print(url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            
            throw APIClientError.invalidStatusCode
            
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(T.Response.self, from: data)
            return decodedData
        } catch {
            print(error)
            
            throw error
        }
    }
    
    enum APIClientError: Error {
        case apiEndpointInvalid
        case invalidStatusCode
    }
}



