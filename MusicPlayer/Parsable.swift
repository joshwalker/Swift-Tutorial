//
//  Parsable.swift
//  MusicPlayer
//
//  Created by Josh Walker on 1/19/16.
//  Copyright © 2016 JQ Software LLC. All rights reserved.
//

import Foundation

typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

enum APIError: ErrorType {
    case Parse(message: String)
    case JSONDeserialzation(message: String)
    case Empty
}

protocol Parsable {
    static func deserializeData(data: NSData) throws -> [Self]
    static func buildModel(json: JSON) throws -> [Self]
    static func objectsWithJSON(json: JSON) throws -> [Self]
    static func initWithJSON(json: JSON) throws -> Self
}

extension Parsable {
    
    static func deserializeData(data: NSData) throws -> [Self] {
        var jsonOptional: JSON?
        do {
            jsonOptional = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
        } catch let error as NSError {
            throw APIError.JSONDeserialzation(message: error.localizedDescription)
        }
        if let json = jsonOptional {
            return try buildModel(json)
        }
        
        throw APIError.Parse(message: "JSON Deserialize failed")
    }
    
    static func buildModel(json: JSON) throws -> [Self] {
        if let dataElement: JSON = json["results"] {
            let elements = try objectsWithJSON(dataElement)
            return elements
        }
        throw APIError.Empty
    }
    
    static func objectsWithJSON(json: JSON) throws -> [Self] {
        let jsonArray: JSONArray
        if let json = json as? JSONArray {
            jsonArray = json
        } else {
            throw APIError.Empty
        }
        return try jsonArray.map({ try initWithJSON( $0) })
    }

}