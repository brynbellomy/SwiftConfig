//
//  IConfigInitable.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Nov 5.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import LlamaKit
import Funky


public protocol IConfigInitable {
    init?(config:Config)
}

public protocol IConfigBuildable {
    class func build(#config: Config) -> Result<Self>
}


public protocol IConfigurableBuilder
{
    typealias BuiltType

    init()
    mutating func configure(config:Config)
    mutating func build() -> Result<BuiltType>
}








