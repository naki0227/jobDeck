import Foundation
import Testing

@testable import JobDeck

struct InterviewLogEditorTests {
    @Test
    func trimsFieldsWhenCreatingInterviewLog() {
        let companyID = UUID()
        var draft = InterviewLogDraft()
        draft.askedQuestionsText = "  なぜ志望するのか\n  チーム経験は？  "
        draft.myAnswersMemo = "  回答の順番が少し崩れた  "
        draft.stuckPoints = "  深掘りで具体例が浅かった  "
        draft.interviewerReaction = "  メモを取りながら聞いていた  "
        draft.reverseQuestionsAskedText = "  評価制度について  "
        draft.learnedInfo = "  若手でも顧客提案に出る  "
        draft.nextImprovement = "  志望理由の具体性を上げる  "
        let now = Date(timeIntervalSince1970: 1_700_000_000)

        let interviewLog = InterviewLogEditor().createInterviewLog(
            companyID: companyID,
            from: draft,
            now: now
        )

        #expect(interviewLog.companyID == companyID)
        #expect(interviewLog.askedQuestions == ["なぜ志望するのか", "チーム経験は？"])
        #expect(interviewLog.myAnswersMemo == "回答の順番が少し崩れた")
        #expect(interviewLog.learnedInfo == "若手でも顧客提案に出る")
        #expect(interviewLog.nextImprovement == "志望理由の具体性を上げる")
        #expect(interviewLog.updatedAt == now)
    }

    @Test
    func appliesDraftToExistingInterviewLog() {
        let interviewLog = InterviewLog(companyID: UUID(), askedQuestionsText: "old")
        var draft = InterviewLogDraft()
        draft.phase = .finalInterview
        draft.askedQuestionsText = "新しい質問"
        draft.learnedInfo = "新しい学び"
        draft.nextImprovement = "改善点"
        let updatedAt = Date(timeIntervalSince1970: 1_800_000_000)

        InterviewLogEditor().apply(draft, to: interviewLog, now: updatedAt)

        #expect(interviewLog.phase == .finalInterview)
        #expect(interviewLog.askedQuestions == ["新しい質問"])
        #expect(interviewLog.learnedInfo == "新しい学び")
        #expect(interviewLog.updatedAt == updatedAt)
    }
}
