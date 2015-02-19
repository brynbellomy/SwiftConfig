//
//  ConfigTests.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2015 Feb 8.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftConfig
import Funky


class ConfigTests: XCTestCase
{
    var config: Config?
    
    override func setUp()
    {
        super.setUp()
        
        let dict = [
            "an object": [
                "one": 111,
                "two": 222,
                "three": 333,
            ]
        ]
        
        config = Config(dictionary:dict)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testSetter()
    {
        let before = config!.get(keypath:["an object", "two"]) as Int?
        XCTAssertEqual(before!, 222)
        
        config!.set(["an object", "two"], value: 5234)
        let after = config!.get(keypath:["an object", "two"]) as Int?
        NSLog("config.flatten -> \(config?.flatten())")
        let overrides = (config?.overrides)!
        NSLog("config.overrides -> \(dumpString(overrides.dictionary))")
        XCTAssertEqual(after!, 5234)
    }
}




