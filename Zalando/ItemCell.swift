//
//  ItemCell.swift
//  Zalando
//
//  Created by Andriy K. on 10/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import SDWebImage

class ItemCell: UICollectionViewCell, SingleReuseIdentifier {
  
  @IBOutlet private weak var imageView: UIImageView! {
    didSet {
      imageView?.addNaturalOnTopEffect()
    }
  }
  @IBOutlet private weak var botRightLabel: UILabel!
  
  func setupWith(shopItem: ShopItem) {
    let url = NSURL(string: shopItem.imageURL)!
    if shopItem.type == .Brand {
      imageView.contentMode = UIViewContentMode.ScaleAspectFill
    }
    imageView.contentMode = UIViewContentMode.Top
    imageView.sd_setImageWithURL(url)
    botRightLabel?.text = shopItem.name
  }

  
  
}

extension UIView {
  func addNaturalOnTopEffect(maximumRelativeValue : Float = 20.0) {
    //Horizontal motion
    var motionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis);
    motionEffect.minimumRelativeValue = maximumRelativeValue;
    motionEffect.maximumRelativeValue = -maximumRelativeValue;
    addMotionEffect(motionEffect);
    
    //Vertical motion
    motionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis);
    motionEffect.minimumRelativeValue = maximumRelativeValue;
    motionEffect.maximumRelativeValue = -maximumRelativeValue;
    addMotionEffect(motionEffect);
  }
  
  func addNaturalBelowEffect(maximumRelativeValue : Float = 20.0) {
    addNaturalOnTopEffect(-maximumRelativeValue)
  }
}
