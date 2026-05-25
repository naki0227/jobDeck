import Foundation

struct CompanyListMetricsBuilder {
    func build(from companies: [Company]) -> CompanyListMetrics {
        let activeCompaniesCount = companies.filter {
            $0.selectionStatus != .rejected && $0.selectionStatus != .declined
        }.count

        let interviewScheduledCount = companies.filter {
            $0.nextInterviewAt != nil
        }.count

        let highPriorityCount = companies.filter {
            $0.priority >= 4
        }.count

        return CompanyListMetrics(
            activeCompaniesCount: activeCompaniesCount,
            interviewScheduledCount: interviewScheduledCount,
            highPriorityCount: highPriorityCount
        )
    }
}
