//
//  Config+Bitmask.swift
//  SwiftBitmask
//
//  Created by bryn austin bellomy on 2014 Dec 23.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftBitmask


public extension Config
{
    public func get <T: protocol<IBitmaskRepresentable, IConfigRepresentable>> (key:String) -> Bitmask<T>?
    {
        if let configValueArray = get(key) as [T]? {
            return Bitmask(configValueArray)
        }
        return nil
    }
}


