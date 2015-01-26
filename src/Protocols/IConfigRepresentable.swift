//
//  IConfigRepresentable.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Dec 30.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation


public protocol IConfigRepresentable
{
    typealias ConfigValueType
    class func fromConfigValue(configValue:ConfigValueType) -> Self?
}


extension String: IConfigRepresentable {
    public static func fromConfigValue(configValue:String) -> String? { return configValue }
}

extension Int: IConfigRepresentable {
    public static func fromConfigValue(configValue:Int) -> Int? { return configValue }
}

extension Float: IConfigRepresentable {
    public static func fromConfigValue(configValue:Float) -> Float? { return configValue }
}

extension Double: IConfigRepresentable {
    public static func fromConfigValue(configValue:Double) -> Double? { return configValue }
}

extension Bool: IConfigRepresentable {
    public static func fromConfigValue(configValue:Bool) -> Bool? { return configValue }
}

extension CGFloat: IConfigRepresentable {
    public static func fromConfigValue(configValue:CGFloat) -> CGFloat? {
        return configValue
    }
}





