//
//  LLMConfig.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation

/// Configuration for LLM clients
struct LLMConfig {
    /// Maximum number of tokens to generate
    var maxTokens: Int = 256
    
    /// Temperature for sampling (0.0 = deterministic, higher = more creative)
    var temperature: Double = 0.7
    
    /// Model path (for local models)
    var modelPath: String?
    
    /// System prompt
    var systemPrompt: String = "You are a helpful assistant."
}
