//
//  ViewController.swift
//  Zalando
//
//  Created by Andriy K. on 10/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

public struct ShopItem {
  
  enum ItemType {
    case Article
    case ArticleComposition
    case Brand
  }
  
  var type = ItemType.Article
  var imageURL: String = ""
  var name: String = ""
  
  init(chunk: NSDictionary) {
    
    if let article = chunk["article"] as? NSDictionary {
      type = .Article
      imageURL = (article["umage_url"] as? String) ?? ""
      name = (article["description"] as?
        String) ?? ""
    } else if let brand = chunk["brand"] as? NSDictionary {
      type = .Brand
      imageURL = (brand["umage_url"] as? String) ?? ""
      name = (brand["name"] as? String) ?? ""
    }
    else if let articleComposition = chunk["article_composition"] as? NSDictionary {
      type = .ArticleComposition
      imageURL = (articleComposition["umage_url"] as? String) ?? ""
      name = (articleComposition["style_name"] as? String) ?? ""
    }
  }
}

class FeedViewController: UIViewController {
  
  
  @IBOutlet weak var magicLayout: CHTCollectionViewWaterfallLayout! {
    didSet {
      magicLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    }
  }
  
  
  let articleSize = CGSize(width: 400, height: 750)
  let articleComposition = CGSize(width: 1024, height: 889)
  let brandSize = CGSize(width: 100, height: 100)
  
  func cellSize(type: ShopItem.ItemType) -> CGSize {
    var size = CGSizeZero
    switch type {
      case ShopItem.ItemType.Article :
        size = articleSize
      case ShopItem.ItemType.ArticleComposition :
        size = articleComposition
      case ShopItem.ItemType.Brand :
        size = brandSize
    }
    
    let heightBoost = randomBetweenNumbers(0.1, secondNum: 0.35)
    size = CGSize(width: size.width, height: size.height * (1 + heightBoost))
    
    return size
  }
  
  func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
  }
  
  var items = [ShopItem]()
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      collectionView?.dataSource = self
      collectionView?.delegate = self
      let avaliableCellNib = UINib(nibName: "ItemCell", bundle: nil)
      collectionView?.registerNib(avaliableCellNib, forCellWithReuseIdentifier: ItemCell.identifier)
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    reloadData()
  }
  
  func reloadData() {
    ZalandoAPIManager.sharedInstance().authanticate { (token) -> () in
      ZalandoAPIManager.sharedInstance().feed { (response) -> () in
        if let response = response {
          print(response)
          
          self.items = [ShopItem]()
          if let items = response["items"] as? [NSDictionary] {
            for item in items {
              if let item = item as? NSDictionary {
                let s = ShopItem(chunk: item)
                self.items.append(s)
              }
            }
          }
          self.collectionView.reloadData()
        }
      }
    }
  }
  
}

extension FeedViewController: CHTCollectionViewDelegateWaterfallLayout {
  func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
    
    let type = items[indexPath.row].type
    return cellSize(type)
  }
}

extension FeedViewController: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ItemCell.identifier, forIndexPath: indexPath) as! ItemCell
    let item = items[indexPath.row]
    cell.setupWith(item)
    return cell
  }
}

