//
//  EmbeddingService.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation
import CoreML

/// Service for generating text embeddings using Core ML
/// 
/// This allows you to do local semantic search, clustering, and other
/// "AI features" even without running a full LLM on device.
final class EmbeddingService {
    private var model: MLModel?
    
    init() {
        // In a real implementation, you would load a Core ML embedding model:
        // guard let modelURL = Bundle.main.url(forResource: "MyEmbeddingModel", withExtension: "mlmodelc") else {
        //     return
        // }
        // self.model = try MLModel(contentsOf: modelURL)
    }
    
    /// Generate an embedding vector for the given text
    /// - Parameter text: Input text to embed
    /// - Returns: Embedding vector as an array of doubles
    func embed(text: String) throws -> [Double] {
        guard let model = model else {
            // Placeholder: return a dummy embedding
            // In a real implementation, you would:
            // 1. Preprocess the text (tokenization, etc.)
            // 2. Create an MLFeatureProvider with the input
            // 3. Run prediction
            // 4. Extract the embedding from the output MLMultiArray
            // 5. Convert to [Double]
            
            // Example:
            // let input = try MLDictionaryFeatureProvider(dictionary: ["text": text])
            // let output = try model.prediction(from: input)
            // let embedding = output.featureValue(for: "embedding")!.multiArrayValue!
            // return (0..<embedding.count).map { Double(embedding[$0].doubleValue) }
            
            return Array(repeating: 0.0, count: 384) // Placeholder 384-dim embedding
        }
        
        // Real implementation would use the model here
        return []
    }
    
    /// Calculate cosine similarity between two embeddings
    func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
        guard a.count == b.count else { return 0.0 }
        
        let dotProduct = zip(a, b).map(*).reduce(0, +)
        let magnitudeA = sqrt(a.map { $0 * $0 }.reduce(0, +))
        let magnitudeB = sqrt(b.map { $0 * $0 }.reduce(0, +))
        
        guard magnitudeA > 0 && magnitudeB > 0 else { return 0.0 }
        return dotProduct / (magnitudeA * magnitudeB)
    }
}
