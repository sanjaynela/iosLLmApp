//
//  LlamaRuntimeClient.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation

/// Example implementation of LLMClientProtocol using a llama.cpp-style runtime
/// 
/// NOTE: This is a placeholder implementation. In a real app, you would integrate
/// with an actual runtime like llama.cpp or a Swift wrapper.
/// 
/// To use a real runtime:
/// 1. Add the runtime library as a dependency (SPM, CocoaPods, or manual integration)
/// 2. Replace the placeholder logic with actual model loading and inference
/// 3. Handle tokenization and detokenization properly
final class LlamaRuntimeClient: LLMClientProtocol {
    private let modelPath: String
    private let config: LLMConfig
    
    init(modelPath: String, config: LLMConfig = LLMConfig()) {
        self.modelPath = modelPath
        self.config = config
    }
    
    func generate(prompt: String, onToken: @escaping (String) -> Void) async throws {
        // PSEUDOCODE IMPLEMENTATION:
        // In a real implementation, you would:
        // 1. Load the model (once, cache it)
        // 2. Encode the prompt into token IDs
        // 3. Loop: decode next token -> convert to String -> onToken(token)
        // 4. Stop on EOS token, max tokens, or cancellation
        
        // Extract the last user message from the prompt for mock responses
        let lastUserMessage = extractLastUserMessage(from: prompt)
        
        // Generate a mock response based on the user's message
        let mockResponse = generateMockResponse(for: lastUserMessage)
        
        // Stream the response token by token (simulating real LLM behavior)
        let words = mockResponse.split(separator: " ").map { String($0) }
        
        for (index, word) in words.enumerated() {
            try Task.checkCancellation()
            
            // Stream each word with a space before it (except the first)
            onToken(index == 0 ? word : " \(word)")
            try await Task.sleep(nanoseconds: 50_000_000) // 50ms per word for realistic feel
            
            // Stop if we've reached max tokens
            if index >= config.maxTokens - 1 {
                break
            }
        }
        
        // In a real implementation, you would also handle:
        // - EOS (end of sequence) tokens
        // - Proper tokenization/detokenization
        // - Model context management
        // - Memory management for large models
    }
    
    /// Extract the last user message from the prompt
    private func extractLastUserMessage(from prompt: String) -> String {
        // Find the last "User: " occurrence
        if let userRange = prompt.range(of: "User: ", options: .backwards) {
            let afterUser = prompt[userRange.upperBound...]
            // Find the next newline or "Assistant:" marker
            if let endRange = afterUser.range(of: "\n") {
                return String(afterUser[..<endRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            } else if let assistantRange = afterUser.range(of: "Assistant:") {
                return String(afterUser[..<assistantRange.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
            }
            return String(afterUser).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return ""
    }
    
    /// Generate a mock response based on the user's message
    private func generateMockResponse(for userMessage: String) -> String {
        let lowercased = userMessage.lowercased()
        
        // Simple pattern matching for common questions
        if lowercased.contains("who are you") || lowercased.contains("what are you") {
            return "I'm a helpful AI assistant running on your device. I can help answer questions, have conversations, and assist with various tasks. How can I help you today?"
        } else if lowercased.contains("hello") || lowercased.contains("hi") || lowercased.contains("hey") {
            return "Hello! How can I assist you today?"
        } else if lowercased.contains("what is") || lowercased.contains("what's") {
            if lowercased.contains("2+") || lowercased.contains("2 +") {
                return "2 + 2 equals 4. If you meant something else, could you clarify your question?"
            }
            return "That's an interesting question. Could you provide more details so I can give you a better answer?"
        } else if lowercased.contains("how are you") {
            return "I'm doing well, thank you for asking! I'm here and ready to help. What would you like to know?"
        } else if lowercased.contains("help") {
            return "I'd be happy to help! What do you need assistance with?"
        } else if lowercased.isEmpty {
            return "I'm here to help! What would you like to know?"
        } else {
            // Generic response that acknowledges the user's message
            return "I understand you're asking about '\(userMessage)'. This is a placeholder response from the demo app. To get real AI responses, you'll need to integrate an actual LLM runtime like llama.cpp or use Apple's Foundation Models when available."
        }
    }
}
