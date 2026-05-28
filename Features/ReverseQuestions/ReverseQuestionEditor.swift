import Foundation
import SwiftData

struct ReverseQuestionEditor {
    func createReverseQuestion(from draft: ReverseQuestionDraft, now: Date = .now) -> ReverseQuestion {
        ReverseQuestion(
            companyID: draft.companyID,
            question: draft.trimmedQuestion,
            intent: draft.trimmedIntent,
            phase: draft.phase,
            answerMemo: draft.trimmedAnswerMemo,
            nextDeepDive: draft.trimmedNextDeepDive,
            createdAt: now,
            updatedAt: now
        )
    }

    func apply(_ draft: ReverseQuestionDraft, to reverseQuestion: ReverseQuestion, now: Date = .now) {
        reverseQuestion.companyID = draft.companyID
        reverseQuestion.question = draft.trimmedQuestion
        reverseQuestion.intent = draft.trimmedIntent
        reverseQuestion.phase = draft.phase
        reverseQuestion.answerMemo = draft.trimmedAnswerMemo
        reverseQuestion.nextDeepDive = draft.trimmedNextDeepDive
        reverseQuestion.updatedAt = now
    }

    func save(
        draft: ReverseQuestionDraft,
        existingReverseQuestion: ReverseQuestion? = nil,
        in modelContext: ModelContext,
        now: Date = .now
    ) throws -> ReverseQuestion {
        let validator = ReverseQuestionFormValidator()
        let errors = validator.validate(draft)
        if let firstError = errors.first {
            throw ReverseQuestionFormError.validation(firstError)
        }

        if let existingReverseQuestion {
            apply(draft, to: existingReverseQuestion, now: now)
            try modelContext.save()
            return existingReverseQuestion
        }

        let reverseQuestion = createReverseQuestion(from: draft, now: now)
        modelContext.insert(reverseQuestion)
        try modelContext.save()
        return reverseQuestion
    }
}

enum ReverseQuestionFormError: LocalizedError {
    case validation(String)

    var errorDescription: String? {
        switch self {
        case let .validation(message):
            return message
        }
    }
}
