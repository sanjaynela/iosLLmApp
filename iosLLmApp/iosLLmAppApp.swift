//
//  iosLLmAppApp.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import SwiftUI

@main
struct iosLLmAppApp: App {
    @State private var showModelSelection = false
    @State private var llmClient: LLMClientProtocol?
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if let llm = llmClient {
                    ChatView(vm: ChatViewModel(llm: llm), client: llm)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    // Switch back to client selection
                                    llmClient = nil
                                } label: {
                                    Text("Switch Client")
                                        .font(.caption)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showModelSelection = true
                                } label: {
                                    Image(systemName: "gearshape")
                                }
                            }
                        }
                } else {
                    VStack(spacing: 20) {
                        Text("Welcome to On-Device LLM")
                            .font(.title)
                            .padding()
                        
                        Text("Choose your LLM client:")
                            .font(.headline)
                        
                        VStack(spacing: 12) {
                            Button {
                                // Use placeholder client (works immediately)
                                llmClient = LlamaRuntimeClient(modelPath: "")
                            } label: {
                                Label("Use Mock Client (Demo)", systemImage: "wand.and.stars")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            
                            Button {
                                // Use MLX client (requires setup)
                                showModelSelection = true
                            } label: {
                                Label("Use MLX Client (Real AI)", systemImage: "brain")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $showModelSelection) {
                ModelSelectionView { modelPath in
                    if let path = modelPath {
                        // Always try MLX client first - it will show helpful errors if not available
                        llmClient = MLXLLMClient(modelPath: path)
                    }
                }
            }
        }
    }
}
