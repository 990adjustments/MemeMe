//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Erwin Santacruz on 5/19/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet var pickedImageView: UIImageView!
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var meme: Meme!
    var memeArray = [Meme]()
    var memedb =  SharedMemes()
    var activeField = false
    
    //let FONT: String = "HelveticaNeue-CondensedBlack"
    //let FONTSIZE: CGFloat = 40
    
    let textAttributes: [NSString : AnyObject] = [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -3.0,
    ]
    
    @IBAction func shareMeme()
    {
        let memedImage = generateMeme(pickedImageView.image!)
        
        let currentTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyy-HHmmss"
        let dateCreated = formatter.stringFromDate(currentTime)
        println(dateCreated)
        
        meme = Meme(topText: topText, bottomText: bottomText, img: pickedImageView.image!, created:"monday", memedImg: memedImage)
        memeArray.append(meme)
        self.memedb.shared.append(self.meme)
        
        let activityVC = UIActivityViewController(activityItems: memeArray, applicationActivities: nil)
        navigationController?.presentViewController(activityVC, animated: true, completion: nil)
        
        //navigationController?.popToRootViewControllerAnimated(true)
        
//        let tabbarVC = storyboard?.instantiateViewControllerWithIdentifier("SentMemes") as! UItabbar
//        tabbarVC.memes?.append(meme)
//        presentViewController(tabbarVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pickedImageView.alpha = 0.0    
            }) { (Bool) -> Void in
                self.pickedImageView.image = nil
        }
        
        topText.text = nil
        bottomText.text = nil
        
        topText.background = UIImage(named: "border")
        bottomText.background = UIImage(named: "border")
        
        shareButton.enabled = false
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func pickAnImageFromPhotoLibrary()
    {
        pickImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func takeAPictureWithCamera()
    {
        pickImage(UIImagePickerControllerSourceType.Camera)
        
        // Is camera available?
        /*
        if !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear) {
        println("Camera not available")
        
        //let alert = UIAlertView(title: "Camera Device", message: "The camera device is currently not availbale.", delegate: self, cancelButtonTitle: "Cancel")
        //alert.show()
        }
        else {
        pickImage(UIImagePickerControllerSourceType.Camera)
        }
        */
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setTextAttributes()
        shareButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        self.subscribeToKeyboardNotifications()
        self.pickedImageView.alpha = 0.0
        
        setTextAttributes()
        
        tabBarController?.tabBar.hidden = true
        
        // Is source availble?
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        libraryButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        hideNavigationController()
    }
    
    func hideNavigationController()
    {
        //var nav = (navigationController!.navigationBarHidden) ? false : true
        var nav = navigationController!.navigationBarHidden
        navigationController?.setNavigationBarHidden(!nav, animated: true)
    }
    
    func setTextAttributes()
    {
        topText.defaultTextAttributes = textAttributes
        topText.textAlignment = .Center
        bottomText.defaultTextAttributes = textAttributes
        bottomText.textAlignment = .Center
    }
    
    func pickImage(withSourceType:  UIImagePickerControllerSourceType)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = withSourceType
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        let pickedImage = image
        
        if pickedImage != nil {
            picker.dismissViewControllerAnimated(true, completion: { () -> Void in
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.pickedImageView.image = pickedImage
                    self.pickedImageView.alpha = 1.0
                })
            })
            
            shareButton.enabled = true
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        println("User cancelled.")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: NSNotifications -
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextFieldTextDidBeginEditingNotification, object: bottomText)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if !activeField {
            return
        }
        
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        // Return view to original position
        self.view.frame.origin.y = 0
    }
    
    // MARK: TextField Delgate Methods -
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        // Check if bottom text field is being edited
        activeField = textField == bottomText ? true : false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Check if user leaves text field blank
        if count(textField.text) < 1{
            if textField.background != nil {
                return
            }
            else {
                textField.background = UIImage(named: "border")
            }
        }
        else {
            textField.background = nil
        }
    }
    
    // MARK: -
    
    func generateMeme(img: UIImage) -> UIImage
    {
        if navigationController?.navigationBarHidden != true {
            hideNavigationController()
        }
        
        cameraButton.alpha = 0
        libraryButton.alpha = 0
        
        // Render snapshot of view
        println("UIGRAPICS")
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideNavigationController()
        cameraButton.alpha = 1.0
        libraryButton.alpha = 1.0
        println(memedImage)
        
        return memedImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}