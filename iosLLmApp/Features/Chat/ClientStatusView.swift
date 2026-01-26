//
//  ClientStatusView.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import SwiftUI

struct ClientStatusView: View {
    let client: LLMClientProtocol
    
    var body: some View {
        HStack {
            Image(systemName: clientStatusIcon)
                .foregroundColor(clientStatusColor)
            Text(clientStatusText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    private var clientStatusIcon: String {
        if client is MLXLLMClient {
            #if canImport(MLX)
            return "brain.head.profile"
            #else
            return "exclamationmark.triangle"
            #endif
        } else {
            return "wand.and.stars"
        }
    }
    
    private var clientStatusColor: Color {
        if client is MLXLLMClient {
            #if canImport(MLX)
            return .green
            #else
            return .orange
            #endif
        } else {
            return .blue
        }
    }
    
    private var clientStatusText: String {
        if client is MLXLLMClient {
            #if canImport(MLX)
            return "MLX Client (Real AI)"
            #else
            return "MLX Not Available - Add Package"
            #endif
        } else {
            return "Mock Client (Demo)"
        }
    }
}
