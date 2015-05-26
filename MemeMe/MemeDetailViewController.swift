//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Erwin Santacruz on 5/24/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var meme: UIImageView!
    
    var memeImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        meme.image = memeImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        hideNavigationController()
    }
    
    func hideNavigationController()
    {
        var nav = navigationController!.navigationBarHidden
        navigationController?.setNavigationBarHidden(!nav, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
