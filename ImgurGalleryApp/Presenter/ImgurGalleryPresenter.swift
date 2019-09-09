//
//  ImgurGalleryPresenter.swift
//  ImgurGalleryApp
//
//  Created by Rajashree Abhilash on 6/9/19.
//  Copyright © 2019 Rajashree Abhilash. All rights reserved.
//

import Foundation

class ImgurGalleryPresenter {
    let imgurGalleryService = ImgurGalleryService()
    typealias ResponseType = ([ImgurGalleryModal]?, String) -> Void
    
    func fetchGalleryList(searchText: String, completion: @escaping ResponseType){
        imgurGalleryService.getGalleryList(searchText: searchText) {results, errorMessage in
            completion(results, errorMessage)
        }
    }
    
    func filterGalleryList(galleryList: [ImgurGalleryModal], completion: @escaping ResponseType){
        var filteredResult : [ImgurGalleryModal] = []
        for galleryItem : ImgurGalleryModal in galleryList {
            //Filter results where the sum of “points”, “score” and “topic_id” adds up to an even number
            if ((galleryItem.score + galleryItem.points + galleryItem.topicId) % 2 == 0){
                filteredResult.append(galleryItem)
            }
        }
        
        //Switch to the main queue to pass filtered result to the completion handler.
        DispatchQueue.main.async {
            completion(filteredResult, "")
        }
    }
}
