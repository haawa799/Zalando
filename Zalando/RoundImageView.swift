//
//  RoundImageView.swift
//  Andrew-Kharchyshyn
//
//  Created by Andrew  K. on 4/21/15.
//  Copyright (c) 2015 Andrew  K. All rights reserved.
//

import UIKit

class RoundImageView: RoundedImageView {
    
    private func updateCornerRadius() {
        layer.cornerRadius = bounds.size.height*0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }

}
