import Foundation
import SwiftData

struct CompanyEpisodeLinkEditor {
    func createLink(
        companyID: UUID,
        episodeID: UUID,
        reasonToUse: String,
        expectedQuestion: String,
        priority: Int,
        now: Date = .now
    ) -> CompanyEpisodeLink {
        CompanyEpisodeLink(
            companyID: companyID,
            episodeID: episodeID,
            reasonToUse: reasonToUse.trimmingCharacters(in: .whitespacesAndNewlines),
            expectedQuestion: expectedQuestion.trimmingCharacters(in: .whitespacesAndNewlines),
            priority: priority,
            createdAt: now,
            updatedAt: now
        )
    }

    func save(
        companyID: UUID,
        episodeID: UUID,
        reasonToUse: String,
        expectedQuestion: String,
        priority: Int,
        in modelContext: ModelContext,
        now: Date = .now
    ) throws -> CompanyEpisodeLink {
        let link = createLink(
            companyID: companyID,
            episodeID: episodeID,
            reasonToUse: reasonToUse,
            expectedQuestion: expectedQuestion,
            priority: priority,
            now: now
        )
        modelContext.insert(link)
        try modelContext.save()
        return link
    }
}
