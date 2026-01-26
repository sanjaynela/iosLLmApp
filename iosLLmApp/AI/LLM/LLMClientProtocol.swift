//
//  LLMClientProtocol.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation

/// Protocol for LLM clients that can generate text tokens
protocol LLMClientProtocol {
    /// Streams tokens via `onToken` callback as they are generated
    /// - Parameters:
    ///   - prompt: The input prompt text
    ///   - onToken: Callback invoked for each generated token
    func generate(prompt: String, onToken: @escaping (String) -> Void) async throws
}
