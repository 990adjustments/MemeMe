//
//  Meme.swift
//  MemeMe
//
//  Created by Erwin Santacruz on 5/19/15.
//  Copyright (c) 2015 Erwin Santacruz. All rights reserved.
//

import UIKit

class Meme: NSObject {
    var topText: String!
    var bottomText: String!
    var img: UIImage!
    var memedImg: UIImage!
    var created: String!
    
    init(topText: String, bottomText: String, img: UIImage, created: String, memedImg: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.img = img
        self.memedImg = memedImg
        self.created = created
    }
}