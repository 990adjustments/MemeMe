//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Erwin Santacruz on 5/19/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var meme: Meme!
    var activeField = false
    
    //let FONT: String = "HelveticaNeue-CondensedBlack"
    //let FONTSIZE: CGFloat = 40
    
    let textAttributes: [NSString : AnyObject] = [
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -3.0,
    ]
    
    // MARK: IBActions -
    
    @IBAction func shareMeme()
    {
        let currentTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let dateCreated = formatter.stringFromDate(currentTime)
        
        let memedImage = generateMeme(pickedImageView.image!)
        
        meme = Meme(topText: topText.text, bottomText: bottomText.text, img: pickedImageView.image!, created:dateCreated, memedImg: memedImage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memesDB.append(meme)

        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        activityVC.completionWithItemsHandler = {
            (activityType:String!, completed:Bool, returnedItems:[AnyObject]!, activityError:NSError!) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
    
        navigationController?.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme()
    {
        memeEditorCleanup()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func pickAnImageFromPhotoLibrary()
    {
        pickImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func takeAPictureWithCamera()
    {
        pickImage(UIImagePickerControllerSourceType.Camera)
    }
    
    // MARK: Overridden methods -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setTextAttributes()
        shareButton.enabled = false
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        subscribeToKeyboardNotifications()
        pickedImageView.alpha = 0.0
        
        tabBarController?.tabBar.hidden = true
        
        // Is source availble?
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        libraryButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
        
        tabBarController?.tabBar.hidden = false
        memeEditorCleanup()
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        let nav = navigationController!.navigationBarHidden
        
        hideNavigationController(nav)
        hideButtonsOnOff(0.3, on: nav)
        
        topText.resignFirstResponder()
        bottomText.resignFirstResponder()
    }
    
    func hideNavigationController(hide: Bool)
    {
        navigationController?.setNavigationBarHidden(!hide, animated: true)
    }
    
    func hideButtonsOnOff(duration: NSTimeInterval, on: Bool)
    {
        if on {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.cameraButton.alpha = 1.0
                self.libraryButton.alpha = 1.0
            })
        }
        else {
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.cameraButton.alpha = 0
                self.libraryButton.alpha = 0
            })
        }
    }
    
    func memeEditorCleanup()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pickedImageView.alpha = 0.0
            }) { (Bool) -> Void in
                self.pickedImageView.image = nil
        }
        
        self.topText.text = nil
        self.bottomText.text = nil
        
        self.topText.background = UIImage(named: "border")
        self.bottomText.background = UIImage(named: "border")
        
        self.shareButton.enabled = false
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
    
    func generateMeme(img: UIImage) -> UIImage
    {
        if navigationController?.navigationBarHidden != true {
            hideNavigationController(false)
        }
        
        cameraButton.alpha = 0
        libraryButton.alpha = 0
        
        // Render snapshot of view
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideNavigationController(true)
        
        cameraButton.alpha = 1.0
        libraryButton.alpha = 1.0
        
        return memedImage
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
        }
        
        enableShareButton()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func enableShareButton()
    {
        if (count(topText.text) != 0 && count(bottomText.text) != 0) && pickedImageView.image != nil {
            shareButton.enabled = true
        }
    }
    
    // MARK: NSNotifications -
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
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
        // If top UITextField is being edited do not move up view
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
        // Setting attributes here because text attributes seem to reset
        // when UITextField is clicked on and left blank
        setTextAttributes()
        
        // Check if bottom text field is being edited
        activeField = textField == bottomText ? true : false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Check if user leaves UITextField blank
        if count(textField.text) < 1{
            if textField.background != nil {
                return
            }
            else {
                textField.background = UIImage(named: "border")
            }
        }
        else {
            // There is text present so remove background image
            textField.background = nil
            enableShareButton()
        }
    }
    
    // MARK: -

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}