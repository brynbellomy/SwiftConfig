//
//  NSColorBuilderTests.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Dec 30.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import XCTest
import SwiftConfig
import SwiftyJSON


class NSColorBuilderTests : XCTestCase
{
    var config = Config()

    override func setUp()
    {
        super.setUp()

        let json      = JSON(testBundle:self.dynamicType, filename: "config-test.json")!
        let jsonLayer = Config.JSONLayer(json: json)
        config = Config(layer: jsonLayer)
    }

    func testParseColorHexString() {
        let maybeColor = config.get("color hex rgb string") as NSColor?
        XCTAssert(maybeColor != nil)
        XCTAssertEqualWithAccuracy(maybeColor!.alphaComponent, CGFloat(1.0), 0.000001)

        let maybeColorWithAlpha = config.get("color hex rgba string") as NSColor?
        XCTAssert(maybeColorWithAlpha != nil)
    }

    func testParseColorRGBAString() {
        let maybeColor = config.get("color rgba string") as NSColor?
        XCTAssert(maybeColor != nil)
        XCTAssertEqualWithAccuracy(maybeColor!.redComponent, CGFloat(0.1), 0.000001)
        XCTAssertEqualWithAccuracy(maybeColor!.greenComponent, CGFloat(0.9), 0.000001)
        XCTAssertEqualWithAccuracy(maybeColor!.blueComponent, CGFloat(0.2), 0.000001)
        XCTAssertEqualWithAccuracy(maybeColor!.alphaComponent, CGFloat(0.9), 0.000001)
    }

    func testParseColorObject()
    {
        let maybeColor = config.get("color object", builder:NSColor.ConfigurableBuilder())
        XCTAssertTrue(maybeColor.isSuccess())

        let color = maybeColor.value()!
        XCTAssertEqualWithAccuracy(color.redComponent, CGFloat(0.3), 0.000001)
        XCTAssertEqualWithAccuracy(color.greenComponent, CGFloat(0.4), 0.000001)
        XCTAssertEqualWithAccuracy(color.blueComponent, CGFloat(0.12), 0.000001)
        XCTAssertEqualWithAccuracy(color.alphaComponent, CGFloat(1), 0.000001)
    }
}




