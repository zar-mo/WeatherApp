//
//  UIApplication+.swift
//  WeatherApp
//
//  Created by Abouzar Moradian on 9/25/24.
//

import UIKit

extension UIApplication {
    
    var scene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    var sceneDelegate: SceneDelegate? {
        scene?.delegate as? SceneDelegate
    }
    
   
}
