//
//  Album.swift
//  MusicPlayer
//
//  Created by Jameson Quave on 9/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import Foundation

struct Album: Parsable {
    var title: String
    var price: String
    var thumbnailImageURL: String
    var largeImageURL: String
    var itemURL: String
    var artistURL: String
    var collectionId: Int
    
    init(name: String, price: String, thumbnailImageURL: String, largeImageURL: String, itemURL: String, artistURL: String, collectionId: Int)  {
        self.title = name
        self.price = price
        self.thumbnailImageURL = thumbnailImageURL
        self.largeImageURL = largeImageURL
        self.itemURL = itemURL
        self.artistURL = artistURL
        self.collectionId = collectionId
    }
    
    static func initWithJSON(json: JSON) throws -> Album {
        
        let result = json
        
        var name = result["trackName"] as? String
        if name == nil {
            name = result["collectionName"] as? String
        }
        
        // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
        var price = result["formattedPrice"] as? String
        if price == nil {
            price = result["collectionPrice"] as? String
            if price == nil {
                let priceFloat: Float? = result["collectionPrice"] as? Float
                let nf: NSNumberFormatter = NSNumberFormatter()
                nf.maximumFractionDigits = 2
                if priceFloat != nil {
                    price = "$"+nf.stringFromNumber(priceFloat!)!
                }
            }
        }
        
        let thumbnailURL = result["artworkUrl60"] as? String ?? ""
        let imageURL = result["artworkUrl100"] as? String ?? ""
        let artistURL = result["artistViewUrl"] as? String ?? ""
        
        var itemURL = result["collectionViewUrl"] as? String
        if itemURL == nil {
            itemURL = result["trackViewUrl"] as? String
        }
        
        let collectionId = result["collectionId"] as? Int
        
        
        let album = Album(name: name!, price: price!, thumbnailImageURL: thumbnailURL, largeImageURL: imageURL, itemURL: itemURL!, artistURL: artistURL, collectionId: collectionId!)
        
        return album
    }
    
}