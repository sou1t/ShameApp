//
//  Gradient.swift
//  ShameApp
//
//  Created by Виталий Волков on 31.10.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    func makeLayer() -> CAGradientLayer
    {
        let color1 = UIColor(colorLiteralRed: 184/255, green: 0/255, blue: 63/255, alpha: 1)
        let color2 = UIColor(colorLiteralRed: 253/255, green: 165/255, blue: 137/255, alpha: 1)
        
        let gradientCollors = [color1.cgColor, color2.cgColor]
        let gradientLocations = [0.0, 1.0]
        
        let gradientLayer : CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientCollors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        return gradientLayer
    }

    
    
}
