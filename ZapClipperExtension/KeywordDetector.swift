import Foundation

struct KeywordDetector {

    static var frenchKeywords: [String] {
        KeywordStore.shared.load().french
    }

    static var englishKeywords: [String] {
        KeywordStore.shared.load().english
    }

    /// Check if the given text contains any attachment-related keywords.
    /// Returns the first matched keyword, or nil if none found.
    static func findKeyword(in text: String) -> String? {
        let lowered = text.lowercased()
        let data = KeywordStore.shared.load()
        for keyword in data.french + data.english {
            if lowered.contains(keyword.lowercased()) {
                return keyword
            }
        }
        return nil
    }
}
