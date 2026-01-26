# iOS On-Device LLM Demo

A sample iOS app demonstrating how to run LLMs and AI features on-device using Apple's native frameworks and open-source runtimes.

## Overview

This project is a practical implementation guide for iOS developers who want to add on-device AI capabilities to their apps. It demonstrates:

- **Apple Foundation Models** (placeholder for future APIs)
- **Core ML** for embeddings and classification
- **NaturalLanguage Framework** for entity extraction and language detection
- **LLM Runtime Integration** (llama.cpp-style) for token-by-token generation
- **SwiftUI Chat Interface** with streaming token updates

## Project Structure

```
iosLLmApp/
├── App/
│   └── iosLLmAppApp.swift          # Main app entry point
├── Features/
│   └── Chat/
│       ├── ChatView.swift          # SwiftUI chat interface
│       ├── ChatViewModel.swift     # Chat state management
│       └── ChatMessage.swift       # Message model
├── AI/
│   ├── LLM/
│   │   ├── LLMClientProtocol.swift # Protocol for LLM clients
│   │   ├── LLMConfig.swift         # LLM configuration
│   │   ├── LlamaRuntimeClient.swift # Example runtime client
│   │   └── AppleFoundationLLMClient.swift # Apple APIs client
│   └── Embeddings/
│       └── EmbeddingService.swift  # Core ML embedding service
└── Utils/
    ├── PerformanceMonitor.swift    # Performance logging
    └── NaturalLanguageHelper.swift # NaturalLanguage framework helpers
```

## Features

### ✅ Implemented

- **Chat UI**: SwiftUI interface with token streaming
- **LLM Protocol**: Swappable client architecture
- **Performance Monitoring**: Simple latency logging
- **NaturalLanguage Integration**: Entity extraction and language detection
- **Embedding Service**: Core ML integration structure (placeholder)
- **Mock LLM Client**: Pattern-based responses for immediate testing
- **MLX Integration Structure**: Ready for Apple's MLX Swift framework
- **Model Manager**: Download and cache LLM models
- **Model Selection UI**: Choose between mock and real LLM clients

### 🚧 Real LLM Integration (Optional)

- **MLX Swift Setup**: See `QUICK_START.md` for step-by-step instructions
- **Model Download**: Built-in UI to download quantized models
- **Apple Foundation Models**: Placeholder ready for future APIs
- **Core ML Embeddings**: Add actual embedding model
- **Prompt Truncation**: Context length management

## Getting Started

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0+ deployment target (18.0+ for real MLX LLM)
- Swift 5.9+

### Quick Start (Mock Client - Works Immediately)

1. **Clone the repository**
   ```bash
   git clone https://github.com/sanjaynela/iosLLmApp.git
   cd iosLLmApp
   ```

2. **Open in Xcode**
   ```bash
   open iosLLmApp.xcodeproj
   ```

3. **Build and Run**
   - Select a simulator or device
   - Press ⌘R to build and run
   - Choose "Use Mock Client" to test immediately

### Adding Real LLM with MLX Swift

For actual AI responses using Apple's MLX framework, see **[QUICK_START.md](QUICK_START.md)** for detailed step-by-step instructions.

**Quick summary:**
1. Add MLX Swift package dependency
2. Set iOS deployment target to 18.0+
3. Add "Increased Memory Limit" entitlement
4. Download a quantized model (or use built-in downloader)
5. App will use real LLM automatically

### Alternative: Adding Other LLM Runtimes

To integrate other runtimes (like llama.cpp):

1. **Choose a runtime**: Popular options include:
   - [llama.cpp](https://github.com/ggerganov/llama.cpp) (C++ with Swift bindings)
   - [MLX](https://github.com/ml-explore/mlx-swift) (Apple Silicon optimized)
   - Custom Core ML models

2. **Add the dependency**:
   - Swift Package Manager: Add the package URL
   - CocoaPods: Add to `Podfile`
   - Manual: Drag framework into project

3. **Update `LlamaRuntimeClient.swift`**:
   - Replace placeholder logic with actual model loading
   - Implement proper tokenization/detokenization
   - Handle EOS tokens and context management

### Adding a Core ML Embedding Model

1. **Obtain or convert a model**:
   - Use [coremltools](https://coremltools.readme.io/) to convert PyTorch/TensorFlow models
   - Download pre-converted models from Hugging Face

2. **Add to Xcode project**:
   - Drag `.mlmodel` or `.mlpackage` into the project
   - Ensure it's included in the app target

3. **Update `EmbeddingService.swift`**:
   - Uncomment and configure model loading
   - Map input/output feature names correctly
   - Convert `MLMultiArray` to `[Double]`

## Architecture

### LLM Client Protocol

The app uses a protocol-based architecture to keep the LLM runtime swappable:

```swift
protocol LLMClientProtocol {
    func generate(prompt: String, onToken: @escaping (String) -> Void) async throws
}
```

This allows you to:
- Switch between different runtimes easily
- Test with mock implementations
- Support multiple model backends

### Token Streaming

The chat interface streams tokens as they're generated, providing a responsive user experience:

```swift
try await llm.generate(prompt: prompt) { token in
    // Update UI with each token
    messages[assistantIndex].text += token
}
```

### Performance Monitoring

Simple performance logging is built in:

```swift
Perf.measure("Model inference") {
    // Your code here
}
```

## Decision Guide

### When to Use Each Approach

**Apple Foundation Models** (when available):
- ✅ Common AI features (summaries, writing helpers)
- ✅ Minimal app size
- ✅ Best Apple ecosystem integration
- ❌ OS/version constraints
- ❌ Limited customization

**Core ML**:
- ✅ Well-defined input/output models
- ✅ Embeddings, vision, audio, classification
- ✅ Stable deployment
- ❌ Less flexible for chat-style generation

**Open-Source LLM Runtime**:
- ✅ Chat-style token streaming
- ✅ Popular community models
- ✅ Full control over inference
- ❌ Larger app size
- ❌ More complex setup

## Common Pitfalls

1. **Model Size**: Start small (1B-3B parameters, quantized)
2. **Memory Management**: Monitor memory usage, especially on older devices
3. **Thermal Throttling**: Sustained generation can cause throttling
4. **Context Length**: Don't let prompts grow indefinitely
5. **Cancellation**: Always support task cancellation for user experience

## Performance Notes

- **First-token latency**: Can be high due to model load + warmup
- **Memory spikes**: Monitor on older devices
- **Thermals**: Sustained generation can throttle
- **Context length**: Grows cost non-linearly

## Next Steps

Planned improvements:
- [ ] Prompt truncation + memory strategy
- [ ] System prompt + output formatting rules
- [ ] Streaming UI polish (typing indicator, partial token rendering)
- [ ] Model download manager + versioning
- [ ] Offline RAG: embeddings + small local knowledge base

## Resources

- [Apple Core ML Documentation](https://developer.apple.com/documentation/coreml)
- [NaturalLanguage Framework](https://developer.apple.com/documentation/naturallanguage)
- [Swift Concurrency](https://developer.apple.com/documentation/swift/concurrency)

## License

This project is provided as-is for educational purposes.

## Author

Sanjay Nelagadde - [GitHub](https://github.com/sanjaynela)

## Related Articles

- [iOS On-Device LLMs: Foundation Models + ML Frameworks You Can Actually Ship](https://github.com/sanjaynela/iosLLmApp) - Full article with detailed explanations
