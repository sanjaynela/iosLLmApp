//
//  ChatViewModel.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation
import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var input: String = ""
    @Published var isGenerating = false
    
    private let llm: LLMClientProtocol
    private var currentTask: Task<Void, Never>?
    private let systemPrompt: String
    
    init(llm: LLMClientProtocol, systemPrompt: String = "You are a helpful assistant.") {
        self.llm = llm
        self.systemPrompt = systemPrompt
    }
    
    func send() {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        messages.append(.init(role: .user, text: trimmed))
        input = ""
        
        // Create an empty assistant message we will stream into
        let assistantIndex = messages.count
        messages.append(.init(role: .assistant, text: ""))
        
        isGenerating = true
        currentTask?.cancel()
        
        currentTask = Task {
            do {
                let prompt = buildPrompt(from: messages)
                
                // Stream tokens as they arrive
                try await llm.generate(prompt: prompt) { [weak self] token in
                    guard let self else { return }
                    // Update the assistant message in place
                    if assistantIndex < self.messages.count {
                        self.messages[assistantIndex].text += token
                    }
                }
                
            } catch {
                if assistantIndex < messages.count {
                    messages[assistantIndex].text = "Something went wrong: \(error.localizedDescription)"
                }
            }
            
            isGenerating = false
        }
    }
    
    func stop() {
        currentTask?.cancel()
        isGenerating = false
    }
    
    private func buildPrompt(from messages: [ChatMessage]) -> String {
        // Keep it simple for v1.
        // Later we can add a system prompt, safety rules, truncation, etc.
        var prompt = "\(systemPrompt)\n\n"
        for m in messages {
            switch m.role {
            case .user:
                prompt += "User: \(m.text)\n"
            case .assistant:
                prompt += "Assistant: \(m.text)\n"
            }
        }
        prompt += "Assistant:"
        return prompt
    }
}
