import Foundation
import Testing

@testable import JobDeck

struct CompanyEpisodeLinkEditorTests {
    @Test
    func trimsFieldsWhenCreatingLink() {
        let companyID = UUID()
        let episodeID = UUID()
        let now = Date(timeIntervalSince1970: 1_900_000_000)

        let link = CompanyEpisodeLinkEditor().createLink(
            companyID: companyID,
            episodeID: episodeID,
            reasonToUse: "  志望理由の根拠を示せる  ",
            expectedQuestion: "  なぜこの経験を話すのか  ",
            priority: 4,
            now: now
        )

        #expect(link.companyID == companyID)
        #expect(link.episodeID == episodeID)
        #expect(link.reasonToUse == "志望理由の根拠を示せる")
        #expect(link.expectedQuestion == "なぜこの経験を話すのか")
        #expect(link.priority == 4)
        #expect(link.createdAt == now)
        #expect(link.updatedAt == now)
    }
}
