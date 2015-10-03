//
//  ColorPickerViewController.swift
//  Zalando
//
//  Created by Andriy K. on 10/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate: class {
  func colorSelected(color: UIColor)
}

class ColorPickerViewController: UIViewController {
  
  weak var delegate: ColorPickerDelegate?
  
  
  @IBOutlet weak var scrollView: UIScrollView! {
    didSet {
      scrollView?.delegate = self
    }
  }
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView?.dataSource = self
      tableView?.delegate = self
      tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "colorCell")
//      tableView?.separatorColor = UIColor.clearColor()
//      tableView?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
  }
  
  var image: UIImage? {
    didSet {
      if let image = image {
        colors = [(UIColor, Float)]()
        let details = image.mainColoursDetail(3)
        for detail in details {
          if let q = detail.0 as? (UIColor) {
            let g = Float(detail.1 as! NSNumber)
            colors.append((q, g))
          }
        }
        colors.sortInPlace({ (a, b) -> Bool in
          return a.1 > b.1
        })
      }
      tableView?.reloadData()
    }
//    imageView.image = image
//    imageView.bounds = CGRect(0,0,image.size.width, image.size.height)
//    UIImage *image = [UIImage imageNamed:@"board"];
//    _imageView.image = image;
//    _imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
//    - (void)viewDidLayoutSubviews
//    {
//    _scrollView.contentSize = _imageView.bounds.size;
//    }
  }
  
  var colors = [(UIColor, Float)]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView?.image = image
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    scrollView.contentSize = imageView.bounds.size
  }
  
  @IBAction func tap(sender: UITapGestureRecognizer) {
    if sender.state == UIGestureRecognizerState.Recognized {
      if self.imageView.contentMode == UIViewContentMode.ScaleAspectFill {
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
      } else {
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
      }
    }
  }
  
}

extension ColorPickerViewController: UITableViewDataSource {
  
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return colors.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("colorCell")!
    cell.backgroundColor = colors[indexPath.row].0
    cell.textLabel?.text = "\(Int(colors[indexPath.row].1 * 100))%"
    cell.textLabel?.textAlignment = NSTextAlignment.Center
    cell.textLabel?.textColor = cell.backgroundColor?.blackOrWhiteContrastingColor()
    return cell
  }
  
}

extension ColorPickerViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return tableView.bounds.height * CGFloat(colors[indexPath.row].1)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let c = colors[indexPath.row].0
    delegate?.colorSelected(c)
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension ColorPickerViewController: UIScrollViewDelegate {
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
