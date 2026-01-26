//
//  PerformanceMonitor.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation
import os

/// Simple performance monitoring utilities
enum Perf {
    private static let log = Logger(subsystem: "iosLLmApp", category: "perf")
    
    /// Measure execution time of a block and log it
    /// - Parameters:
    ///   - label: Label for the measurement
    ///   - block: Block to measure
    /// - Returns: The result of the block
    static func measure<T>(_ label: String, block: () throws -> T) rethrows -> T {
        let start = Date()
        let value = try block()
        let elapsed = Date().timeIntervalSince(start)
        log.info("\(label, privacy: .public) took \(elapsed, privacy: .public)s")
        return value
    }
    
    /// Measure execution time of an async block and log it
    /// - Parameters:
    ///   - label: Label for the measurement
    ///   - block: Async block to measure
    /// - Returns: The result of the block
    static func measure<T>(_ label: String, block: () async throws -> T) async rethrows -> T {
        let start = Date()
        let value = try await block()
        let elapsed = Date().timeIntervalSince(start)
        log.info("\(label, privacy: .public) took \(elapsed, privacy: .public)s")
        return value
    }
}
