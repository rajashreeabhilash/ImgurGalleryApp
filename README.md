# ImgurGalleryApp

What
Imgur Gallery app searches for the top images of the week from the Imgur gallery and displays it in a list. This app also provides the user the ability to input text as part of the search query.

Each Imgur gallery items shows -
	title
	date of post in local time (DD/MM/YYYY h:mm a) 
	number of additional images in post (if there are multiple) 
	image

Features
	1.	By default Imgur Gallery App displays all results from Imgur gallery (top images of the week)
		API call used is https://api.imgur.com/3/gallery/top/top/week/0
		Client ID is configured to this app via Imgur site (as of now its hardcoded)
	2.	Enter any text in the Search bar to search for particular image search
		API call used is https://api.imgur.com/3/gallery/search/top/week/0?q=\(searchText)
		Result is shown in reverse order
		Empty search will display all the results
	3.	Click on the Filter switch to get only the filtered results 
		If enabled, only the results where the sum of “points”, “score” and “topic_id” adds up to an even number are 		     shown. If disabled, all the results are shown

Installation
	1.	Open ImgurGalleryApp.xcworkspace in Xcode (as Pods are used and opening xcodeproj will result in build errors)
	2.	Run ImgurGalleryApp Target in Simulator
	3.	If pods are causing any build issues - please install pod file via terminal before running.

Requirements
iOS 11 and above
