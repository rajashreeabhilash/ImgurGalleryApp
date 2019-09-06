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
        imgurGalleryService.getFilteredResult(galleryList: galleryList) {results, errorMessage in
            completion(results, errorMessage)
        }
    }
}
