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
    var addButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Set up UIBar buttons
        editButton = editButtonItem()
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("pushMemeMeEditor"))
        
        navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        editButton.enabled = !appDelegate.memesDB.isEmpty
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: true)
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
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        println(__FUNCTION__)
        
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            appDelegate.memesDB.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            
            // Disable Edit button if no memes
            if appDelegate.memesDB.isEmpty {
                setEditing(false, animated: true)
                editButton.enabled = false
            }
        }
    }
    
    func pushMemeMeEditor()
    {
        let editorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeEditorViewController
        navigationController?.pushViewController(editorVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
