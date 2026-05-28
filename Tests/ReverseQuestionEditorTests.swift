import Foundation
import Testing

@testable import JobDeck

struct ReverseQuestionEditorTests {
    @Test
    func trimsFieldsWhenCreatingReverseQuestion() {
        let companyID = UUID()
        var draft = ReverseQuestionDraft()
        draft.companyID = companyID
        draft.question = "  現場で若手が任される範囲を教えてください  "
        draft.intent = "  成長機会を確認したい  "
        draft.answerMemo = "  チーム開発中心  "
        draft.nextDeepDive = "  評価制度も聞く  "
        let now = Date(timeIntervalSince1970: 1_700_000_000)

        let reverseQuestion = ReverseQuestionEditor().createReverseQuestion(from: draft, now: now)

        #expect(reverseQuestion.companyID == companyID)
        #expect(reverseQuestion.question == "現場で若手が任される範囲を教えてください")
        #expect(reverseQuestion.intent == "成長機会を確認したい")
        #expect(reverseQuestion.answerMemo == "チーム開発中心")
        #expect(reverseQuestion.nextDeepDive == "評価制度も聞く")
        #expect(reverseQuestion.updatedAt == now)
    }

    @Test
    func appliesDraftToExistingReverseQuestion() {
        let reverseQuestion = ReverseQuestion(question: "旧質問", intent: "old")
        var draft = ReverseQuestionDraft()
        draft.question = "新質問"
        draft.intent = "新しい意図"
        draft.phase = .finalInterview
        let updatedAt = Date(timeIntervalSince1970: 1_800_000_000)

        ReverseQuestionEditor().apply(draft, to: reverseQuestion, now: updatedAt)

        #expect(reverseQuestion.question == "新質問")
        #expect(reverseQuestion.intent == "新しい意図")
        #expect(reverseQuestion.phase == .finalInterview)
        #expect(reverseQuestion.updatedAt == updatedAt)
    }
}
