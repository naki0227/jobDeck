import Foundation
import SwiftData

struct InterviewDeckEditor {
    func createInterviewDeck(
        companyID: UUID,
        from draft: InterviewDeckDraft,
        now: Date = .now
    ) -> InterviewDeck {
        InterviewDeck(
            companyID: companyID,
            interviewAt: draft.interviewAt,
            phase: draft.phase,
            mainAxis: draft.trimmedMainAxis,
            openingSelfIntro: draft.trimmedOpeningSelfIntro,
            selectedEpisodesText: draft.trimmedSelectedEpisodesText,
            reverseQuestionsText: draft.trimmedReverseQuestionsText,
            cautionPoints: splitLines(draft.trimmedCautionPointsText),
            previousReflection: draft.trimmedPreviousReflection,
            checklist: splitLines(draft.trimmedChecklistText),
            createdAt: now,
            updatedAt: now
        )
    }

    func apply(_ draft: InterviewDeckDraft, to interviewDeck: InterviewDeck, now: Date = .now) {
        interviewDeck.interviewAt = draft.interviewAt
        interviewDeck.phase = draft.phase
        interviewDeck.mainAxis = draft.trimmedMainAxis
        interviewDeck.openingSelfIntro = draft.trimmedOpeningSelfIntro
        interviewDeck.selectedEpisodesText = draft.trimmedSelectedEpisodesText
        interviewDeck.reverseQuestionsText = draft.trimmedReverseQuestionsText
        interviewDeck.cautionPoints = splitLines(draft.trimmedCautionPointsText)
        interviewDeck.previousReflection = draft.trimmedPreviousReflection
        interviewDeck.checklist = splitLines(draft.trimmedChecklistText)
        interviewDeck.updatedAt = now
    }

    func save(
        companyID: UUID,
        draft: InterviewDeckDraft,
        existingInterviewDeck: InterviewDeck? = nil,
        in modelContext: ModelContext,
        now: Date = .now
    ) throws -> InterviewDeck {
        let validator = InterviewDeckFormValidator()
        let errors = validator.validate(draft)
        if let firstError = errors.first {
            throw InterviewDeckFormError.validation(firstError)
        }

        if let existingInterviewDeck {
            apply(draft, to: existingInterviewDeck, now: now)
            try modelContext.save()
            return existingInterviewDeck
        }

        let interviewDeck = createInterviewDeck(companyID: companyID, from: draft, now: now)
        modelContext.insert(interviewDeck)
        try modelContext.save()
        return interviewDeck
    }

    private func splitLines(_ text: String) -> [String] {
        text
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}

enum InterviewDeckFormError: LocalizedError {
    case validation(String)

    var errorDescription: String? {
        switch self {
        case let .validation(message):
            return message
        }
    }
}
