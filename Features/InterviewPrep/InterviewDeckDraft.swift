import Foundation

struct InterviewDeckDraft: Equatable {
    var interviewAt: Date = .now
    var phase: InterviewPhase = .firstInterview
    var mainAxis: String = ""
    var openingSelfIntro: String = ""
    var selectedEpisodesText: String = ""
    var reverseQuestionsText: String = ""
    var cautionPointsText: String = ""
    var previousReflection: String = ""
    var checklistText: String = ""

    init() {}

    init(interviewDeck: InterviewDeck) {
        interviewAt = interviewDeck.interviewAt
        phase = interviewDeck.phase
        mainAxis = interviewDeck.mainAxis
        openingSelfIntro = interviewDeck.openingSelfIntro
        selectedEpisodesText = interviewDeck.selectedEpisodesText
        reverseQuestionsText = interviewDeck.reverseQuestionsText
        cautionPointsText = interviewDeck.cautionPoints.joined(separator: "\n")
        previousReflection = interviewDeck.previousReflection
        checklistText = interviewDeck.checklist.joined(separator: "\n")
    }

    var trimmedMainAxis: String {
        mainAxis.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedOpeningSelfIntro: String {
        openingSelfIntro.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedSelectedEpisodesText: String {
        selectedEpisodesText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedReverseQuestionsText: String {
        reverseQuestionsText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedCautionPointsText: String {
        cautionPointsText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedPreviousReflection: String {
        previousReflection.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedChecklistText: String {
        checklistText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
