//
//  ImgurGalleryModal.swift
//  ImgurGalleryApp
//
//  Created by Rajashree Abhilash on 4/9/19.
//  Copyright © 2019 Rajashree Abhilash. All rights reserved.
//

import Foundation

struct ImgurGalleryModal {
    let imageName : String
    let imagePostedDate : String
    let numberOfImages : Int
    let galleryImageLink : String
    let points : Int
    let score : Int
    let topicId : Int
    
    init(name: String, date: String, image: String, count: Int, points: Int, score : Int, topic : Int) {
        self.imageName = name
        self.imagePostedDate = date
        self.numberOfImages = count
        self.galleryImageLink = image
        self.points = points
        self.score = score
        self.topicId = topic
    }
}
