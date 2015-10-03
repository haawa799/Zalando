//
//  ColorView.swift
//  CameraColorPicker
//
//  Created by Leon Weidauer on 22/04/15.
//  Copyright (c) 2015 Leon Weidauer. All rights reserved.
//

import UIKit

// datasource protocol that is implemented by the ViewController
protocol ColorViewDataSource: class {
    func colorForView(sender: ColorView) -> UIColor?
}

// a UIView with some extra functionality to display a colored circle
class ColorView: UIView {
    
    // connection to the datasource
    weak var dataSource: ColorViewDataSource?
    
    // computed property to get the center of the view
    var circleCenter: CGPoint {
        get {
            return convertPoint(center, fromView: superview)
        }
    }
    
    // computed propert to get the radius of the circle
    var circleRadius: CGFloat {
        get {
            return min(bounds.size.width, bounds.size.height) * 0.8 / 2
        }
    }
    
    // replace the UIView's drawRectange method with our own to draw the circle
    override func drawRect(rect: CGRect) {
        print("redraw colorview") // debug output
        
        // we'll use a bezier path. this initialiser of UIBezierPath will produce a cricle
        let path = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        // set line width
        path.lineWidth = 0.5
        
        // set draw color to white
        UIColor(red: 0, green: 0, blue: 0, alpha: 1).set()
        
        // draw circle outline
        path.stroke()
        
        /*
            the datasource method return an Optional UIColor object
            we need to unpack it and only continue of it actually has a value
            
            so we use conditional assignment (if let ... = ...)
        */
        if let fillColor = dataSource?.colorForView(self) {
            // set fill color to the computed color
            fillColor.set()
            // fill the circle
            path.fill()
        }
    }
}