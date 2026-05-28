import Foundation
import SwiftData

@Model
final class InterviewDeck {
    var id: UUID
    var companyID: UUID
    var interviewAt: Date
    var phaseRawValue: String
    var mainAxis: String
    var openingSelfIntro: String
    var selectedEpisodesText: String
    var reverseQuestionsText: String
    var cautionPoints: [String]
    var previousReflection: String
    var checklist: [String]
    var generatedByAI: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        companyID: UUID,
        interviewAt: Date,
        phase: InterviewPhase = .firstInterview,
        mainAxis: String = "",
        openingSelfIntro: String = "",
        selectedEpisodesText: String = "",
        reverseQuestionsText: String = "",
        cautionPoints: [String] = [],
        previousReflection: String = "",
        checklist: [String] = [],
        generatedByAI: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.companyID = companyID
        self.interviewAt = interviewAt
        self.phaseRawValue = phase.rawValue
        self.mainAxis = mainAxis
        self.openingSelfIntro = openingSelfIntro
        self.selectedEpisodesText = selectedEpisodesText
        self.reverseQuestionsText = reverseQuestionsText
        self.cautionPoints = cautionPoints
        self.previousReflection = previousReflection
        self.checklist = checklist
        self.generatedByAI = generatedByAI
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var phase: InterviewPhase {
        get { InterviewPhase(rawValue: phaseRawValue) ?? .firstInterview }
        set { phaseRawValue = newValue.rawValue }
    }

    var selectedEpisodes: [String] {
        Self.splitLines(selectedEpisodesText)
    }

    var reverseQuestions: [String] {
        Self.splitLines(reverseQuestionsText)
    }

    private static func splitLines(_ text: String) -> [String] {
        text
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
