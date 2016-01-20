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

enum ParseError: ErrorType {
    case MissingRequiredField(field: String)
    case MissingRequiredValue(field: String)
    case IncorrectFormat(field: String)
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
        throw ParseError.Empty
    }
    
    static func objectsWithJSON(json: JSON) throws -> [Self] {
        let jsonArray: JSONArray
        if let json = json as? JSONArray {
            jsonArray = json
        } else {
            throw ParseError.Empty
        }
        return try jsonArray.map({ try initWithJSON( $0) })
    }
    
    // JSON validation helpers
    
    static func JSONString(object: JSON?, field: String) throws -> String {
        guard let json = object else {
            throw ParseError.MissingRequiredField(field: field)
        }
        if let stringVal = json[field] as? String {
            return stringVal
        } else {
            throw ParseError.MissingRequiredValue(field: field)
        }
    }
    
    static func JSONBool(object: JSON?, field: String) -> Bool {
        if let boolVal = object?[field] as? Bool where boolVal == true {
            return true
        }
        return false
    }
    
    static func JSONInt(object: JSON?, field: String) throws -> Int {
        guard let json = object else {
            throw ParseError.MissingRequiredField(field: field)
        }
        if let intVal = json[field] as? Int {
            return intVal
        } else {
            throw ParseError.MissingRequiredValue(field: field)
        }
    }
    
     static func JSONIntOrString(object: JSON?, field: String) throws -> String {
        guard let json = object else {
            throw ParseError.MissingRequiredField(field: field)
        }
        if let stringVal = json[field] as? String where stringVal != "" {
            return stringVal
        } else if let intVal = json[field] as? Int {
            return String(intVal)
        } else {
            throw ParseError.MissingRequiredValue(field: field)
        }
    }
    
    static func JSONFloatOrString(object: JSON?, field: String) throws -> String {
        guard let json = object else {
            throw ParseError.MissingRequiredField(field: field)
        }
        if let stringVal = json[field] as? String where stringVal != "" {
            return stringVal
        } else if let intVal = json[field] as? Float {
            return String(intVal)
        } else {
            throw ParseError.MissingRequiredValue(field: field)
        }
    }


}
