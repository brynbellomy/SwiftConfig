//
//  MonsterAttributes.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2014 Dec 23.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftBitmask
import SwiftConfig


private enum MonsterAttributes : String
{
    case Big   = "big"
    case Ugly  = "ugly"
    case Scary = "scary"
}


extension MonsterAttributes: IBitmaskRepresentable, IAutoBitmaskable
{
    static var autoBitmaskValues : [MonsterAttributes] = [.Big, .Ugly, .Scary,]

    var bitmaskValue:  UInt16  { return AutoBitmask.autoBitmaskValueFor(self) }
    init(bitmaskValue: UInt16) { self = AutoBitmask.autoValueFromBitmask(bitmaskValue) }
}


extension MonsterAttributes: IConfigRepresentable
{
    var configValue: String { return rawValue }
    static func fromConfigValue(configValue: String) -> MonsterAttributes? {
        return MonsterAttributes(rawValue: configValue)
    }
}


class ConfigBitmaskTests : XCTestCase
{
    var config = Config()

    override func setUp()
    {
        super.setUp()

        let dict: [String: NSObject] = [
            "monster attributes 1": ["ugly", "scary"],
            "monster attributes 2": ["big"],
        ]

        let dictionaryLayer = Config.DictionaryLayer(dictionary: dict)
        config = Config(layer: dictionaryLayer)
    }

    func testBitmaskGetter() {
        let attributesBitmask1 = config.get("monster attributes 1") as Bitmask<MonsterAttributes>?
        let attributesBitmask2 = config.get("monster attributes 2") as Bitmask<MonsterAttributes>?

        XCTAssert(attributesBitmask1?.bitmaskValue == MonsterAttributes.Ugly.bitmaskValue | MonsterAttributes.Scary.bitmaskValue)
        XCTAssert(attributesBitmask2?.bitmaskValue == MonsterAttributes.Big.bitmaskValue)
    }
}


