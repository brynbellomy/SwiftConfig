//
//  BuilderOf.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2015 Feb 6.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit


public struct BuilderOf <T: IConfigBuildable>: IConfigurableBuilder
{
    public var config = Config()

    public init() {
    }

    mutating
    public func configure(c:Config) {
        config = c
    }

//    public func build <U> () -> Result<U>
    public func build () -> Result<T>
    {
        return T.build(config: config) //.map { $0 as U }
    }
}

