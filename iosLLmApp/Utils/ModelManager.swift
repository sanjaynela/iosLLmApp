//
//  ModelManager.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation

/// Manages downloading and caching LLM model files
class ModelManager {
    static let shared = ModelManager()
    
    private let documentsDirectory: URL
    
    private init() {
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    /// Get the local path for a model, downloading if necessary
    /// - Parameters:
    ///   - modelName: Name of the model (e.g., "phi-3-mini")
    ///   - url: URL to download the model from
    ///   - progress: Optional progress callback (0.0 to 1.0)
    /// - Returns: Local file path to the model, or nil if download failed
    func getModelPath(modelName: String, from url: URL?, progress: ((Double) -> Void)? = nil) async -> String? {
        let modelFileName = "\(modelName).gguf"
        let localPath = documentsDirectory.appendingPathComponent(modelFileName)
        
        // Return cached model if it exists
        if FileManager.default.fileExists(atPath: localPath.path) {
            return localPath.path
        }
        
        // Try to find model in app bundle first
        if let bundledPath = Bundle.main.path(forResource: modelName, ofType: "gguf") {
            return bundledPath
        }
        
        // Download if URL provided
        guard let url = url else {
            print("⚠️ Model not found in bundle and no download URL provided")
            return nil
        }
        
        return await downloadModel(from: url, to: localPath, progress: progress)
    }
    
    private func downloadModel(from url: URL, to destination: URL, progress: ((Double) -> Void)?) async -> String? {
        do {
            let (asyncBytes, response) = try await URLSession.shared.bytes(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let contentLength = httpResponse.value(forHTTPHeaderField: "Content-Length"),
                  let totalBytes = Int64(contentLength) else {
                print("❌ Invalid response from model server")
                return nil
            }
            
            // Create destination file
            FileManager.default.createFile(atPath: destination.path, contents: nil)
            guard let fileHandle = try? FileHandle(forWritingTo: destination) else {
                print("❌ Could not create file at destination")
                return nil
            }
            
            var downloadedBytes: Int64 = 0
            
            // Download in chunks
            for try await byte in asyncBytes {
                try fileHandle.write(contentsOf: Data([byte]))
                downloadedBytes += 1
                
                if downloadedBytes % 1_000_000 == 0 { // Update every MB
                    let progressValue = Double(downloadedBytes) / Double(totalBytes)
                    await MainActor.run {
                        progress?(progressValue)
                    }
                }
            }
            
            try fileHandle.close()
            print("✅ Model downloaded successfully to: \(destination.path)")
            return destination.path
            
        } catch {
            print("❌ Error downloading model: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Check if a model is already downloaded
    func hasModel(_ modelName: String) -> Bool {
        let modelFileName = "\(modelName).gguf"
        let localPath = documentsDirectory.appendingPathComponent(modelFileName)
        return FileManager.default.fileExists(atPath: localPath.path)
    }
    
    /// Get the size of a downloaded model
    func getModelSize(_ modelName: String) -> Int64? {
        let modelFileName = "\(modelName).gguf"
        let localPath = documentsDirectory.appendingPathComponent(modelFileName)
        
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: localPath.path),
              let size = attributes[.size] as? Int64 else {
            return nil
        }
        
        return size
    }
}
