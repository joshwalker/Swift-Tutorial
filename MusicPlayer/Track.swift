//
//  Track.swift
//  MusicPlayer
//
//  Created by Jameson Quave on 9/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import Foundation

struct Track: Parsable {
    
    var title: String
    var price: String
    var previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    static func initWithJSON(json: JSON) throws -> Track {
        
        print(json)
        let trackInfo = json
                           // Create the track
        if let kind = trackInfo["kind"] as? String {
            if kind=="song" {
                
                var trackPrice = trackInfo["trackPrice"] as? String
                var trackTitle = trackInfo["trackName"] as? String
                var trackPreviewUrl = trackInfo["previewUrl"] as? String
                
                if(trackTitle == nil) {
                    trackTitle = "Unknown"
                }
                else if(trackPrice == nil) {
                    print("No trackPrice in \(trackInfo)")
                    trackPrice = "?"
                }
                else if(trackPreviewUrl == nil) {
                    trackPreviewUrl = ""
                }
                
                let track = Track.init(title: trackTitle!, price: trackPrice!, previewUrl: trackPreviewUrl!)
                return track
            }
        }
        throw APIError.Empty
    }
    
    static func objectsWithJSON(json: JSON) throws -> [Track] {
        let jsonArray: JSONArray
        if let json = json as? JSONArray {
            jsonArray = json
        } else {
            throw APIError.Empty
        }
        return jsonArray.flatMap({ json in
            try? initWithJSON( json)
        })
    }
    
}