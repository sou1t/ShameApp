//
//  TapBar.swift
//  ShameApp
//
//  Created by Виталий Волков on 05.11.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import Foundation
import UIKit

class TapBar: UITabBar{
    required init?(coder aDecoder : NSCoder){
        super.init(coder: aDecoder)
        self.backgroundImage = UIImage.imageWithColor(color: UIColor.clear)
    }
}






extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y:0), size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
