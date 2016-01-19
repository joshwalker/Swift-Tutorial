//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Jameson Quave on 9/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit
import Kingfisher

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    @IBOutlet var appsTableView : UITableView?
    var albums = [Album]()
    var api : APIController?
    var imageCache = [String : UIImage]()
    let kCellIdentifier: String = "SearchResultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        api!.searchItunesFor("Beatles")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) else { return UITableViewCell() }
        
        let album = self.albums[indexPath.row]
        cell.textLabel?.text = album.title
        
        // Get the formatted price string for display in the subtitle
        let formattedPrice = album.price
        
        // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
        let urlString = album.thumbnailImageURL
        
        if let thumbURL = NSURL(string: urlString) {
            cell.imageView?.kf_setImageWithURL(thumbURL, placeholderImage: UIImage(named: "Blank52"))
        }
        
        cell.detailTextLabel?.text = formattedPrice
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailsViewController: DetailsViewController = segue.destinationViewController as! DetailsViewController
        let albumIndex = appsTableView!.indexPathForSelectedRow!.row
        let selectedAlbum = self.albums[albumIndex]
        detailsViewController.album = selectedAlbum
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        let resultsArr: NSArray = results["results"] as! NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.albums = Album.albumsWithJSON(resultsArr)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

}
