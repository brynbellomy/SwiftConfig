//
//  Config.Common.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2015 Jan 31.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftyJSON
import YACYAML
import LlamaKit
import Funky


public func loadBundleData (bundleClass:AnyClass, filename:String, ext:String) -> Result<NSData>
{
    return (NSBundle(forClass:bundleClass).pathForResource(filename, ofType:ext)
                        >>- { NSData(contentsOfFile:$0) }
                        >>- { success($0) })
        ?? failure("[SwiftConfig] could not find bundle file '\(filename)'")
}


public extension JSON
{
    public init?(jsonFilename:String, bundle:AnyClass)
    {
        switch loadBundleData(bundle, jsonFilename, ".json")
        {
            case let .Success(box):
                self = JSON(data:box.unbox)

            case let .Failure(error):
                NSLog("Error: \(error.localizedDescription)")
                return nil
        }
    }

    public init?(yamlFilename:String, bundle:AnyClass)
    {
        switch loadBundleData(bundle, yamlFilename, ".yaml")
        {
            case let .Success(box):
                let data = box.unbox
                if let loadedYamlObject :AnyObject = YACYAMLKeyedUnarchiver.unarchiveObjectWithData(data, options:YACYAMLKeyedUnarchiverOptionNone) {
                    self = JSON(loadedYamlObject)
                }
                else {
                    NSLog("Error: could not parse YAML for '\(yamlFilename).yaml' in bundle \(bundle)")
                    return nil
                }

            case let .Failure(error):
                NSLog("Error: \(error.localizedDescription)")
                return nil
        }
    }
}



