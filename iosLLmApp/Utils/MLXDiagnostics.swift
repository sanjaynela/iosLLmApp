//
//  MLXDiagnostics.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation

/// Diagnostic tool to check MLX Swift integration status
struct MLXDiagnostics {
    
    /// Check if MLX can be imported
    static var canImportMLX: Bool {
        #if canImport(MLX)
        return true
        #else
        return false
        #endif
    }
    
    /// Get detailed diagnostic information
    static func runDiagnostics() -> String {
        var diagnostics: [String] = []
        
        // Check 1: Can import MLX?
        diagnostics.append("1. MLX Import Check:")
        if canImportMLX {
            diagnostics.append("   ✅ canImport(MLX) = true")
        } else {
            diagnostics.append("   ❌ canImport(MLX) = false")
            diagnostics.append("   → Package products not linked to target")
        }
        
        // Check 2: iOS Version
        if #available(iOS 18.0, *) {
            diagnostics.append("\n2. iOS Version:")
            diagnostics.append("   ✅ iOS 18.0+ available")
        } else {
            diagnostics.append("\n2. iOS Version:")
            diagnostics.append("   ⚠️ iOS 18.0+ required for MLX LLM")
        }
        
        // Check 3: Package resolution
        diagnostics.append("\n3. Package Status:")
        if FileManager.default.fileExists(atPath: "iosLLmApp.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved") {
            diagnostics.append("   ✅ Package.resolved exists")
            diagnostics.append("   → Package is added to project")
        } else {
            diagnostics.append("   ❌ Package.resolved not found")
            diagnostics.append("   → Package not added")
        }
        
        // Recommendations
        diagnostics.append("\n📋 Recommendations:")
        if !canImportMLX {
            diagnostics.append("   1. Open Xcode")
            diagnostics.append("   2. Select project → Target → General tab")
            diagnostics.append("   3. Scroll to 'Frameworks, Libraries, and Embedded Content'")
            diagnostics.append("   4. Click '+' and add: MLX, MLXNN, MLXRandom")
            diagnostics.append("   (Note: MLXLLM is in separate package: mlx-swift-lm)")
            diagnostics.append("   5. Clean build folder (⇧⌘K)")
            diagnostics.append("   6. Rebuild (⌘B)")
            diagnostics.append("\n   See FIX_MLX_PACKAGE.md for detailed instructions")
        } else {
            diagnostics.append("   ✅ MLX is properly integrated!")
            diagnostics.append("   → You can now use MLXLLMClient")
        }
        
        return diagnostics.joined(separator: "\n")
    }
    
    /// Print diagnostics to console (for debugging)
    static func printDiagnostics() {
        print("=" * 50)
        print("MLX Swift Integration Diagnostics")
        print("=" * 50)
        print(runDiagnostics())
        print("=" * 50)
    }
}

// Helper for string repetition (Swift doesn't have this built-in)
extension String {
    static func *(lhs: String, rhs: Int) -> String {
        return String(repeating: lhs, count: rhs)
    }
}
