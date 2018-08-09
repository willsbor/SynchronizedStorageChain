//
//  SynchronizedStorageChain.swift
//  SynchronizedStorageChain
//
//  Created by willsborKang on 2018/8/7.
//  Copyright © 2018年 willsborKang. All rights reserved.
//

import Foundation

/// providing the instance of the Value
public protocol SynchronizedDataProviding: class {
    associatedtype Value
    
    /// try to notify(return) the new value if carryed value is modified(out of date)
    var valueBeModifiedHandler: ((_ newValue: Value) -> Void)? { get set }
    
    /// return the value
    ///
    /// - Returns: return current value
    /// - Throws: error
    func getValue() throws -> Value
    
    /// set the value
    ///
    /// - Parameter value: input value
    /// - Throws: error
    func setValue(_ value: Value) throws
}

/// Describe the relation of two data provider, handling the same data type. One is main provider and the other is underlying provider. Every time getting value, it will check the underlying provider is modified by other sources. If true, it will return the newValue and update main provider
public class SynchronizedStorageChain<MainProvider: SynchronizedDataProviding, UnderlyingProvider: SynchronizedDataProviding> where MainProvider.Value == UnderlyingProvider.Value {
    
    public let provider: MainProvider
    public let underlyingProvider: UnderlyingProvider?
    
    private var isUnderlyingProviderBeUpdated = false
    
    public var valueBeModifiedHandler: ((_ newValue: MainProvider.Value) -> Void)?
    
    public func getValue() throws -> MainProvider.Value {
        if isUnderlyingProviderBeUpdated, let underlyingProvider = underlyingProvider {
            let newValue = try underlyingProvider.getValue()
            valueBeModifiedHandler?(newValue)
            try provider.setValue(newValue)
        }
        
        return try provider.getValue()
    }
    
    public func setValue(_ value: MainProvider.Value) throws {
        try provider.setValue(value)
        try underlyingProvider?.setValue(value)
    }
    
    public init(_ provider: MainProvider, underlyingProvider: UnderlyingProvider) {
        self.provider = provider
        self.underlyingProvider = underlyingProvider
        self.underlyingProvider?.valueBeModifiedHandler = { [unowned self] (_) -> Void in
            self.isUnderlyingProviderBeUpdated = true
        }
    }
}
