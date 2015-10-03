//
//  ViewController.swift
//  Zalando
//
//  Created by Andriy K. on 10/3/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit

class ViewController:
  UIViewController,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
  ColorViewDataSource
{
  
  @IBOutlet weak var colorView: ColorView!
  @IBOutlet weak var captureButton: UIButton!
  @IBOutlet weak var colorLabel: UILabel! {
    didSet {
      colorLabel?.textColor = UIColor.blackColor()
    }
  }
  
  var picker: UIImagePickerController? = UIImagePickerController()
  
  var color: UIColor?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    picker?.delegate = self
    colorView.dataSource = self
    
    colorLabel.text = ""
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func captureButtonTapped(sender: UIButton) {
    
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
      UIAlertAction in
      self.openCamera()
    }
    
    var galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
      
      UIAlertAction in
      self.openGallery()
    }
    
    var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
      UIAlertAction in
    }
    
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      alert.addAction(cameraAction)
    }
    
    alert.addAction(galleryAction)
    alert.addAction(cancelAction)
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func openCamera() {
    picker!.sourceType = UIImagePickerControllerSourceType.Camera
    self.presentViewController(picker!, animated: true, completion: {print("camera picker opened")})
  }
  
  func openGallery() {
    picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(picker!, animated: true, completion: {print("gallery picker opened")})
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    print("imagepicker is done")
    picker.dismissViewControllerAnimated(true, completion: nil)
    useImage(info[UIImagePickerControllerOriginalImage] as! UIImage)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController)
  {
    print("imagepicker cancelled")
    picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if let vc = segue.destinationViewController as? ColorPickerViewController, let image = sender as? UIImage {
      vc.delegate = self
      vc.image = image
    }
  }
  
  func useImage(image: UIImage) {
    
    performSegueWithIdentifier("pickSegue", sender: image)
    
//    color = averageColor(image.CGImage!)
    /*
    let details = image.mainColoursDetail(1)
    print(details)
    
    colorLabel.text = "\(color!.hexValue)"
    colorView.setNeedsDisplay()
*/
  }
  
  /*
  datasource method for ColorViewDataSource
  */
  func colorForView(sender: ColorView) -> UIColor? {
    print("colorForView \(color)") // debug output
    
    // just return the stored color to the ColorView
    return color
  }
  
  // copies the text from the color label to the OS's clipboard and shows an alert window
  func copyColorToClipboard() {
    let colorString = colorLabel!.text!
    
    // only continue, if the color string is not empty
    if colorString.characters.count > 0 {
      UIPasteboard.generalPasteboard().string = colorString
      var alert = UIAlertView()
      alert.title = colorString
      alert.message = "Copied to clipboard"
      alert.addButtonWithTitle("Ok")
      alert.show()
    }
  }
  
  // will execute when the colorView's TapGestureRecognizer triggers
  @IBAction func colorViewTap(sender: UITapGestureRecognizer) {
    copyColorToClipboard()
  }
  
  // will execute when the colorLabel's TapGestureRecognizer triggers
  @IBAction func colorLabelTap(sender: UITapGestureRecognizer) {
    copyColorToClipboard()
  }
}

extension ViewController: ColorPickerDelegate {
  func colorSelected(color: UIColor) {
    //
    let c = color.closestColorFromSet()
    let name = c.name
    let col = c.color
    
    self.color = col
    colorLabel.text = "\(name)"
    colorView.setNeedsDisplay()
  }
}
