//
//  Track+Parsable.swift
//  MusicPlayer
//
//  Created by Josh Walker on 1/19/16.
//  Copyright © 2016 JQ Software LLC. All rights reserved.
//

import Foundation

extension Track: Parsable {
    
    static func initWithJSON(json: JSON) throws -> Track {

        // Create the track
        if let kind = try? JSONString(json, field: "kind") where kind == "song" {
                
            let trackPrice = try? JSONString(json, field: "trackPrice")
            let trackTitle = try? JSONString(json, field: "trackName")
            let trackPreviewUrl = try? JSONString(json, field: "previewUrl")
            
            let track = Track(title: trackTitle ?? "Unknown", price: trackPrice ?? "?", previewUrl: trackPreviewUrl ?? "")
            return track
        }
        throw ParseError.Empty
    }
    
    static func objectsWithJSON(json: JSON) throws -> [Track] {
        let jsonArray: JSONArray
        if let json = json as? JSONArray {
            jsonArray = json
        } else {
            throw ParseError.Empty
        }
        return jsonArray.flatMap({ json in
            try? initWithJSON( json)
        })
    }

}