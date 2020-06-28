//
//  UIColor+CustomColor.swift
//  HouseLog
//
//  Created by Arthur Boulliard on 27/06/2020.
//  Copyright © 2020 Arthur Boulliard. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {

    class var customGreen: UIColor {
        let darkGreen = 0x008110
        return UIColor.rgb(fromHex: darkGreen)
    }

    class func rgb(fromHex: Int) -> UIColor {

        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
