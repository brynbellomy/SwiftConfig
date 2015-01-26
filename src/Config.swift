//
//  Config.swift
//  SwiftConfig
//
//  Created by bryn austin bellomy on 2014 Oct 7.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SwiftDataStructures
import LlamaKit
import Funky


//
// MARK: - struct Config -
//

public struct Config
{
    public typealias UnderlyingStackType = Stack<IConfigLayer>
	public typealias Index = String
    public typealias Element = AnyObject

    public private(set) var layers    = UnderlyingStackType()
    public private(set) var overrides = Config.DictionaryLayer()

    //
    // MARK: - Lifecycle
    //

    public init() {
    }

    public init(layer:IConfigLayer) {
        self = Config([layer])
    }

	public init <S: SequenceType where S.Generator.Element == IConfigLayer> (_ sequence: S) {
        self = Config()
		layers.extend(sequence)
	}


    //
    // MARK: - Public API
    //

    // MARK: Getter: single value
    public func get <T: IConfigRepresentable> (key:String) -> T? {
        return initializeRepresentedObject(key:key)
    }


    // MARK: Getter: single untyped/uninitialized value
    public func get (key:String) -> AnyObject? {
        if let obj: AnyObject = findLayerWithValueForKey(key)?.configValueForKey(key) {
            return obj
        }
        return nil
    }


    // MARK: Getter: tuples
    public func get <T: IConfigRepresentable, U: IConfigRepresentable> (keys one:String, _ two:String) -> (T?, U?) {
        return (initializeRepresentedObject(key:one), initializeRepresentedObject(key:two))
    }


    public func get <T: IConfigRepresentable, U: IConfigRepresentable, V: IConfigRepresentable>
        (keys one:String, _ two:String, _ three:String) -> (T?, U?, V?)
    {
        return (initializeRepresentedObject(key:one), initializeRepresentedObject(key:two), initializeRepresentedObject(key:three))
    }


    public func get <T: IConfigRepresentable, U: IConfigRepresentable, V: IConfigRepresentable, W: IConfigRepresentable>
        (keys one:String, _ two:String, _ three:String, _ four:String) -> (T?, U?, V?, W?)
    {
            return (initializeRepresentedObject(key:one),
                    initializeRepresentedObject(key:two),
                    initializeRepresentedObject(key:three),
                    initializeRepresentedObject(key:four))
    }


    // MARK: Getter: value as array
    public func get <T: IConfigRepresentable> (key:String) -> [T]? {
        return initializeRepresentedObjectArray(key: key) { T.fromConfigValue($0) }
    }


    // MARK: Getter: array of values for multiple keys
    public func get <T: IConfigRepresentable> (#keys:String...) -> [T?] {
        return keys |> mapFilter { self.initializeRepresentedObject(key:$0) }
    }


