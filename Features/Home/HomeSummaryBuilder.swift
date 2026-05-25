import Foundation

struct HomeSummaryBuilder {
    let now: Date

    func makeSnapshot(
        companies: [Company],
        decks: [InterviewDeck],
        remainingAICredits: Int
    ) -> HomeSnapshot {
        let nextCompany = companies
            .compactMap { company -> (company: Company, date: Date)? in
                guard let date = company.nextInterviewAt, date >= now else {
                    return nil
                }

                return (company: company, date: date)
            }
            .sorted { lhs, rhs in lhs.date < rhs.date }
            .first

        let deckCompanyIDs = Set(decks.map(\.companyID))
        let companiesNeedingDeckCount = companies.reduce(into: 0) { count, company in
            if company.nextInterviewAt != nil && !deckCompanyIDs.contains(company.id) {
                count += 1
            }
        }

        let recentCompanyNames = companies
            .sorted { $0.updatedAt > $1.updatedAt }
            .prefix(3)
            .map(\.name)

        return HomeSnapshot(
            nextInterviewCompanyName: nextCompany?.company.name,
            nextInterviewDate: nextCompany?.date,
            companiesNeedingDeckCount: companiesNeedingDeckCount,
            recentCompanyNames: Array(recentCompanyNames),
            remainingAICredits: remainingAICredits
        )
    }
}
