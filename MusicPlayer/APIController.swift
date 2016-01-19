//
//  APIController.swift
//  MusicPlayer
//
//  Created by Jameson Quave on 9/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import Foundation

typealias completionHandler = (NSDictionary) -> ()

private enum Path {
    case Search(term: String)
    case Lookup(albumID: String)
    
    func urlString() -> String {
        switch self {
        case let .Search(term: term):
            let escapedSearchTerm = escapeURLString(term)
            return "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
        case let .Lookup(albumID: albumID):
            return "https://itunes.apple.com/lookup?id=\(albumID)&entity=song"
        }
    }
    
    func escapeURLString(string: String) -> String {
        let unspacedString = string.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedString = unspacedString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) {
            return escapedString
        }
        return unspacedString
    }
}

class APIController {
    
    func get(path: String, completion: completionHandler) throws -> Void {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            print("Task completed")
            guard let data = data else {return}
            if let error = error {
                // If there is an error in the web request, print it to the console
                print(error.localizedDescription)
            }
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    //self.delegate?.didReceiveAPIResults(jsonResult)
                    completion(jsonResult)
                    
                }
            } catch {
                print("Parse Error")
            }
        })
        task.resume()
    }
    
    func searchItunesFor(searchTerm: String, completion: completionHandler) throws -> Void {
        try get(Path.Search(term: searchTerm).urlString(), completion:  completion)
    }
    
    func lookupAlbum(collectionId: Int, completion: completionHandler) throws -> Void {
        try get(Path.Lookup(albumID: String(collectionId)).urlString(), completion: completion)
    }
    
}