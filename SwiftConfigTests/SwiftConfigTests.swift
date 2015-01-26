//
//  SwiftConfigTests.swift
//  SwiftConfigTests
//
//  Created by bryn austin bellomy on 2014 Dec 20.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftConfig
import SwiftyJSON

//
// @@TODO: write test case for the pluck() bug
//


enum AlienType: String, IConfigRepresentable
{
    case Grey = "grey"
    case TallWhite = "tall white"
    case Hybrid = "hybrid"

    typealias ConfigValueType = String
    static func fromConfigValue(configValue: String) -> AlienType? { return AlienType(rawValue: configValue) }
}


private func pathForFilename(filename:String, inBundle bundleClass:AnyClass) -> String?
{
    let bundle = NSBundle(forClass: bundleClass)
    let path = bundle.pathForResource(filename.stringByDeletingPathExtension, ofType:filename.pathExtension)
    return path
}


public extension JSON
{
    public init?(testBundle:AnyClass, filename:String)
    {
        if let filepath = pathForFilename(filename, inBundle:testBundle)?
        {
            let jsonData = NSData(contentsOfFile:filepath)
            self = JSON(data:jsonData!)
        }
        else {
            println("[SwiftConfig] could not find test bundle file '\(filename)'")
            return nil
        }
    }
}




