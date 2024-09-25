//
//  Geolocator.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/25/24.
//


import Foundation
import CoreLocation

protocol GeocodingService{
    func getLocation(forPlace name: String) async throws -> CLLocation
}

class GeocodingServiceImpl: GeocodingService {
    
    private let geocoder = CLGeocoder()
    
    
    
    func getLocation(forPlace name: String) async throws -> CLLocation{
        
        return try await withCheckedThrowingContinuation { continuation in
            
            geocoder.geocodeAddressString(name) { placemarks, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let placemark = placemarks?.first, let location = placemark.location else {
                    let error = NSError(domain: "GeocodingServiceError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Location not found"])
                    continuation.resume(throwing: error)
                    return
                    
                }
                
                return continuation.resume(returning: location)
            }

        }
    }
}
