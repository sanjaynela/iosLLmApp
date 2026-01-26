//
//  iosLLmAppApp.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import SwiftUI

@main
struct iosLLmAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ChatView(vm: ChatViewModel(llm: LlamaRuntimeClient(modelPath: "")))
            }
        }
    }
}
