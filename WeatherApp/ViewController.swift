//
//  ViewController.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/24/24.
//

import UIKit
import Combine
import MapKit
import Kingfisher

class ViewController: UIViewController {
    
    var locationManager : LocationManager?
    var cancellables = Set<AnyCancellable>()
    var viewModel: WeatherViewModel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameTF: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = UIApplication.shared.sceneDelegate?.locationManager
        subscripeToLocation()
        subscripeToWeather()
        
    }
    
    @IBAction func selectCityButton(_ sender: UIButton) {
        
        if let name = cityNameTF.text, !name.isEmpty{
            
            Task{
                do{
                    try await viewModel.getLocationFromCityName(name: name)
                }
            }
        }
        
    }
    
    
}

// MARK: - methods

extension ViewController{
    
    
    func subscripeToLocation(){
        
        locationManager?.currentLocation.sink(receiveValue: { location in
            
            DispatchQueue.main.async{
                self.mapSetup()
            }
            
        }).store(in: &cancellables)
    }
    
    func subscripeToWeather(){
        
        viewModel.weatherData.sink(receiveValue: {  weather in
            
            DispatchQueue.main.async{
                self.cityNameLabel.text = weather?.name
                
                if let kelvinTemp = weather?.main.temp {
                    let fahrenheitTemp = (kelvinTemp - 273.15) * 9/5 + 32
                    self.tempratureLabel.text = String(format: "%.1f°F", fahrenheitTemp)
                }
                if let iconCode = weather?.weather.first?.icon{
                    let imageUrl = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
                    self.iconImageView.kf.setImage(with: URL(string: imageUrl))
                }
                
            }
            
        }).store(in: &cancellables)
    }
    
    func mapSetup(){
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        if let location = viewModel.locationManager?.currentLocation.value?.coordinate{
           let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            mapView.addAnnotation(pin)
        
            
        }
    }
}

