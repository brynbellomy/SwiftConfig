//
//  Config.DictionaryLayer.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Nov 5.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky


extension Config
{
    public init(dictionary:DictionaryLayer.DictionaryType)
    {
        let layer = DictionaryLayer(dictionary: dictionary)
        self.init(layer:layer)
    }


    public struct DictionaryLayer
    {
        public typealias DictionaryType = [String: AnyObject]

        public private(set) var dictionary: DictionaryType

        public init() {
            dictionary = DictionaryType()
        }
        
        public init(dictionary d:DictionaryType)
        {
            self = DictionaryLayer()
            for (key, value) in d {
                dictionary[key] = value
            }
        }
    }
}


extension Config.DictionaryLayer: IConfigLayer
{
    public var allConfigKeys: [String] { return Array(dictionary.keys) }

    public func hasConfigValueForKey(key:String) -> Bool {
        return dictionary.indexForKey(key) != nil
    }

    public func configValueForKey(key:String) -> AnyObject? {
        return dictionary[key]
    }

    public func configLayerForKey(key:String) -> IConfigLayer? {
        if let dictionary = dictionary[key] as? [String: AnyObject] {
            return Config.DictionaryLayer(dictionary: dictionary)
        }
        return nil
    }

    public func configLayerWithKeys(keys:[String]) -> Config.DictionaryLayer
    {
        let newDict: DictionaryType = dictionary |> selectWhere { contains(keys, $0.0) }

        return Config.DictionaryLayer(dictionary:newDict)
    }
}


extension Config.DictionaryLayer: IMutableConfigLayer
{
    mutating public func setValueForConfigKey(key:String, _ value:AnyObject?) {
        dictionary[key] = value
    }

    mutating public func setValueForConfigKeypath(keypath:[String], value:AnyObject?) {
//        var dict = dictionary as [String: Any]
//        let val = value as Any?
        switch setValueForKeypath(dictionary, keypath, value) {
            case .Success(let box):   dictionary = box.unbox
            case .Failure(let error): NSLog("[SwiftConfig.DictionaryLayer.setValueForConfigKeypath()] Error: \(error.localizedDescription)")
        }
    }

    mutating public func removeValueForConfigKey(key:String) {
        dictionary.removeValueForKey(key)
    }
}


extension Config.DictionaryLayer: Printable, DebugPrintable
{
    public var description: String {
        let str = describe(dictionary) //dumpString(dictionary)
        return "DictionaryLayer \(str)"
    }
    public var debugDescription : String { return description }
}






