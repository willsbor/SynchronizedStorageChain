//
//  MemoryStorage.swift
//  SynchronizedStorageChain
//
//  Created by willsborKang on 2018/8/7.
//  Copyright © 2018年 willsborKang. All rights reserved.
//

import Foundation

public class MemoryStorage<T>: SynchronizedDataProviding {
    public typealias Value = T
    
    /// There is no way to be modified by other method
    public var valueBeModifiedHandler: (() -> Void)?
    
    private var value: T
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func getValue() throws -> T {
        return value
    }
    
    public func setValue(_ value: T) throws {
        self.value = value
    }
}
