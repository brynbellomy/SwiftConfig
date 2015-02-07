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

    class func fromConfigValue(configValue: ConfigValueType) -> Self?
    var configValue: ConfigValueType { get }
}


extension String: IConfigRepresentable {
    public static func fromConfigValue(configValue:String) -> String? { return configValue }
    public var configValue: String { return self }
}

extension Int: IConfigRepresentable {
    public static func fromConfigValue(configValue:Int) -> Int? { return configValue }
    public var configValue: Int { return self }
}

extension Float: IConfigRepresentable {
    public static func fromConfigValue(configValue:Float) -> Float? { return configValue }
    public var configValue: Float { return self }
}

extension Double: IConfigRepresentable {
    public static func fromConfigValue(configValue:Double) -> Double? { return configValue }
    public var configValue: Double { return self }
}

extension Bool: IConfigRepresentable {
    public static func fromConfigValue(configValue:Bool) -> Bool? { return configValue }
    public var configValue: Bool { return self }
}

extension CGFloat: IConfigRepresentable {
    public var configValue: CGFloat { return self }
    public static func fromConfigValue(configValue:CGFloat) -> CGFloat? {
        return configValue
    }
}





