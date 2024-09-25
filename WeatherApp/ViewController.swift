//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/24/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiCall()
        print("View Did Load")
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate{
            let locationManager = sceneDelegate.locationManager
            
            locationManager?.currentLocation.sink(receiveValue: { location in
                print("location updated \(location)")
                
                
            }).store(in: &cancellables)
            
            
        }
      
    }
   
    
    func apiCall(){
        
        var components = URLComponents()

        // Query Items: lat, lon, appid
        let queryItems = [
            URLQueryItem(name: "lat", value: "44.34"),
            URLQueryItem(name: "lon", value: "10.99"),
            URLQueryItem(name: "appid", value: "9e7b3accfbb06e554c8c588391ff845e")
        ]
        
        let urlRequest = WeatherAPIRequest()
        urlRequest.queryItems = queryItems
        let apiClinet = APIClient()
        Task{
            do{
                try await apiClinet.fetchData(urlRequest)
            }catch {
                print("failed to fetch data")
            }
        }
        
        
    }


}

