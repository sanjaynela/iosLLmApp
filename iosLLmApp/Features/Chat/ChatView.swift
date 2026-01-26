//
//  ChatView.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import SwiftUI

struct ChatView: View {
    @StateObject var vm: ChatViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(vm.messages) { msg in
                        HStack {
                            if msg.role == .assistant { Spacer(minLength: 0) }
                            Text(msg.text)
                                .padding(12)
                                .background(msg.role == .user ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                                .foregroundColor(msg.role == .user ? .primary : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            if msg.role == .user { Spacer(minLength: 0) }
                        }
                    }
                }
                .padding()
            }
            
            HStack(spacing: 10) {
                TextField("Ask something…", text: $vm.input, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...5)
                
                if vm.isGenerating {
                    Button("Stop") { vm.stop() }
                        .buttonStyle(.bordered)
                } else {
                    Button("Send") { vm.send() }
                        .buttonStyle(.borderedProminent)
                        .disabled(vm.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding()
        }
        .navigationTitle("On‑Device Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ChatView(vm: ChatViewModel(llm: LlamaRuntimeClient(modelPath: "")))
    }
}
