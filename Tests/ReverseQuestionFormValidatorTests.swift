import Foundation
import Testing

@testable import JobDeck

struct ReverseQuestionFormValidatorTests {
    @Test
    func requiresQuestion() {
        let draft = ReverseQuestionDraft()

        let messages = ReverseQuestionFormValidator().validate(draft)

        #expect(messages.contains("逆質問は必須です。"))
    }

    @Test
    func rejectsTooLongQuestionAndIntent() {
        var draft = ReverseQuestionDraft()
        draft.question = String(repeating: "q", count: 201)
        draft.intent = String(repeating: "i", count: 121)

        let messages = ReverseQuestionFormValidator().validate(draft)

        #expect(messages.contains("逆質問は200文字以内にしてください。"))
        #expect(messages.contains("意図メモは120文字以内にしてください。"))
    }
}
