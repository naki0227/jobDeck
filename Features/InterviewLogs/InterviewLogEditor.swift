import Foundation
import SwiftData

struct InterviewLogEditor {
    func createInterviewLog(
        companyID: UUID,
        from draft: InterviewLogDraft,
        now: Date = .now
    ) -> InterviewLog {
        InterviewLog(
            companyID: companyID,
            interviewAt: draft.interviewAt,
            phase: draft.phase,
            askedQuestionsText: draft.trimmedAskedQuestionsText,
            myAnswersMemo: draft.trimmedAnswersMemo,
            stuckPoints: draft.trimmedStuckPoints,
            interviewerReaction: draft.trimmedInterviewerReaction,
            reverseQuestionsAskedText: draft.trimmedReverseQuestionsAskedText,
            learnedInfo: draft.trimmedLearnedInfo,
            nextImprovement: draft.trimmedNextImprovement,
            createdAt: now,
            updatedAt: now
        )
    }

    func apply(_ draft: InterviewLogDraft, to interviewLog: InterviewLog, now: Date = .now) {
        interviewLog.interviewAt = draft.interviewAt
        interviewLog.phase = draft.phase
        interviewLog.askedQuestionsText = draft.trimmedAskedQuestionsText
        interviewLog.myAnswersMemo = draft.trimmedAnswersMemo
        interviewLog.stuckPoints = draft.trimmedStuckPoints
        interviewLog.interviewerReaction = draft.trimmedInterviewerReaction
        interviewLog.reverseQuestionsAskedText = draft.trimmedReverseQuestionsAskedText
        interviewLog.learnedInfo = draft.trimmedLearnedInfo
        interviewLog.nextImprovement = draft.trimmedNextImprovement
        interviewLog.updatedAt = now
    }

    func save(
        companyID: UUID,
        draft: InterviewLogDraft,
        existingInterviewLog: InterviewLog? = nil,
        in modelContext: ModelContext,
        now: Date = .now
    ) throws -> InterviewLog {
        let validator = InterviewLogFormValidator()
        let errors = validator.validate(draft)
        if let firstError = errors.first {
            throw InterviewLogFormError.validation(firstError)
        }

        if let existingInterviewLog {
            apply(draft, to: existingInterviewLog, now: now)
            try modelContext.save()
            return existingInterviewLog
        }

        let interviewLog = createInterviewLog(companyID: companyID, from: draft, now: now)
        modelContext.insert(interviewLog)
        try modelContext.save()
        return interviewLog
    }
}

enum InterviewLogFormError: LocalizedError {
    case validation(String)

    var errorDescription: String? {
        switch self {
        case let .validation(message):
            return message
        }
    }
}
