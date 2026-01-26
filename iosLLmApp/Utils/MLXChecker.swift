//
//  MLXChecker.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation

struct MLXChecker {
    static var isMLXAvailable: Bool {
        #if canImport(MLX)
        return true
        #else
        return false
        #endif
    }
    
    static var statusMessage: String {
        if isMLXAvailable {
            return "✅ MLX Swift is available"
        } else {
            return "⚠️ MLX Swift not integrated - Add package to enable real AI"
        }
    }
    
    static var setupInstructions: String {
        """
        To enable real AI responses with MLX:
        
        1. Open Xcode
        2. File → Add Package Dependencies
        3. URL: https://github.com/ml-explore/mlx-swift
        4. Version: 0.25.3 or latest
        5. Add products: MLX, MLXNN, MLXRandom
        6. Set iOS deployment target to 18.0+
        7. Add "Increased Memory Limit" entitlement
        8. Rebuild project
        
        See QUICK_START.md for detailed instructions.
        """
    }
}
