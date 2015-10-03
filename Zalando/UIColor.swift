//
//  UIColor.swift
//  Zalando
//
//  Created by Andriy K. on 10/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

// add a computed property to UIColor to get the HEX string value of the color
extension UIColor {
    var hexValue: String {
        get {
            // prepare the vars for the color coponents
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            // fill the vars with the components' values
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            // prepare a buffer of 4 bytes with the color components' value converted to UInts between 0 and 255
            let rgb = [
                UInt8(red * 255),
                UInt8(green * 255),
                UInt8(blue * 255)
            ]
            
            // convert the 4 Ints to two-digit HEX strings by mapping a closure
            let hex = rgb.map {(i: UInt8) -> String in
                // closure converts Int to HEX string
                var s = String(i, radix: 16)
                // and then adds a leading "0" if necessary
                if (s.characters.count < 2) {
                    s = "0\(s)"
                }
                
                return s
            }
            
            // build the full 6-digit HEX string
            return "#\(hex[0])\(hex[1])\(hex[2])"
            
        }
    }
}

extension UIImage {
  
  func averageColor() -> UIColor {
    
    let pixel: [UInt8] = [0,0,0,0]
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGImageAlphaInfo.PremultipliedLast.rawValue
    let context = CGBitmapContextCreate(UnsafeMutablePointer(pixel), 1, 1, 8, 4, colorSpace, bitmapInfo)
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), CGImage!)
    
    // convert all values in the pixel buffer to CGFloat
    let cg_pixel = pixel.map {CGFloat($0)/255}
    
    // construct a UIColor object from the RGBA components
    return UIColor(
      red: cg_pixel[0],
      green: cg_pixel[1],
      blue: cg_pixel[2],
      alpha: cg_pixel[3]
      )
  }
  
  func labelColor() -> UIColor {
    let c = averageColor()
    return c.blackOrWhiteContrastingColor()
  }
}