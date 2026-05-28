import Foundation
import Testing

@testable import JobDeck

struct InterviewDeckFormValidatorTests {
    @Test
    func requiresAxisEpisodesQuestionsAndChecklist() {
        let draft = InterviewDeckDraft()

        let messages = InterviewDeckFormValidator().validate(draft)

        #expect(messages.contains("今日伝える軸を1つ書いておきましょう。"))
        #expect(messages.contains("使うエピソードを最低1つ残しておきましょう。"))
        #expect(messages.contains("逆質問を最低1つ入れておきましょう。"))
        #expect(messages.contains("最後のチェックリストを最低1つ入れておきましょう。"))
    }
}
