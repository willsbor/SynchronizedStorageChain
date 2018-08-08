//
//  SynchronizedStorageChainTests.swift
//  SynchronizedStorageChainTests
//
//  Created by willsborKang on 2018/8/7.
//  Copyright © 2018年 willsborKang. All rights reserved.
//

import XCTest
@testable import SynchronizedStorageChain

class SynchronizedStorageChainTests: XCTestCase {
    
    class MockProvider: MemoryStorage<String> {
        
        
    }
    
    var provider: MockProvider!
    var underlyingProvider: MockProvider!
    var providerChain: SynchronizedStorageChain<MockProvider, MockProvider>!
    
    override func setUp() {
        super.setUp()
        
        provider = MockProvider("123")
        underlyingProvider = MockProvider("456")
        
        providerChain = SynchronizedStorageChain<MockProvider, MockProvider>(provider, underlyingProvider: underlyingProvider)
    }
    
    override func tearDown() {
    
        providerChain = nil
        provider = nil
        underlyingProvider = nil
        
        super.tearDown()
    }
    
    func testGetValue() {
        let result = try! providerChain.getValue()
        
        XCTAssertEqual(result, "123")
    }
    
    func testGetValueWhenUnderlyingProviderBeModify() {
        let answer = "hello world"
        try! underlyingProvider.setValue(answer)
        underlyingProvider.valueBeModifiedHandler?(answer)
        
        let result = try! providerChain.getValue()
        
        XCTAssertEqual(result, answer)
    }
    
    func testSetValue() {
        try! providerChain.setValue("55688")
        
        XCTAssertEqual(try! provider.getValue(), "55688")
        XCTAssertEqual(try! underlyingProvider.getValue(), "55688")
    }
    
}
