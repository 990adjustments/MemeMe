//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Erwin Santacruz on 5/19/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet var pickedImageView: UIImageView?
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    
    var meme: Meme!
    var memeDB: [Meme]!
    var activeField = false
    
    let textAttributes: [NSString : AnyObject] = [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -3.0,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextAttributes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.subscribeToKeyboardNotifications()
        self.pickedImageView?.alpha = 0.0
        
        setTextAttributes()
        
        // Is source availble?
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        libraryButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("tap")
        
        var nav = (navigationController!.navigationBarHidden) ? false : true
        println(nav)
        
        navigationController?.setNavigationBarHidden(nav, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func setTextAttributes()
    {
        
        topText.defaultTextAttributes = textAttributes
        topText.textAlignment = .Center
        bottomText.defaultTextAttributes = textAttributes
        bottomText.textAlignment = .Center
    }
    
    @IBAction func newMeme()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pickedImageView?.alpha = 0.0
        }) { (Bool) -> Void in
            self.pickedImageView?.image = nil
        }
        
        self.topText.text = nil
        self.bottomText.text = nil
        
        self.topText.background = UIImage(named: "border")
        self.bottomText.background = UIImage(named: "border")
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
    
    func pickImage(withSourceType:  UIImagePickerControllerSourceType)
    {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = withSourceType
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        var pickedImage = image
        
        if pickedImage != nil {
            meme = Meme(img: pickedImage)
            picker.dismissViewControllerAnimated(true, completion: { () -> Void in
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.pickedImageView?.image = self.meme.memeImg
                    self.pickedImageView?.alpha = 1.0
                })
            })
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        println("User cancelled.")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func subscribeToKeyboardNotifications()
    {
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UITextFieldTextDidBeginEditingNotification, object: bottomText)
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
        self.view.frame.origin.y = 0
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        // Check if bottom text field is being edited
        activeField = textField == bottomText ? true : false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Check if user leaves text field blank
        if count(textField.text) < 1{
            println(count(textField.text))
            return
        }
        else {
            textField.background = nil
            println(count(textField.text))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}