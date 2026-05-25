import Foundation

struct CompanyEpisodeLinkCandidate: Identifiable, Equatable {
    let id: UUID
    let title: String
    let summary: String
    let updatedAt: Date
}

struct CompanyEpisodeLinkBuilder {
    func availableEpisodes(
        allEpisodes: [Episode],
        existingLinks: [CompanyEpisodeLink]
    ) -> [CompanyEpisodeLinkCandidate] {
        let linkedEpisodeIDs = Set(existingLinks.map(\.episodeID))

        return allEpisodes
            .filter { !linkedEpisodeIDs.contains($0.id) }
            .sorted { $0.updatedAt > $1.updatedAt }
            .map {
                CompanyEpisodeLinkCandidate(
                    id: $0.id,
                    title: $0.title,
                    summary: $0.summaryForInterview,
                    updatedAt: $0.updatedAt
                )
            }
    }
}
