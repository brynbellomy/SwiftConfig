//
//  CGGeometry+Config.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Dec 30.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky


//
// MARK: - CGSize: IConfigInitable
//

extension CGSize: IConfigInitable
{
    public init?(config:Config)
    {
        if let (w, h) = config.get(keys:"width", "height") as (CGFloat?, CGFloat?) |> both {
            width = w
            height = h
        }
        else { return nil }
    }
}


//
// MARK: - CGPoint: IConfigInitable
//

extension CGPoint: IConfigInitable
{
    public init?(config:Config)
    {
        let keys = config.allConfigKeys
        if let (x, y) = config.get(keys:"x", "y") as (CGFloat?, CGFloat?) |> both {
            self = CGPoint(x:x, y:y)
        }
        else { return nil }
    }
}



//
// MARK: - CGVector: IConfigInitable
//

extension CGVector: IConfigInitable
{
    public init?(config:Config)
    {
        if let (dx, dy) = config.get(keys:"dx", "dy") as (CGFloat?, CGFloat?) |> both {
            self = CGVector(dx:dx, dy:dy)
        }
        else { return nil }
    }
}


