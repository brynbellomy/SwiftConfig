//
//  Config.JSONLayer.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Nov 5.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftyJSON
import Funky
import LlamaKit


public extension Config
{
    public init?(yamlFilename:String, bundle:AnyClass)
    {
        if let layer = JSONLayer(yamlFilename:yamlFilename, bundle:bundle) {
            self = Config(layer:layer)
        }
        else { return nil }
    }

    public init?(jsonFilename:String, bundle:AnyClass)
    {
        if let layer = JSONLayer(jsonFilename:jsonFilename, bundle:bundle) {
            self = Config(layer:layer)
        }
        else { return nil }
    }

    public struct JSONLayer
    {
        private let json :JSON = JSON.nullJSON

        public init?(yamlFilename:String, bundle:AnyClass)
        {
            if let j = JSON(yamlFilename:yamlFilename, bundle:bundle) {
                json = j
            }
            else {
                return nil
            }
        }

        public init?(jsonFilename:String, bundle:AnyClass)
        {
            if let j = JSON(jsonFilename:jsonFilename, bundle:bundle) {
                json = j
            }
            else {
                return nil
            }
        }

        public init(json j:JSON) {
            json = j
        }
    }
}


extension Config.JSONLayer: IConfigLayer
{
    public var allConfigKeys: [String] { return Array(json.dictionaryValue.keys) }

    public func hasConfigValueForKey(key:String) -> Bool
    {
        let val = json[key]
        switch val.type
        {
            case .Null: return false
            default:    return true
        }
    }

    public func configValueForKey(key:String) -> AnyObject? {
        return json[key].object
    }

    public func configLayerForKey(key:String) -> IConfigLayer? {
        if let dict = json[key].dictionaryObject? {
            return Config.DictionaryLayer(dictionary: dict)
        }
        return nil
    }

    public func configLayerWithKeys(keys:[String]) -> Config.JSONLayer
    {
        var newJSON = JSON([String: AnyObject]())
        for (key, jsonVal) in json {
            if contains(keys, key) {
                newJSON[key] = jsonVal
            }
        }

//        let arr     = filter(dict) { contains(keys, $0.0) }
//        let newJSON = reduce(arr, [:] as JSON) { curr, next in
//                        var current = curr
//                        let (k, v) = next
//                        current[k] = v
//                        return current
//                     }
        return Config.JSONLayer(json: newJSON)
    }
}


extension Config.JSONLayer : Printable, DebugPrintable {
    public var description: String {
        var contents = "{ ??? }"
        if let dict = json.dictionaryObject {
            contents = describe(dict)
        }
        return "JSONLayer \(contents)"
    }

    public var debugDescription : String { return description }
}


