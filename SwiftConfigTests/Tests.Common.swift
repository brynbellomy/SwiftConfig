//
//  Tests.Common.swift
//  SwiftConfigTests
//
//  Created by bryn austin bellomy on 2014 Dec 20.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SwiftConfig
import SwiftyJSON
import LlamaKit
import Funky

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
    var configValue: String { return rawValue }
}

struct TimeMachine: IConfigBuildable
{
    var direction:    Direction
    var yearCreated:  Int
    var originPlanet: String

    init(direction d:Direction, yearCreated yc:Int, originPlanet op:String) {
        direction = d
        yearCreated = yc
        originPlanet = op
    }

    static func build(#config: Config) -> Result<TimeMachine>
    {
        return buildTimeMachine <^> config.get("direction")     ?± failure("Missing key 'direction'.")
                                <*> config.get("year created")  ?± failure("Missing key 'year created'.")
                                <*> config.get("origin planet") ?± failure("Missing key 'origin planet'.")
    }
}

enum Direction: String, IConfigRepresentable
{
    case Forward = "forward"
    case Backward = "backward"

    static func fromConfigValue(configValue: String) -> Direction? { return Direction(rawValue: configValue) }
    var configValue: String { return rawValue }
}


private func buildTimeMachine(direction:Direction) (yearCreated:Int) (originPlanet:String) -> TimeMachine {
    return TimeMachine(direction: direction, yearCreated: yearCreated, originPlanet: originPlanet)
}