    // MARK: Getter: value at keypath
    public func get <T: IConfigRepresentable> (#keypath:[String]) -> T?
    {
        if keypath.count == 1 {
            return get(keypath.first!)
        }

        let headKey  = keypath.first!
        let tailKeys = Array(keypath[ 1 ..< keypath.endIndex ])
        let childConfig = get(headKey) as Config
        return childConfig.get(keypath:tailKeys)
    }


    // MARK: Getter: subconfig at keypath
    public func get(#keypath:[String]) -> Config?
    {
        if keypath.count == 1 {
            return get(keypath.first!)
        }

        let headKey  = keypath.first!
        let tailKeys = Array(keypath[ 1 ..< keypath.endIndex ])
        let childConfig = get(headKey) as Config
        return childConfig.get(keypath:tailKeys)
    }

    public func get(#keypath:String...) -> Config? {
        return get(keypath:keypath)
    }


    // MARK: Getter: subconfig from key
    public func get(key:String) -> Config
    {
        let sublayers = layers |> mapFilter { $0.configLayerForKey(key) }
        var subconfig = Config(sublayers)

        if let suboverrides = overrides.configLayerForKey(key) as? DictionaryLayer {
            subconfig.overrides = suboverrides
        }

        return subconfig
    }


    // MARK: Getter: IConfigInitable object from subconfig at key
    public func get <T: IConfigInitable> (key:String) -> T?
    {
        let config = get(key) as Config
        return T(config:config)
    }


    // MARK: Getter: object built by an IConfigurableBuilder
    public func get <B: IConfigurableBuilder> (key:String, var builder: B) -> Result<B.BuiltType>
    {
        if !hasConfigValueForKey(key) {
            return failure("Could not find config key '\(key)'.")
        }

        let config = get(key) as Config
        builder.configure(config)
        return builder.build()
    }


    // MARK: build an IConfigurableBuilder's product using all of the entries in this config
    public func buildWith <B: IConfigurableBuilder> (var builder:B) -> Result<B.BuiltType> {
        builder.configure(self)
        return builder.build()
    }


    // MARK: Pluck (narrows all layers)
    public func pluck(keys:String...) -> Config {
        return pluck(keys)
    }

    public func pluck<T: IConfigInitable> (keys:String...) -> T? {
        return pluck(keys)
    }

    public func pluck(keys:[String]) -> Config
    {
        let pluckedLayers = map(layers) { $0.configLayerWithKeys(keys) }
        var config = Config(pluckedLayers)
        config.overrides = overrides.configLayerWithKeys(keys)
        return config
    }


    public func pluck<T: IConfigInitable> (keys:[String]) -> T? {
        let config = pluck(keys) as Config
        return T(config: config)
    }


    public func flatten() -> [String: AnyObject]
    {
        func keyToKeyValueTuple(key:String) -> (String, AnyObject)? {
            let maybeVal: AnyObject? = get(key)
            if let val: AnyObject = maybeVal { return (key, val) }
            else { return nil }
        }

        return allConfigKeys |> mapFilter(keyToKeyValueTuple)
                             |> mapToDictionary { $0 }
    }


    public mutating func set(key:String, value:AnyObject?) {
        overrides.setValueForConfigKey(key, value)
    }

    public func hasValueForKey(key:String) -> Bool {
        return findLayerWithValueForKey(key) != nil
    }


    //
    // MARK: - Private helper methods
    //

    private func representedObjectInitializer <T: IConfigRepresentable>
        (constructObject:(T.ConfigValueType) -> (T?)) -> (AnyObject) -> T? //(rawValue:AnyObject) -> T?
    {
        return { rawValue in
            if let configValue = rawValue as? T.ConfigValueType {
                return constructObject(configValue)
            }
            return nil
        }
    }


    private func initializeRepresentedObject <T: IConfigRepresentable> (#key:String, construct:(T.ConfigValueType) -> (T?)) -> T?
    {
        if let layer = findLayerWithValueForKey(key)
        {
            if let configValue: AnyObject = layer.configValueForKey(key)
            {
                let initializer = representedObjectInitializer(construct)
                return initializer(configValue)
            }
        }
        return nil
    }


    private func initializeRepresentedObject<T: IConfigRepresentable> (#key:String) -> T? {
        return initializeRepresentedObject(key:key) { T.fromConfigValue($0) }
    }


    private func initializeRepresentedObjectArray<T: IConfigRepresentable> (#key:String, constructor:(T.ConfigValueType) -> T?) -> [T]?
    {
        if let anyConfigValue: AnyObject = findLayerWithValueForKey(key)?.configValueForKey(key)
        {
            let configValueNSArray = (anyConfigValue as? NSArray)!
            return (configValueNSArray as [AnyObject]) |> mapFilter(representedObjectInitializer(constructor))
        }
        return nil
    }


    public func findLayerWithValueForKey(key:String) -> IConfigLayer?
    {
        if overrides.hasConfigValueForKey(key) {
            return overrides
        }

        for layer in layers {
            if layer.hasConfigValueForKey(key) {
                return layer
            }
        }
        return nil
    }

}



//
// MARK: - Config: IConfigLayer
//

extension Config: IConfigLayer
{
    public var allConfigKeys: [String] {
        let allLayers = [overrides] as Stack<IConfigLayer> + layers
        return reduce(allLayers, [String]()) { $0 + $1.allConfigKeys }
            |> unique
    }

    public func hasConfigValueForKey(key: String) -> Bool {
        if let layer = findLayerWithValueForKey(key)? {
            return true
        }
        return false
    }

    public func configValueForKey(key: String) -> AnyObject? {
        if let value: AnyObject = findLayerWithValueForKey(key)?.configValueForKey(key) {
            return value
        }
        return nil
    }

    public func configLayerForKey(key: String) -> IConfigLayer? {
        if let layer = findLayerWithValueForKey(key)?.configLayerForKey(key) {
            return layer
        }
        return nil
    }

    public func configLayerWithKeys(keys: [String]) -> Config {
        return pluck(keys)
    }
}



//
// MARK: - Config: Printable, DebugPrintable
//

extension Config: Printable, DebugPrintable
{
    public var description: String {
        let contents = describe(flatten())
        return "<Config: (\(layers.count) layer(s)) flattened contents = \(contents)>"
    }

    public var debugDescription: String {
        let contents = join(",\n\t", map(layers) { $0.debugDescription })
        return "<Config: (\(layers.count) layer(s)) = [\n\t\(contents)\n]>"
    }
}


//
// MARK: - Layer manipulation
//

public extension Config
{
    /**
        Inserts the provided `IConfigLayer` at the top of the layer stack (meaning its value for a given key will be preferred to those from other layers whenever possible).  The index must be >= startIndex and <= endIndex or a precondition will fail.

        :param: layer The `IConfigLayer` to insert.
        :param: index The index where insertion should take place.
    */
    public mutating func pushLayer(layer:IConfigLayer) {
        layers.push(layer)
    }

    /**
        Removes the top IConfigLayer from the stack of layers and returns it.

        :returns: The removed element or `nil` if the stack is empty.
     */
    public mutating func popLayer() -> IConfigLayer? {
        return layers.pop()
    }

    /**
        Inserts the provided `IConfigLayer` `n` positions from the top of the stack.  The index must be >= startIndex and <= endIndex or a precondition will fail.

        :param: layer The `IConfigLayer` to insert.
        :param: index The index where insertion should take place.
    */
    public mutating func insertLayer(layer:IConfigLayer, atIndex index:UnderlyingStackType.Index) {
        precondition(index >= layers.startIndex && index <= layers.endIndex)
        layers.insert(layer, atIndex:index)
    }

    /**
        Removes the IConfigLayer `n` positions from the top of the stack and returns it.  `index` must be a valid index or a precondition assertion will fail.

        :param: index The index of the element to remove.
        :returns: The removed element.
     */
    public mutating func removeLayerAtIndex(index:UnderlyingStackType.Index) -> IConfigLayer {
        precondition(index >= layers.startIndex && index <= layers.endIndex.predecessor())
        return layers.removeAtIndex(index)
    }
}





