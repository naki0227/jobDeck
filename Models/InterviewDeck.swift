import Foundation
import SwiftData

@Model
final class InterviewDeck {
    var id: UUID
    var companyID: UUID
    var interviewAt: Date
    var mainAxis: String
    var openingSelfIntro: String
    var cautionPoints: [String]
    var checklist: [String]
    var generatedByAI: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        companyID: UUID,
        interviewAt: Date,
        mainAxis: String = "",
        openingSelfIntro: String = "",
        cautionPoints: [String] = [],
        checklist: [String] = [],
        generatedByAI: Bool = false,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.companyID = companyID
        self.interviewAt = interviewAt
        self.mainAxis = mainAxis
        self.openingSelfIntro = openingSelfIntro
        self.cautionPoints = cautionPoints
        self.checklist = checklist
        self.generatedByAI = generatedByAI
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
