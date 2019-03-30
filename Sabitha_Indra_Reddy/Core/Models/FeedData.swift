//
//  FeedData.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 29/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation

class FeedData: Codable {
    
    var feed_id: String?
    var feed_name: String?
    var feed_desc: String?
    var feed_images: [FeedImage]?
    var feed_videolink: String?
    var feed_type: String?
    var feed_sharelink: String?
    var feed_date: String?
    
}

class FeedImage: Codable {
    var image_id: String?
    var image_name: String?
    
}
