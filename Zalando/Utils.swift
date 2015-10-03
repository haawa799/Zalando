//
//  Utils.swift
//  Zalando
//
//  Created by Andriy K. on 10/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

protocol SingleReuseIdentifier {
  static var identifier: String {get}
}

extension SingleReuseIdentifier where Self: UICollectionReusableView {
  static var identifier: String {
    return NSStringFromClass(Self)
  }
}

let black = UIColor(red:0, green:0, blue:0, alpha:1)
let brown = UIColor(red:0.44, green:0.24, blue:0.09, alpha:1)
let beige = UIColor(red:0.83, green:0.75, blue:0.55, alpha:1)
let gray = UIColor(red:0.51, green:0.51, blue:0.51, alpha:1)
let white = UIColor(red:1, green:1, blue:1, alpha:1)
let blue = UIColor(red:0.2, green:0.35, blue:1, alpha:1)
let petrol = UIColor(red:0.13, green:0.64, blue:0.64, alpha:1)
let turquoise = UIColor(red:0.19, green:0.79, blue:0.92, alpha:1)
let green = UIColor(red:0.14, green:0.71, blue:0.23, alpha:1)
let olive = UIColor(red:0.4, green:0.45, blue:0, alpha:1)
let yellow = UIColor(red:1, green:0.99, blue:0, alpha:1)
let orange = UIColor(red:1, green:0.39, blue:0, alpha:1)
let red = UIColor(red:0.92, green:0, blue:0.01, alpha:1)
let pink = UIColor(red:0.93, green:0, blue:0.55, alpha:1)
let lilac = UIColor(red:0.58, green:0.29, blue:0.67, alpha:1)
let gold = UIColor(red:0.76, green:0.6, blue:0.22, alpha:1)
let silver = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1)

let colors = [
  black : "black",
  brown : "brown",
  beige : "beige",
  gray : "gray",
  white : "white",
  blue : "blue",
  petrol : "petrol",
  turquoise : "turquoise",
  green : "green",
  olive : "olive",
  yellow : "yellow",
  orange : "orange",
  red : "red",
  pink : "pink",
  lilac : "lilac",
  gold : "gold",
  silver : "silver"
]

extension UIColor {
  
  func nameOfColor() -> String {
    var name = ""
    if let q = colors[self] {
      name = q
    }
    return name
  }
  
  func closestColorFromSet() -> (color: UIColor, name: String?) {
    
    var color = black
    var name = colors[color]
    
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    
    var minDelta = CGFloat.max
    for c in colors {
      
      var cHue: CGFloat = 0
      var cSaturation: CGFloat = 0
      var cBrightness: CGFloat = 0
      var cAlpha: CGFloat = 0
      c.0.getHue(&cHue, saturation: &cSaturation, brightness: &cBrightness, alpha: &cAlpha)
      
      let hKoef: CGFloat = 0.475
      let sKoef: CGFloat = 0.2875
      let lKoef: CGFloat = 0.375
      
      var delta: CGFloat = 0.0
      delta += CGFloat(abs(cHue - hue)) * hKoef
      delta += CGFloat(abs(cSaturation - saturation)) * sKoef
      delta += CGFloat(abs(cBrightness - brightness)) * lKoef
      
      if delta < minDelta {
        minDelta = delta
        color = c.0
        name = colors[color]
      }
    }
    return (color, name)
  }
}