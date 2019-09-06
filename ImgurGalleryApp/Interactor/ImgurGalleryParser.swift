//
//  ImgurGalleryParser.swift
//  ImgurGalleryApp
//
//  Created by Rajashree Abhilash on 6/9/19.
//  Copyright © 2019 Rajashree Abhilash. All rights reserved.
//

import Foundation

class ImgurGalleryParser {
    typealias JsonDictionary = [String: Any]
    typealias ResponseType = ([ImgurGalleryModal]?, String) -> Void
    
    func parseResponseData(data : Data, completion : @escaping ResponseType){
        var response: JsonDictionary?
        var errorMessage : String = ""
        var imgurGalleryList : [ImgurGalleryModal] = []
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JsonDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let responseArray = response!["data"] as? [Any] else {
            errorMessage += "Dictionary does not contain data key\n"
            return
        }
        
        var index = 0
        for imageDictionary in responseArray {
            if let imageDictionary = imageDictionary as? JsonDictionary,
                let titleString = imageDictionary["title"] as? String,
                let dateTime = imageDictionary["datetime"] as? Double,
                let score = imageDictionary["score"] as? Int,
                let points = imageDictionary["points"] as? Int,
                let topicId = imageDictionary["topic_id"] as? Int,
                let imagesArray = imageDictionary["images"] as? NSArray {
                
                //Convert date to desired date format
                let date = Date(timeIntervalSince1970: dateTime)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/mm/yyyy h:mm a"
                dateFormatter.timeZone = .current;
                dateFormatter.locale = Locale.current
                let localDate = dateFormatter.string(from: date)
                
                //Fetch the first image link from array
                var imageLink : String = ""
                for item in imagesArray {
                    if let item = item as? NSDictionary {
                        let type = item["type"] as? String
                        //Show only images - no videos or gifs
                        if ((type?.hasSuffix("jpeg"))! || (type?.hasSuffix("jpg"))! || (type?.hasSuffix("png"))!) {
                            imageLink = (item["link"] as? String)!
                            break
                        }
                    }
                }
                
                //Add each gallery item to ImgurGalleryList
                imgurGalleryList.append(ImgurGalleryModal(name: titleString, date: localDate, image: imageLink, count: imagesArray.count, points: points, score: score, topic: topicId))
                index += 1
            } else {
                errorMessage += "Problem parsing gallery Images Dictionary\n"
            }
        }
        
        //Pass ImgurGalleryList to the completion handler in Main queue.
        DispatchQueue.main.async {
            completion(imgurGalleryList, errorMessage)
        }
    }
}
