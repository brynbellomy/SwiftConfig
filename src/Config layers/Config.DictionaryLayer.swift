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

        private var dict: DictionaryType

        public init()                          { dict = DictionaryType() }
        public init(dictionary:DictionaryType) {
            dict = DictionaryType()
            for (key, value) in dictionary {
                dict[key] = value
            }
        }
    }
}


extension Config.DictionaryLayer : IConfigLayer
{
    public var allConfigKeys : [String] { return Array(dict.keys) }

    public func hasConfigValueForKey(key:String) -> Bool {
        return dict.indexForKey(key) != nil
    }

    public func configValueForKey(key:String) -> AnyObject? {
        return dict[key]
    }

    public func configLayerForKey(key:String) -> IConfigLayer? {
        if let dict = dict[key] as? [String: AnyObject] {
            return Config.DictionaryLayer(dictionary: dict)
        }
        return nil
    }

    public func configLayerWithKeys(keys:[String]) -> Config.DictionaryLayer
    {
        let newDict: DictionaryType = dict |> select { contains(keys, $0.0) }

        return Config.DictionaryLayer(dictionary:newDict)
    }
}


extension Config.DictionaryLayer : IMutableConfigLayer
{
    public mutating func setValueForConfigKey(key:String, _ value:AnyObject?) {
        dict[key] = value
    }

    public mutating func removeValueForConfigKey(key:String) {
        dict.removeValueForKey(key)
    }
}


extension Config.DictionaryLayer : Printable, DebugPrintable
{
    public var description      : String {
        let str = dumpString(dict)
        return "DictionaryLayer \(str)"
    }
    public var debugDescription : String { return description }
}






