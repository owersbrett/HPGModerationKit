import Testing
@testable import HPGModerationKit

@Test func testBundleResourceLoading() async throws {
    let moderationKit = HPGModerationKit()
    
    // Check if banned words were loaded
    print("Banned words count: \(moderationKit.bannedWords.count)")
    print("First few banned words: \(Array(moderationKit.bannedWords.prefix(5)))")
    
    #expect(moderationKit.bannedWords.count > 0,
           "Banned words should be loaded from bad-words.txt file")
}


@Test func testValidTextValidation() async throws {
    let moderationKit = HPGModerationKit()
    
    // Test clean text should return true
    let cleanTexts = [
        "Hello world",
        "This is a nice message",
        "Welcome to our community",
        "Great job everyone!",
        ""
    ]
    
    for text in cleanTexts {
        #expect(moderationKit.validateText(text) == true,
               "Clean text '\(text)' should be valid")
    }
}

@Test func testInvalidTextValidation() async throws {
    let moderationKit = HPGModerationKit()
    
    // Note: These are example banned words - replace with actual ones from your bad-words.txt
    // or create test banned words for this test
    let textWithBannedWords = [
        "This contains damn word",
        "What the hell is this",
        "You are stupid"
    ]
    
    for text in textWithBannedWords {
        #expect(moderationKit.validateText(text) == false,
               "Text with banned words '\(text)' should be invalid")
    }
}

@Test func testCaseInsensitiveValidation() async throws {
    let moderationKit = HPGModerationKit()
    
    // Test that validation is case insensitive
    let variations = [
        "DAMN this",
        "Damn this",
        "damn this",
        "dAmN this"
    ]
    
    for text in variations {
        #expect(moderationKit.validateText(text) == false,
               "Case variation '\(text)' should be caught")
    }
}

@Test func testWordBoundaryValidation() async throws {
    let moderationKit = HPGModerationKit()
    
    // Test that we don't get false positives from substrings
    // For example, if "ass" is banned, "class" shouldn't be flagged
    let legitimateWords = [
        "I'm in class today",
        "The grass is green",
        "Pass the salt please"
    ]
    
    for text in legitimateWords {
        #expect(moderationKit.validateText(text) == true,
               "Legitimate word '\(text)' should not be flagged as containing banned substrings")
    }
}

@Test func testEmptyAndWhitespaceText() async throws {
    let moderationKit = HPGModerationKit()
    
    let emptyTexts = [
        "",
        "   ",
        "\n\n",
        "\t\t"
    ]
    
    for text in emptyTexts {
        #expect(moderationKit.validateText(text) == true,
               "Empty/whitespace text '\(text)' should be valid")
    }
}

@Test func testMixedContentValidation() async throws {
    let moderationKit = HPGModerationKit()
    
    // Test text with both clean and banned content
    let mixedText = "Hello everyone, this is damn good!"
    
    #expect(moderationKit.validateText(mixedText) == false,
           "Text with mixed content should be invalid if it contains any banned words")
}

@Test func testPunctuationHandling() async throws {
    let moderationKit = HPGModerationKit()
    
    // Test that punctuation doesn't interfere with detection
    let textWithPunctuation = [
        "What the hell!",
        "Damn, that's bad.",
        "You're stupid?"
    ]
    
    for text in textWithPunctuation {
        #expect(moderationKit.validateText(text) == false,
               "Text with punctuation '\(text)' should still catch banned words")
    }
}
