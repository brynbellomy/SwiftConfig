//
//  IConfigLayer.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Nov 5.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public protocol IConfigLayer : DebugPrintable
{
    var allConfigKeys : [String] { get }

    func hasConfigValueForKey(key:String) -> Bool
    func configValueForKey(key:String) -> AnyObject?
    func configLayerForKey(key:String) -> IConfigLayer?
    func configLayerWithKeys(keys:[String]) -> Self
}


public protocol IMutableConfigLayer : IConfigLayer
{
    mutating func setValueForConfigKey(key:String, _ value:AnyObject?)
    mutating func removeValueForConfigKey(key:String)
}


