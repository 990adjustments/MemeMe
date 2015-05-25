//
//  MemesViewController.swift
//  MemeMe
//
//  Created by Erwin Santacruz on 5/19/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit

class MemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let TABLE_CELL = "MemeTableCell"
    
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memesDB.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TABLE_CELL) as! MemesTableViewCell
        let memeAtIndexPath = appDelegate.memesDB[indexPath.row]
        
        cell.topText.text = memeAtIndexPath.topText
        cell.bottomText.text = memeAtIndexPath.bottomText
        cell.memeImage.image = memeAtIndexPath.memedImg
        cell.dateCreated.text = memeAtIndexPath.created

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeImage") as! MemeDetailViewController
        let memeAtIndexPath = appDelegate.memesDB[indexPath.row]
        
        detailVC.memeImage = memeAtIndexPath.memedImg
        detailVC.navigationItem.title = memeAtIndexPath.created
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Delete row on swipe
        if editingStyle == UITableViewCellEditingStyle.Delete {
            appDelegate.memesDB.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
        }
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
