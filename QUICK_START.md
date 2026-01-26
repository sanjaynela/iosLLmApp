# Quick Start: Real LLM Integration

## Option 1: Use Mock Client (Works Now)

The app currently uses a mock client that generates responses based on pattern matching. This works immediately without any setup.

## Option 2: Use Real MLX Swift (Requires Setup)

### Prerequisites Check:
- [ ] iOS 18.0+ device (check Settings → General → About)
- [ ] Xcode 15.0+
- [ ] Apple Silicon device (iPhone with A-series chip)
- [ ] 8GB+ RAM device recommended

### Step-by-Step Setup:

#### 1. Add MLX Swift Package (5 minutes)

1. Open `iosLLmApp.xcodeproj` in Xcode
2. Click on your project in the navigator
3. Select your app target
4. Go to **"Package Dependencies"** tab
5. Click **"+"** button
6. Paste: `https://github.com/ml-explore/mlx-swift`
7. Click **"Add Package"**
8. Select these products:
   - ✅ MLX (core framework)
   - ✅ MLXNN (neural networks)
   - ✅ MLXRandom (random number generation)
   - Note: For LLM support, you may also need mlx-swift-lm package
9. Click **"Add Package"**

#### 2. Update Deployment Target (2 minutes)

1. Select project in navigator
2. Select your app target
3. Go to **"General"** tab
4. Set **"Minimum Deployments"** → **iOS** to **18.0**

#### 3. Add Memory Entitlement (2 minutes)

1. Select your app target
2. Go to **"Signing & Capabilities"** tab
3. Click **"+ Capability"**
4. Search for **"Increased Memory Limit"**
5. Add it

#### 4. Download a Model (10-30 minutes)

**Recommended for first test: TinyLlama (smallest, fastest)**

The app includes a model downloader. When you select "Use MLX Client", you'll see options to download models.

Or manually:
1. Visit: https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF
2. Download: `tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf` (~700MB)
3. Drag into Xcode project
4. Ensure it's added to target

#### 5. Update Code to Use MLX

The `MLXLLMClient.swift` file is already created. You need to:

1. Update `iosLLmAppApp.swift` to use MLX client when model is available
2. The MLX client implementation may need adjustments based on the actual MLX Swift API

**Note**: The MLX Swift API is evolving. Check the [official examples](https://github.com/ml-explore/mlx-swift-examples) for the latest API usage.

### Testing

1. Build and run on a **real device** (not simulator)
2. First launch: Model loads (may take 30-60 seconds)
3. Type a message and see real AI responses!

## Troubleshooting

### "MLX not available" error
- ✅ Check package is added
- ✅ Check iOS deployment target is 18.0+
- ✅ Rebuild project

### Model not found
- ✅ Check model file is in bundle
- ✅ Check file name matches code
- ✅ Try downloading via app's model selector

### App crashes on launch
- ✅ Ensure "Increased Memory Limit" entitlement is set
- ✅ Use a smaller model
- ✅ Check device has enough RAM (8GB+)

### Slow responses
- ✅ First response is always slower (model warmup)
- ✅ Use quantized models (Q4_K_M or Q5_K_M)
- ✅ Smaller models = faster responses

## Recommended Models for Testing

| Model | Size | Quality | Speed | Best For |
|-------|------|---------|-------|----------|
| TinyLlama | ~700MB | Good | Fast | Quick testing |
| Phi-3 Mini | ~2.5GB | Better | Medium | Good balance |
| Mistral-7B | ~4GB | Best | Slower | Best quality |

Start with TinyLlama, then upgrade if you want better quality.

## Next Steps

Once MLX is working:
1. Experiment with different models
2. Tune temperature and max tokens
3. Add system prompts
4. Implement prompt caching
5. Add conversation memory management

## Need Help?

- [MLX Swift Examples](https://github.com/ml-explore/mlx-swift-examples)
- [MLX Swift Documentation](https://github.com/ml-explore/mlx-swift)
- Check `INTEGRATION_GUIDE.md` for detailed instructions
