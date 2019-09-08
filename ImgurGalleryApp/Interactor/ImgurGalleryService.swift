//
//  ImgurGalleryService.swift
//  ImgurGalleryApp
//
//  Created by Rajashree Abhilash on 4/9/19.
//  Copyright © 2019 Rajashree Abhilash. All rights reserved.
//

import Foundation

class ImgurGalleryService: NSObject, URLSessionDelegate, URLSessionDataDelegate  {
    var baseUrlString = "https://api.imgur.com/3/gallery"
    var dataTask : URLSessionDataTask?
    
    let imgurGalleryParser = ImgurGalleryParser()
    var ImgurGalleryList : [ImgurGalleryModal] = []
    var errorMessage = ""
    
    typealias ResponseType = ([ImgurGalleryModal]?, String) -> Void
    
    func getGalleryList(searchText: String, completion: @escaping ResponseType){
        //Cancel any task if it was running
        dataTask?.cancel()

        //If there is no search query, display all results
        var searchUrlString = baseUrlString;
        if (searchText.isEmpty || searchText.count == 0){
            searchUrlString += "/top/top/week/0"
        } else{
            searchUrlString += "/search/top/week/0?q=\(searchText)"
        }
        
        if var urlComponents = URLComponents(string: searchUrlString) {
            guard let url = urlComponents.url else {
                return
            }
            
            //TODO : Client ID has to be sensitive data, store it in keychain.
            var request = URLRequest(url: url)
            request.setValue("Client-ID 1ffd23ef755faf4", forHTTPHeaderField:"Authorization")
            request.httpMethod = "GET"

            let defaultUrlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)

             dataTask = defaultUrlSession.dataTask(with: request) {[weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    self?.errorMessage += "Error retrieving Search query:" + error.localizedDescription
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    //Form the modal class on successful server response
                    self?.imgurGalleryParser.parseResponseData(data: data, completion: { result, errorMessage in
                        if let result = result {
                            self?.ImgurGalleryList .removeAll()
                            self?.ImgurGalleryList = result
                        }
                        self?.errorMessage = errorMessage
                        
                        completion(self?.ImgurGalleryList, self?.errorMessage ?? "")
                    })
                }
            }
            
            //Start the data task
            dataTask?.resume()
        }
    }
    
    func getFilteredResult(galleryList: [ImgurGalleryModal], completion: @escaping ResponseType){
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
    

    //MARK: - URLSessionData Delegate
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
    }
}
