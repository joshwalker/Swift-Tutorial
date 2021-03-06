//
//  DetailsViewController.swift
//  MusicPlayer
//
//  Created by Jameson Quave on 9/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit
import MediaPlayer
import Kingfisher

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var album: Album?
    var tracks = [Track]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var tracksTableView: UITableView!
    lazy var api : APIController = APIController()
    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.album?.title
        
        if let
            largeImageURLString = album?.largeImageURL,
            largeImageURL = NSURL(string: largeImageURLString)
        {
            albumCover.kf_setImageWithURL(largeImageURL)
        }
        if self.album != nil {
            try? api.lookupAlbum(self.album!.collectionId) { results in
                dispatch_async(dispatch_get_main_queue(), {
                    self.tracks = results
                    self.tracksTableView.reloadData()
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })

            }
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackCell
        let track = tracks[indexPath.row]
        cell.titleLabel.text = track.title
        cell.playIcon.text = "▶️"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = tracks[indexPath.row]
        mediaPlayer.stop()
        mediaPlayer.contentURL = NSURL(string: track.previewUrl)
        mediaPlayer.play()
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackCell {
            cell.playIcon.text = "◾️"
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animateWithDuration(0.25, animations: {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
    }
    
}