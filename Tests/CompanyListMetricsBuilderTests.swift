import Foundation
import Testing

@testable import JobDeck

struct CompanyListMetricsBuilderTests {
    @Test
    func countsActiveInterviewAndHighPriorityCompanies() {
        let companies = [
            Company(name: "Atlas", selectionStatus: .applied, priority: 5),
            Company(name: "Northwind", selectionStatus: .rejected, priority: 4),
            Company(
                name: "Harbor",
                selectionStatus: .interviewScheduled,
                priority: 3,
                nextInterviewAt: .now
            ),
        ]

        let metrics = CompanyListMetricsBuilder().build(from: companies)

        #expect(metrics.activeCompaniesCount == 2)
        #expect(metrics.interviewScheduledCount == 1)
        #expect(metrics.highPriorityCount == 2)
    }
}
