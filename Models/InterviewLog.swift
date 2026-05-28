import Foundation
import SwiftData

@Model
final class InterviewLog {
    var id: UUID
    var companyID: UUID
    var interviewAt: Date
    var phaseRawValue: String
    var askedQuestionsText: String
    var myAnswersMemo: String
    var stuckPoints: String
    var interviewerReaction: String
    var reverseQuestionsAskedText: String
    var learnedInfo: String
    var nextImprovement: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        companyID: UUID,
        interviewAt: Date = .now,
        phase: InterviewPhase = .firstInterview,
        askedQuestionsText: String = "",
        myAnswersMemo: String = "",
        stuckPoints: String = "",
        interviewerReaction: String = "",
        reverseQuestionsAskedText: String = "",
        learnedInfo: String = "",
        nextImprovement: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.companyID = companyID
        self.interviewAt = interviewAt
        self.phaseRawValue = phase.rawValue
        self.askedQuestionsText = askedQuestionsText
        self.myAnswersMemo = myAnswersMemo
        self.stuckPoints = stuckPoints
        self.interviewerReaction = interviewerReaction
        self.reverseQuestionsAskedText = reverseQuestionsAskedText
        self.learnedInfo = learnedInfo
        self.nextImprovement = nextImprovement
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var phase: InterviewPhase {
        get { InterviewPhase(rawValue: phaseRawValue) ?? .firstInterview }
        set { phaseRawValue = newValue.rawValue }
    }

    var askedQuestions: [String] {
        Self.lines(from: askedQuestionsText)
    }

    var reverseQuestionsAsked: [String] {
        Self.lines(from: reverseQuestionsAskedText)
    }

    private static func lines(from text: String) -> [String] {
        text
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
