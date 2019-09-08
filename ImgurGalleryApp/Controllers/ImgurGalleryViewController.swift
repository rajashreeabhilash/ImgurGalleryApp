//
//  ImgurGalleryViewController.swift
//  ImgurGalleryApp
//
//  Created by Rajashree Abhilash on 3/9/19.
//  Copyright © 2019 Rajashree Abhilash. All rights reserved.
//

import UIKit

class ImgurGalleryViewController : UIViewController {
    @IBOutlet weak var imgurGalleryTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toggleButton: UISwitch!
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        return gestureRecognizer
    }()
    
    let imgurGalleryPresenter = ImgurGalleryPresenter()
    var imgurGalleryImagesList : [ImgurGalleryModal] = []
    var displayResultList : [ImgurGalleryModal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        imgurGalleryPresenter.fetchGalleryList(searchText: "") {[weak self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            //Show top images of the week from the Imgur gallery on view load
            if let results = results {
                self?.imgurGalleryImagesList = results
                self?.imgurGalleryTableView.reloadData()
                self?.imgurGalleryTableView.setContentOffset(CGPoint.zero, animated: false)
            }
            
            //Show error message, if any
            if !errorMessage.isEmpty {
                print("Gallery could not be retrived: " + errorMessage)
            }
        }
    }
    
    @IBAction func toggleButtonClicked(_ sender: Any) {
        if (toggleButton.isOn){
            imgurGalleryPresenter.filterGalleryList(galleryList: imgurGalleryImagesList) {[weak self] filteredResult, errorMessage in
                if let filteredArray = filteredResult {
                    //If the toggle is enabled, display filtered results
                    self?.displayResultList = self!.imgurGalleryImagesList
                    self?.imgurGalleryImagesList = filteredArray
                    self?.imgurGalleryTableView.reloadData()
                    self?.imgurGalleryTableView.setContentOffset(CGPoint.zero, animated: false)
                }
            }
        }
        else {
            //If the toggle is disabled, display all results
            self.imgurGalleryImagesList = self.displayResultList
            self.imgurGalleryTableView.reloadData()
            self.imgurGalleryTableView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    @objc func dismissKeyBoard(){
        searchBar.resignFirstResponder()
    }
}

//MARK: - Table view datasource methods
extension ImgurGalleryViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgurGalleryImagesList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewIdentifier = "imgurGalleryCell"
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifier, for: indexPath) as! ImgurGalleryTableViewCell
        
        let ImgurGalleryModal = imgurGalleryImagesList[indexPath.row]
        tableViewCell.Configure(galleryItem: ImgurGalleryModal)
        
        return tableViewCell
    }
}

//MARK: - Table view delegate methods
extension ImgurGalleryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
}

//MARK: - Search bar methods
extension ImgurGalleryViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyBoard()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //Show search query based on user inputs
        imgurGalleryPresenter.fetchGalleryList(searchText: searchBar.text!) {[weak self] results, errorMessage in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let results = results {
                //Search results are sorted in reverse chronological order.
                self?.imgurGalleryImagesList = results.reversed()
                self?.imgurGalleryTableView.reloadData()
                self?.imgurGalleryTableView.setContentOffset(CGPoint.zero, animated: false)
            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapGestureRecognizer)
    }
}




