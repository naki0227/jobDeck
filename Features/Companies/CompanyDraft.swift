import Foundation

struct CompanyDraft: Equatable {
    var name: String = ""
    var industry: String = ""
    var jobType: String = ""
    var selectionStatus: SelectionStatus = .interested
    var priority: Int = 3
    var memo: String = ""
    var nextInterviewAt: Date?

    init() {}

    init(company: Company) {
        name = company.name
        industry = company.industry ?? ""
        jobType = company.jobType ?? ""
        selectionStatus = company.selectionStatus
        priority = company.priority
        memo = company.memo
        nextInterviewAt = company.nextInterviewAt
    }

    var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedIndustry: String? {
        Self.nilIfBlank(industry)
    }

    var trimmedJobType: String? {
        Self.nilIfBlank(jobType)
    }

    var trimmedMemo: String {
        memo.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func nilIfBlank(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
