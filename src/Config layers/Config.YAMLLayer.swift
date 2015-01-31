////
////  Config.YAMLLayer.swift
////  SwiftConfig
////
////  Created by bryn austin bellomy on 2015 Jan 30.
////  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
////
//
//import Foundation
//import Funky
//import SwiftyJSON
//import LlamaKit
//
//
//public extension Config
//{
//    public init?(yamlBundleFilename:String)
//    {
//        if let layer = YAMLLayer(bundleFilename: yamlBundleFilename) {
//            self = Config(layer:layer)
//        }
//        else {
//            return nil
//        }
//    }
//
//    public struct YAMLLayer
//    {
//        private let yaml :JSON
//
//        public init?(bundleFilename:String)
//        {
//            switch YAML.load(bundleFilename: bundleFilename)
//            {
//                case let .Success(box):
//                    yaml = box.unbox
//
//                case let .Failure(error):
//                    NSLog("Error: \(error.localizedDescription)")
//                    return nil
//            }
//        }
//
//
//        public init(yaml y:JSON) {
//            yaml = y
//        }
//    }
//}
//
//
//
//
//extension Config.YAMLLayer: IConfigLayer
//{
//    public var allConfigKeys : [String] { return Array(yaml.dictionaryValue.keys) }
//
//    public func hasConfigValueForKey(key:String) -> Bool
//    {
//        let val = yaml[key]
//        switch val.type
//        {
//        case .Null: return false
//        default:    return true
//        }
//    }
//
//    public func configValueForKey(key:String) -> AnyObject? {
//        return yaml[key].object
//    }
//
//    public func configLayerForKey(key:String) -> IConfigLayer? {
//        if let dict = yaml[key].dictionaryObject? {
//            return Config.DictionaryLayer(dictionary: dict)
//        }
//        return nil
//    }
//
//    public func configLayerWithKeys(keys:[String]) -> Config.YAMLLayer
//    {
//        var newYAML = YAML([String: AnyObject]())
//        for (key, yamlVal) in yaml {
//            if contains(keys, key) {
//                newYAML[key] = yamlVal
//            }
//        }
//
//        //        let arr     = filter(dict) { contains(keys, $0.0) }
//        //        let newYAML = reduce(arr, [:] as YAML) { curr, next in
//        //                        var current = curr
//        //                        let (k, v) = next
//        //                        current[k] = v
//        //                        return current
//        //                     }
//        return Config.YAMLLayer(yaml: newYAML)
//    }
//}
//
//
//extension Config.YAMLLayer : Printable, DebugPrintable {
//    public var description: String {
//        var contents = "{ ??? }"
//        if let dict = yaml.dictionaryObject {
//            contents = describe(dict)
//        }
//        return "YAMLLayer \(contents)"
//    }
//
//    public var debugDescription : String { return description }
//}
//
//
//
//private extension YAML
//{
//    private init?(var bundleFilename:String)
//    {
//        if bundleFilename.hasSuffix(".yaml") {
//            bundleFilename = bundleFilename.stringByDeletingPathExtension
//        }
//
//        if let filepath = NSBundle.mainBundle().pathForResource(bundleFilename, ofType:"yaml")? {
//            let yamlData = NSData(contentsOfFile:filepath)
//            self = YAML(data:yamlData!)
//        }
//        else {
//            NSLog("[SwiftConfig] could not find bundle file '\(bundleFilename)'")
//            return nil
//        }
//    }
//}
//
//
