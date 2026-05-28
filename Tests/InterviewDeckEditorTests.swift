import Foundation
import Testing

@testable import JobDeck

struct InterviewDeckEditorTests {
    @Test
    func trimsFieldsWhenCreatingInterviewDeck() {
        let companyID = UUID()
        var draft = InterviewDeckDraft()
        draft.mainAxis = "  顧客体験を仕組みから支えたい  "
        draft.openingSelfIntro = "  今日は強みを二つ軸にお話しします  "
        draft.selectedEpisodesText = "  USJの新人教育\n  研究室での改善  "
        draft.reverseQuestionsText = "  評価基準について\n  若手の裁量について  "
        draft.cautionPointsText = "  抽象論で終わらない  "
        draft.previousReflection = "  志望理由が少し浅かった  "
        draft.checklistText = "  カメラ確認\n  企業名確認  "
        let now = Date(timeIntervalSince1970: 1_700_000_000)

        let interviewDeck = InterviewDeckEditor().createInterviewDeck(
            companyID: companyID,
            from: draft,
            now: now
        )

        #expect(interviewDeck.companyID == companyID)
        #expect(interviewDeck.mainAxis == "顧客体験を仕組みから支えたい")
        #expect(interviewDeck.selectedEpisodes == ["USJの新人教育", "研究室での改善"])
        #expect(interviewDeck.reverseQuestions == ["評価基準について", "若手の裁量について"])
        #expect(interviewDeck.cautionPoints == ["抽象論で終わらない"])
        #expect(interviewDeck.checklist == ["カメラ確認", "企業名確認"])
        #expect(interviewDeck.updatedAt == now)
    }

    @Test
    func appliesDraftToExistingInterviewDeck() {
        let interviewDeck = InterviewDeck(companyID: UUID(), interviewAt: .now)
        var draft = InterviewDeckDraft()
        draft.phase = .finalInterview
        draft.mainAxis = "意思決定の速さを伝える"
        draft.selectedEpisodesText = "アルバイト改善"
        draft.reverseQuestionsText = "開発体制について"
        draft.checklistText = "マイク確認"
        let updatedAt = Date(timeIntervalSince1970: 1_800_000_000)

        InterviewDeckEditor().apply(draft, to: interviewDeck, now: updatedAt)

        #expect(interviewDeck.phase == .finalInterview)
        #expect(interviewDeck.mainAxis == "意思決定の速さを伝える")
        #expect(interviewDeck.selectedEpisodes == ["アルバイト改善"])
        #expect(interviewDeck.reverseQuestions == ["開発体制について"])
        #expect(interviewDeck.checklist == ["マイク確認"])
        #expect(interviewDeck.updatedAt == updatedAt)
    }
}
