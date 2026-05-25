import Foundation
import Testing

@testable import JobDeck

struct CompanyEpisodeLinkBuilderTests {
    @Test
    func excludesAlreadyLinkedEpisodesAndSortsRecentFirst() {
        let older = Episode(
            title: "older",
            summaryForInterview: "",
            updatedAt: Date(timeIntervalSince1970: 1_000)
        )
        let newer = Episode(
            title: "newer",
            summaryForInterview: "summary",
            updatedAt: Date(timeIntervalSince1970: 2_000)
        )
        let linked = Episode(title: "linked", updatedAt: Date(timeIntervalSince1970: 3_000))
        let link = CompanyEpisodeLink(companyID: UUID(), episodeID: linked.id)

        let candidates = CompanyEpisodeLinkBuilder().availableEpisodes(
            allEpisodes: [older, newer, linked],
            existingLinks: [link]
        )

        #expect(candidates.map(\.title) == ["newer", "older"])
    }
}
