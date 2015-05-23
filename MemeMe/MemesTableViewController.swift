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
    
    //var sentMemes = [SentMemes]()
    var memesDB = SharedMemes()
    var memes: [Meme]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memesDB.shared.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //println(888)
        let cell = tableView.dequeueReusableCellWithIdentifier(TABLE_CELL) as! UITableViewCell
        let meme = memesDB.shared[indexPath.row]
        //println(memesDB.shared[indexPath.row])
        cell.textLabel!.text = meme.topText.text
        
        return cell
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
