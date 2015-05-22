//
//  Meme.swift
//  MemeMe
//
//  Created by Erwin Santacruz on 5/19/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit

class Meme: NSObject {
    var memeTopText: String?
    var memeBottomText: String?
    var memeImg: UIImage!
    
    init(topText: UITextField!, bottomText: UITextField!, img: UIImage, memedImg: UIImage) {
        self.memeImg = img
    }
}