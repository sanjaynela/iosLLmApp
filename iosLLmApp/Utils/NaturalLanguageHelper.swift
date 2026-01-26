//
//  NaturalLanguageHelper.swift
//  iosLLmApp
//
//  Created by Sanjay Nelagadde on 1/26/26.
//

import Foundation
import NaturalLanguage

/// Helper functions for using Apple's NaturalLanguage framework
/// 
/// This demonstrates how to use Apple's high-level ML frameworks for
/// on-device language processing without needing a full LLM.
struct NaturalLanguageHelper {
    /// Extract named entities from text
    /// - Parameter text: Input text
    /// - Returns: Array of extracted entity strings
    static func extractEntities(from text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text
        var entities: [String] = []
        let range = text.startIndex..<text.endIndex
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: [.omitPunctuation, .omitWhitespace]) { tag, tokenRange in
            if tag != nil {
                entities.append(String(text[tokenRange]))
            }
            return true
        }
        
        return entities
    }
    
    /// Detect the language of the text
    /// - Parameter text: Input text
    /// - Returns: Detected language code (e.g., "en", "es", "fr")
    static func detectLanguage(of text: String) -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        return recognizer.dominantLanguage?.rawValue
    }
}
