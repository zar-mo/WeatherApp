//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/24/24.
//

import Foundation
import CoreLocation
import Combine

protocol LocationManager{
    var currentLocation: CurrentValueSubject<CLLocation?, Never> {get set}
    func getCurrentCoordinates() -> (latitude: Double, longitude: Double)?
    func setCurrentLocation(latitude: Double, longitude: Double)
    func getCurrentLocation()
}

class LocationManagerImpl: NSObject, CLLocationManagerDelegate, LocationManager {
    
    private var locationManager: CLLocationManager
    var currentLocation: CurrentValueSubject<CLLocation?, Never>
    
    override init() {
        self.locationManager = CLLocationManager()
        self.currentLocation = CurrentValueSubject(nil) 
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    func getCurrentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation.value = location
        print("Current location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
    }
    
    
    func getCurrentCoordinates() -> (latitude: Double, longitude: Double)? {
        guard let location = currentLocation.value else { return nil }
        return (location.coordinate.latitude, location.coordinate.longitude)
    }
    
    func setCurrentLocation(latitude: Double, longitude: Double) {
        currentLocation.value = CLLocation(latitude: latitude, longitude: longitude)
            print("Manually set current location: \(latitude), \(longitude)")
        }
    
    
    func checkLocationPermissionStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
