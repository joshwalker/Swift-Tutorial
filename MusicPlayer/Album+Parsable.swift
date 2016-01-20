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
        
        let name: String
        if let trackName = try? JSONString(json, field: "trackName") {
            name = trackName
        } else {
            name = try JSONString(json, field: "collectionName")
        }
        
        // Sometimes price comes in as formattedPrice, sometimes as collectionPrice.. and sometimes it's a float instead of a string. Hooray!
        var price: String
        if let formattedPrice = try? JSONString(json, field: "formattedPrice") {
            price = formattedPrice
        } else {
            price = try JSONFloatOrString(json, field: "collectionPrice")
        }
        
        
        let thumbnailURL = try? JSONString(json, field: "artworkUrl60")
        let imageURL = try? JSONString(json, field: "artworkUrl100")
        let artistURL = try? JSONString(json, field: "artistViewUrl")
        
        let collectionViewURL = try? JSONString(json, field: "collectionViewUrl")
        
        let itemURL: String
        if let collectionViewURL = collectionViewURL {
            itemURL = collectionViewURL
        } else {
            itemURL = try JSONString(json, field: "trackViewUrl")
        }
        
        let collectionId = try JSONInt(json, field: "collectionId")
        
        
        let album = Album(name: name, price: price, thumbnailImageURL: thumbnailURL ?? "", largeImageURL: imageURL ?? "", itemURL: itemURL, artistURL: artistURL ?? "", collectionId: collectionId)
        
        return album
    }

}