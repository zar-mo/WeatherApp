//
//  Weather.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/24/24.
//
import Foundation

struct WeatherData : Codable {
    let coord : Coordinate
    let cod, visibility, id, timezone : Int
    let name : String
    let base : String
    let weather : [Weather]
    let sys : Sys
    let main : Main
    let wind : Wind
    let dt : Date
}

struct Coordinate : Codable {
    let lat, lon : Double
}

struct Weather : Codable {
    let id : Int
    let icon : String
    let main : String
    let description: String
}

struct Sys : Codable {
    let type, id : Int
    let sunrise, sunset : Date
    let country : String
}

struct Main : Codable {
    let temp, tempMin, tempMax, feelsLike : Double
    let pressure, humidity, seaLevel, grndLevel : Int
}

struct Wind : Codable {
    let speed : Double
    let deg : Double?
    let gust : Double?
}




/*
 {"coord":{"lon":10.99,"lat":44.34},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"base":"stations","main":{"temp":289.06,"feels_like":288.64,"temp_min":288.85,"temp_max":290.49,"pressure":1011,"humidity":74,"sea_level":1011,"grnd_level":944},"visibility":10000,"wind":{"speed":2.5,"deg":192,"gust":4.19},"clouds":{"all":95},"dt":1727198013,"sys":{"type":2,"id":2004688,"country":"IT","sunrise":1727154344,"sunset":1727197812},"timezone":7200,"id":3163858,"name":"Zocca","cod":200}
 */
