//
//  Album+Parsable.swift
//  MusicPlayer
//
//  Created by Josh Walker on 1/19/16.
//  Copyright © 2016 JQ Software LLC. All rights reserved.
//

import Foundation

extension Album: Parsable {
 
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