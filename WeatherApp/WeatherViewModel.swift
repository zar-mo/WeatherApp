//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/25/24.
//

import UIKit
import Combine
import CoreLocation

protocol WeatherViewModel{
    var weatherData: CurrentValueSubject<WeatherData?, Never> {get}
    var locationManager: LocationManager? {get}
    func getLocationFromCityName(name: String) async throws  

    
}

class WeatherViewModelImpl: WeatherViewModel {
   
    var weatherData = CurrentValueSubject<WeatherData?, Never>(nil)
    
    var locationManager: LocationManager? {
        didSet{ 
            print("locationManager did set")
            subscribeToLocation()
        }
    }
    
    var geoCodingService: GeocodingService
    
    let apiClient: NetworkClient
    
    var cancellables = Set<AnyCancellable>()
    
    init(geoCodingService: GeocodingService, apiClient: NetworkClient) {
        
        self.geoCodingService = geoCodingService
        self.apiClient = apiClient
        
        DispatchQueue.main.async{
            self.locationManager = UIApplication.shared.sceneDelegate?.locationManager
        }
     
    }
    
    func prepareQueryItems(lat: Double, lon: Double) -> [URLQueryItem] {
        let queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: Environment.apiKey)
        ]
        return queryItems
    }
    
    func fetchData() async throws {
        
        guard let currentLocation = locationManager?.currentLocation,
              let lat = currentLocation.value?.coordinate.latitude,
              let lon = currentLocation.value?.coordinate.longitude else { return }
        
        let queryItems = prepareQueryItems(lat: lat, lon: lon)
        let urlRequest = WeatherAPIRequest()
        urlRequest.queryItems = queryItems
        
        Task{
            do{
                weatherData.value = try await apiClient.fetchData(urlRequest)
                print("SUCCESS")
            }catch {
                print("failed to fetch data")
            }
        }
   
    }
    
    func subscribeToLocation(){
        locationManager?.currentLocation.sink(receiveValue: { location in
            if location != nil{
                Task{
                    try await self.fetchData()
                }
            }
        }).store(in: &cancellables)
    }
    
    func getLocationFromCityName(name: String) async throws  {
        
        locationManager?.currentLocation.value = try await geoCodingService.getLocation(forPlace: name)
     
    }
    
    func higherOrder(){
        
        let numbers: [Int] = [1, 2, 4, 5, 6, 7]
        let items: [Int?] = [1, 3, 4, nil, 7, 9]
        let words = ["123", "john", "345"]
        let optionalNumbers = words.map{Int($0)}
        words.compactMap{ Int($0) }
        numbers.map { $0 * 2}
        optionalNumbers.map{$0.map {$0 * 2}}
        optionalNumbers.flatMap({ $0 })
        
    }
    
   
}


