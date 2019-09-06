//
//  ImgurGalleryTableViewCell.swift
//  ImgurGalleryApp
//
//  Created by Rajashree Abhilash on 4/9/19.
//  Copyright © 2019 Rajashree Abhilash. All rights reserved.
//

import UIKit
import SDWebImage

class ImgurGalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imagePostedDate: UILabel!
    @IBOutlet weak var galleryImage: UIImageView!
    @IBOutlet weak var imagesCount: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.layer.borderUIColor = UIColor.lightGray
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    func Configure(galleryItem : ImgurGalleryModal) {
        imageTitle.text = galleryItem.imageName
        imagePostedDate.text = galleryItem.imagePostedDate
        imagesCount.text = String(galleryItem.numberOfImages)
        
        //Show number of additional images in post only if there are multiple
        if (galleryItem.numberOfImages > 1){
            imagesCount.isHidden = false;
        } else {
            imagesCount.isHidden = true;
        }
        
        //Lazy loading of the images using Pod
        galleryImage.sd_setImage(with: URL(string: galleryItem.galleryImageLink), placeholderImage: UIImage(named: "placeholder.png"))
    }
}

extension CALayer {
    var borderUIColor : UIColor {
        get { return UIColor(cgColor: self.borderColor!) }
        set { self.borderColor = newValue.cgColor }
    }
}
