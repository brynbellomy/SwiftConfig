//
//  JSONLayerConfigTests.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2015 Jan 11.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftConfig
import SwiftyJSON

class JSONConfigLayerTests: XCTestCase
{
    var config = Config()

    override func setUp()
    {
        super.setUp()

        let json      = JSON(testBundle:self.dynamicType, filename: "config-test.json")!
        let jsonLayer = Config.JSONLayer(json: json)
        config = Config(layer: jsonLayer)
    }


    func testGetString() {
        let someString1 = config.get("some string") as String?
        XCTAssert(someString1 == "bryn")
    }

    func testGetFloat() {
        let someFloat = config.get("some float") as Float?
        XCTAssert(someFloat == 42.7)
    }

    func testGetBool() {
        let trueBool = config.get("true bool") as Bool?
        XCTAssert(trueBool == true)

        let falseBool = config.get("false bool") as Bool?
        XCTAssert(falseBool == false)
    }

    func testGetMultipleAsArray() {
        let multipleFloats = config.get(keys: "float1", "float2", "float3") as [Float?]
        XCTAssert(multipleFloats[0] == 12.3)
        XCTAssert(multipleFloats[1] == 45.6)
        XCTAssert(multipleFloats[2] == 78.9)
    }

    func testGetMultipleAsTuple() {
        let (floatValue: Float?, stringValue: String?) = config.get(keys:"some float", "some string")
        XCTAssert(floatValue  == 42.7)
        XCTAssert(stringValue == "bryn")
    }

    func testGetSubconfigAsObject() {
        let size = config.get("size") as CGSize?
        XCTAssert(size?.width  == 111.1)
        XCTAssert(size?.height == 222.2)
    }

    func testGetStringArray() {
        let array = config.get("string array") as [String]?
        XCTAssert(array?[0] == "bryn")
        XCTAssert(array?[1] == "austin")
        XCTAssert(array?[2] == "bellomy")
    }

    func testIConfigRepresentableTypes() {
        let alienTypeSingleValue = config.get("alien type (single)") as AlienType?
        XCTAssert(alienTypeSingleValue != nil)
        XCTAssert(alienTypeSingleValue! == .Hybrid)

        let alienTypeMultipleValues = config.get("alien type (multiple)") as [AlienType]?
        XCTAssert(alienTypeMultipleValues != nil)
        XCTAssert(contains(alienTypeMultipleValues!, .Grey))
        XCTAssert(contains(alienTypeMultipleValues!, .TallWhite))
    }

    func testNonexistentKey() {
        let val: AnyObject? = config.get("totally bogus")
        XCTAssertNil(val)

        let alien = config.get("totally bogus") as AlienType?
        XCTAssert(alien == nil)
    }

    func testGetSubconfigAtKeypath() {
        let subconfig: Config? = config.get(keypath:["nested object", "key1", "key2"])
        XCTAssert(subconfig != nil)

        let string = subconfig!.get("string") as String?
        XCTAssert(string == "bryn")

        let double = subconfig!.get("double") as Double?
        XCTAssertEqualWithAccuracy(double!, 23.8, 0.00001)
    }
}