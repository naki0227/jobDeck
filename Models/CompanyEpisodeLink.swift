import Foundation
import SwiftData

@Model
final class CompanyEpisodeLink {
    var id: UUID
    var companyID: UUID
    var episodeID: UUID
    var reasonToUse: String
    var expectedQuestion: String
    var priority: Int
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        companyID: UUID,
        episodeID: UUID,
        reasonToUse: String = "",
        expectedQuestion: String = "",
        priority: Int = 3,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.companyID = companyID
        self.episodeID = episodeID
        self.reasonToUse = reasonToUse
        self.expectedQuestion = expectedQuestion
        self.priority = priority
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
