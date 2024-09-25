//
//  Environment.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/25/24.
//

import Foundation


public enum Environment {
    enum Keys {
        static let apiKey = "APIKey"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else { fatalError("Config plist not found") }
        return dict
    }()
    
    static let apiKey: String = {
        guard let key = Environment.infoDictionary[Keys.apiKey] as? String else { fatalError("APIKey is not defined in plist") }
        
        print(key)
        return key
    }()
    
}
