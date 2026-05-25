import Foundation
import Testing

@testable import JobDeck

struct HomeSummaryBuilderTests {
    @Test
    func picksEarliestUpcomingInterview() {
        let now = Date(timeIntervalSince1970: 1_717_000_000)
        let companies = [
            Company(name: "Second", nextInterviewAt: now.addingTimeInterval(60 * 60 * 48)),
            Company(name: "First", nextInterviewAt: now.addingTimeInterval(60 * 60 * 24)),
        ]
        let builder = HomeSummaryBuilder(now: now)

        let snapshot = builder.makeSnapshot(
            companies: companies,
            decks: [],
            remainingAICredits: 12
        )

        #expect(snapshot.nextInterviewCompanyName == "First")
        #expect(snapshot.companiesNeedingDeckCount == 2)
        #expect(snapshot.remainingAICredits == 12)
    }

    @Test
    func excludesCompaniesThatAlreadyHaveDecks() {
        let now = Date(timeIntervalSince1970: 1_717_000_000)
        let company = Company(name: "Atlas", nextInterviewAt: now.addingTimeInterval(60 * 60 * 24))
        let deck = InterviewDeck(companyID: company.id, interviewAt: now.addingTimeInterval(60 * 60 * 24))
        let builder = HomeSummaryBuilder(now: now)

        let snapshot = builder.makeSnapshot(
            companies: [company],
            decks: [deck],
            remainingAICredits: 20
        )

        #expect(snapshot.companiesNeedingDeckCount == 0)
    }
}
