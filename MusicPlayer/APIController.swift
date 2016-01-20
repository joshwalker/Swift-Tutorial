//
//  APIController.swift
//  MusicPlayer
//
//  Created by Jameson Quave on 9/16/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import Foundation

enum APIError: ErrorType {
    case Parse(message: String)
    case JSONDeserialzation(message: String)
    case NetworkRequest(message: String)
    case NoMoreResults(message: String)
    case Offline(message: String)
    case Unknown(message: String)
    
    func description() -> String {
        switch self {
        case .Parse(let message):
            return "parse error: \(message)"
        case .NetworkRequest(let message):
            return "network error: \(message)"
        case .JSONDeserialzation(let message):
            return "json serialization error: \(message)"
        case .NoMoreResults(let message):
            return "no more results error: \(message)"
        case .Offline(let message):
            return "device offline: \(message)"
        case .Unknown(let message):
            return "unknown error: \(message)"
        }
    }
}

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
    
    func get<P: Parsable>(path: String, completion: ([P]) -> ()) throws -> Void {
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
                let results: [P] = try P.deserializeData(data)
                completion(results)
            } catch ParseError.MissingRequiredField(let field) {
                print("Missing Required Field: \(field)")
            } catch ParseError.IncorrectFormat(let field) {
                print("Incorrect Format for Field: \(field)")
            } catch ParseError.Empty {
                print("Parser returned empty data set")
            } catch let parseError as NSError {
                print(parseError.localizedDescription)
            } catch {
                print("Unknown Error")
            }
        })
        task.resume()
    }
    
    func searchItunesFor(searchTerm: String, completion: ([Album]) -> Void) throws -> Void {
        try get(Path.Search(term: searchTerm).urlString(), completion: completion)
    }
    
    func lookupAlbum(collectionId: Int, completion: ([Track]) -> Void) throws -> Void {
        try get(Path.Lookup(albumID: String(collectionId)).urlString(), completion: completion)
    }
    
}