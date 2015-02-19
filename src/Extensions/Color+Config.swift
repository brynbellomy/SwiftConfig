//
//  Color+Config.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Dec 30.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit
import Funky


#if os(iOS)
public typealias OSColor = UIColor
#elseif os(OSX)
public typealias OSColor = NSColor
#endif



//
// MARK: - OSColor: IConfigInitable
//

extension OSColor: IConfigRepresentable
{
    public var configValue: String {
        var red   : CGFloat = 0
        var green : CGFloat = 0
        var blue  : CGFloat = 0
        var alpha : CGFloat = 0

        getRed(&red, green:&green, blue:&blue, alpha:&alpha)

        return "rgba(\(red), \(green), \(blue), \(alpha))"
    }

    public class func fromConfigValue(configValue:String) -> Self?
    {
        if configValue.hasPrefix("rgba") {
            if let tuple = rgbaFromRGBAString(configValue) {
                return self(SRGBRed:tuple.r, green:tuple.g, blue: tuple.b, alpha: tuple.a)
            }
        }
        else {
            if let t = rgbaFromHexCode(configValue) {
                let tuple = t |> normalizeRGBA(colors: 255)
                return self(SRGBRed: tuple.r, green: tuple.g, blue: tuple.b, alpha: tuple.a)
            }
        }
        return nil
    }
}


extension OSColor
{
    public struct ConfigurableBuilder: IConfigurableBuilder
    {
        public var rgba: (r:CGFloat?, g:CGFloat?, b:CGFloat?, a:CGFloat?) = (r:nil, g:nil, b:nil, a:nil)

        public init() {}

        public mutating func configure(config:Config)
        {
            rgba.r =?? config.get("r") ?? config.get("red")
            rgba.g =?? config.get("g") ?? config.get("green")
            rgba.b =?? config.get("b") ?? config.get("blue")
            rgba.a =?? config.get("a") ?? config.get("alpha")
        }

        public func build() -> Result<OSColor>
        {
            func missingValueFailure (name:String) -> Result<CGFloat> {
                return failure("\(OSColor.description()).ConfigurableBuilder cannot build() without a value for '\(name)'")
            }

            func createColor(r:CGFloat)(g:CGFloat)(b:CGFloat)(a:CGFloat) -> OSColor {
                return OSColor(SRGBRed:r, green:g, blue:b, alpha:a)
            }

            return (createColor <^> rgba.r ?± missingValueFailure("red")
                                <*> rgba.g ?± missingValueFailure("green")
                                <*> rgba.b ?± missingValueFailure("blue")
                                <*> rgba.a ?± missingValueFailure("alpha"))

                        |> { $0.map { $0 as OSColor } }
        }
    }
}



