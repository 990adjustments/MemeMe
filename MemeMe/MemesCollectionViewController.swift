//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Erwin Santacruz on 5/22/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let COLLECTION_CELL = "MemeCollectionCell"
    
    var appDelegate: AppDelegate!
    var editButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // If there are no Memes, show Editor
        if appDelegate.memesDB.isEmpty {
            pushMemeMeEditor()
        }
        
        // Set up UIBar buttons
        editButton = editButtonItem()
        addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("pushMemeMeEditor"))
        
        navigationItem.setRightBarButtonItems([addButton, editButton], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        
        editButton.enabled = !appDelegate.memesDB.isEmpty
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memesDB.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(COLLECTION_CELL, forIndexPath: indexPath) as! MemesCollectionViewCell
        let memeAtIndexPath = appDelegate.memesDB[indexPath.row]
        
        cell.memeImage.image = memeAtIndexPath.memedImg

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Check if in editing mode
        if editing {
            appDelegate.memesDB.removeAtIndex(indexPath.row)
            collectionView.deleteItemsAtIndexPaths([indexPath])
            collectionView.reloadData()
            
            // Disable Edit button if no memes
            if appDelegate.memesDB.isEmpty {
                setEditing(false, animated: true)
                editButton.enabled = false
            }
        }
        else {
            let detailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeImage") as! MemeDetailViewController
            let memeAtIndexPath = appDelegate.memesDB[indexPath.row]
            
            detailVC.memeImage = memeAtIndexPath.memedImg
            detailVC.navigationItem.title = memeAtIndexPath.created
            
            navigationController?.pushViewController(detailVC, animated: true)
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