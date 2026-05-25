import Foundation

@Observable
final class HomeViewModel {
    private(set) var snapshot: HomeSnapshot

    init(
        store: PreviewStore = PreviewStore(),
        now: Date = .now,
        remainingAICredits: Int = 20
    ) {
        let companies = store.makeCompanies(now: now)
        let decks = store.makeDecks(companies: companies, now: now)
        let builder = HomeSummaryBuilder(now: now)
        self.snapshot = builder.makeSnapshot(
            companies: companies,
            decks: decks,
            remainingAICredits: remainingAICredits
        )
    }
}
