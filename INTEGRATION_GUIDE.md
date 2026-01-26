# MLX Swift Integration Guide

This guide will help you integrate real LLM capabilities into your iOS app using Apple's MLX Swift framework.

## Prerequisites

- **iOS 18.0+** (required for LLM support)
- **Xcode 15.0+**
- **Apple Silicon device** (iPhone/iPad with A-series chip)
- **8GB+ RAM** recommended for running models
- **Model files** in GGUF format (quantized models work best)

## Step 1: Add MLX Swift Package

### In Xcode:

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies...**
3. Enter the package URL: `https://github.com/ml-explore/mlx-swift`
4. Select version: **0.25.3** or latest
5. Add these products to your target:
   - `MLX` (core framework)
   - `MLXNN` (neural networks)
   - `MLXRandom` (random number generation)
   - `MLXRandom` (random number generation)

### Alternative: Package.swift

If you're using Swift Package Manager directly, add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ml-explore/mlx-swift", from: "0.25.3")
],
targets: [
    .target(
        name: "iosLLmApp",
        dependencies: [
            .product(name: "MLX", package: "mlx-swift"),
            .product(name: "MLXNN", package: "mlx-swift"),
            .product(name: "MLXRandom", package: "mlx-swift")
        ]
    )
]
```

## Step 2: Update iOS Deployment Target

1. Select your project in Xcode
2. Go to **Build Settings**
3. Set **iOS Deployment Target** to **18.0** (required for MLX LLM support)

Or update `project.pbxproj`:
```
IPHONEOS_DEPLOYMENT_TARGET = 18.0;
```

## Step 3: Add Increased Memory Limit Entitlement

LLMs require more memory than default iOS apps allow.

1. Create or edit `iosLLmApp.entitlements`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.kernel.increased-memory-limit</key>
    <true/>
</dict>
</plist>
```

2. In Xcode, go to **Signing & Capabilities** → **+ Capability** → **Increased Memory Limit**

## Step 4: Download a Model

You'll need a quantized LLM model in GGUF format. Recommended models:

### Small Models (Good for testing):
- **Phi-3-mini** (3.8B parameters, ~2.5GB quantized)
- **TinyLlama** (1.1B parameters, ~700MB quantized)

### Medium Models (Better quality):
- **Mistral-7B-Instruct** (7B parameters, ~4GB quantized)
- **Llama-3-8B-Instruct** (8B parameters, ~5GB quantized)

### Where to get models:
1. **Hugging Face**: https://huggingface.co/models?search=gguf
2. **TheBloke** (popular quantizer): https://huggingface.co/TheBloke

### Download options:

**Option A: Bundle with app** (simpler, larger app size)
1. Download model file (`.gguf` extension)
2. Drag into Xcode project
3. Ensure it's added to target

**Option B: Download at runtime** (recommended)
1. Store model URL in your app
2. Download on first launch
3. Cache locally in app's documents directory

## Step 5: Update Your App Code

### Update `iosLLmAppApp.swift`:

```swift
import SwiftUI

@main
struct iosLLmAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // Use MLX client instead of placeholder
                let modelPath = Bundle.main.path(forResource: "phi-3-mini", ofType: "gguf") 
                    ?? (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("model.gguf").path ?? "")
                
                ChatView(vm: ChatViewModel(
                    llm: MLXLLMClient(modelPath: modelPath)
                ))
            }
        }
    }
}
```

### Model Loading Helper:

Create a helper to manage model downloads:

```swift
class ModelManager {
    static func downloadModelIfNeeded(url: URL, completion: @escaping (String?) -> Void) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let modelPath = documentsPath.appendingPathComponent("model.gguf")
        
        if FileManager.default.fileExists(atPath: modelPath.path) {
            completion(modelPath.path)
            return
        }
        
        // Download model
        URLSession.shared.downloadTask(with: url) { localURL, _, _ in
            guard let localURL = localURL else {
                completion(nil)
                return
            }
            
            try? FileManager.default.moveItem(at: localURL, to: modelPath)
            completion(modelPath.path)
        }.resume()
    }
}
```

## Step 6: Test on Device

⚠️ **Important**: MLX LLM features require a **real device** with Apple Silicon. The iOS Simulator may not work properly for LLM inference.

1. Connect your iPhone/iPad (iOS 18+)
2. Build and run on device
3. First launch may take time to load the model

## Troubleshooting

### "MLX not available" error
- Ensure MLX Swift package is added
- Check that you're building for iOS 18.0+
- Verify imports are correct

### Model not found
- Check model file path
- Ensure model is included in app bundle (if bundled)
- Verify file permissions

### Out of memory errors
- Use a smaller/quantized model
- Ensure "Increased Memory Limit" entitlement is set
- Close other apps on device

### Slow performance
- Use quantized models (Q4_K_M or Q5_K_M)
- Smaller models run faster
- First inference is slower (model warmup)

## Example Model URLs

For testing, you can use these publicly available models:

- Phi-3-mini: `https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4_k_m.gguf`
- TinyLlama: `https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf`

## Next Steps

1. Start with a small model (Phi-3-mini or TinyLlama)
2. Test token generation
3. Optimize prompt formatting
4. Add model download UI
5. Implement model caching

## Resources

- [MLX Swift GitHub](https://github.com/ml-explore/mlx-swift)
- [MLX Swift Examples](https://github.com/ml-explore/mlx-swift-examples)
- [Apple WWDC 2025: MLX Session](https://developer.apple.com/videos/play/wwdc2025/298/)
- [Hugging Face GGUF Models](https://huggingface.co/models?search=gguf)
