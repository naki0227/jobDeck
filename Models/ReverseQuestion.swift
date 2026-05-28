import Foundation
import SwiftData

@Model
final class ReverseQuestion {
    var id: UUID
    var companyID: UUID?
    var question: String
    var intent: String
    var phaseRawValue: String
    var answerMemo: String
    var nextDeepDive: String
    var usedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        companyID: UUID? = nil,
        question: String,
        intent: String = "",
        phase: InterviewPhase = .firstInterview,
        answerMemo: String = "",
        nextDeepDive: String = "",
        usedAt: Date? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.companyID = companyID
        self.question = question
        self.intent = intent
        self.phaseRawValue = phase.rawValue
        self.answerMemo = answerMemo
        self.nextDeepDive = nextDeepDive
        self.usedAt = usedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var phase: InterviewPhase {
        get { InterviewPhase(rawValue: phaseRawValue) ?? .firstInterview }
        set { phaseRawValue = newValue.rawValue }
    }
}
