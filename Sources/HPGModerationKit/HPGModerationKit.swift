import UIKit
import NSFWDetector

public protocol MediaModerationService {
    func validateImage(_ image: UIImage) async throws -> Bool
    func validateText(_ text: String) -> Bool
}

public final class HPGModerationKit: MediaModerationService, Sendable {
    public let bannedWords: Set<String>
    public init() {
        self.bannedWords = BannedWords.wordsSet
    }
    
    // Test initializer with custom banned words
    init(testBannedWords: Set<String>) {
        self.bannedWords = testBannedWords
    }

    public func validateImage(_ image: UIImage) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            NSFWDetector.shared.check(image: image) { result in
                switch result {
                case .success(let confidence):
                    continuation.resume(returning: confidence < 0.1)
                case .error(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    public func validateText(_ text: String) -> Bool {
           let lowercased = text.lowercased()
           
           return !bannedWords.contains { bannedWord in
               let words = lowercased.components(separatedBy: .whitespacesAndNewlines)
                   .filter { !$0.isEmpty }
               return words.contains { word in
                   // Remove punctuation from the word for comparison
                   let cleanWord = word.trimmingCharacters(in: .punctuationCharacters)
                   return cleanWord == bannedWord
               }
           }
       }
}
