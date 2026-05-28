import Foundation
import Testing

@testable import JobDeck

struct InterviewLogFormValidatorTests {
    @Test
    func requiresQuestionsLearnedInfoAndImprovement() {
        let draft = InterviewLogDraft()

        let messages = InterviewLogFormValidator().validate(draft)

        #expect(messages.contains("聞かれた質問は最低1つ残しておきましょう。"))
        #expect(messages.contains("面接で得た情報は最低限残しておきましょう。"))
        #expect(messages.contains("次回への改善点を1つ書いておきましょう。"))
    }
}
