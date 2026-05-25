import Foundation
import Testing

@testable import JobDeck

struct CompanyEditorTests {
    @Test
    func trimsFieldsWhenCreatingCompany() {
        var draft = CompanyDraft()
        draft.name = "  Atlas Systems  "
        draft.industry = "  IT  "
        draft.jobType = "  iOS Engineer  "
        draft.memo = "  user-first culture  "
        draft.priority = 5
        let now = Date(timeIntervalSince1970: 1_700_000_000)

        let company = CompanyEditor().createCompany(from: draft, now: now)

        #expect(company.name == "Atlas Systems")
        #expect(company.industry == "IT")
        #expect(company.jobType == "iOS Engineer")
        #expect(company.memo == "user-first culture")
        #expect(company.createdAt == now)
        #expect(company.updatedAt == now)
    }

    @Test
    func appliesDraftToExistingCompany() {
        let company = Company(name: "Old Name", memo: "old")
        var draft = CompanyDraft()
        draft.name = "New Name"
        draft.priority = 4
        draft.selectionStatus = .interviewScheduled
        let updatedAt = Date(timeIntervalSince1970: 1_800_000_000)

        CompanyEditor().apply(draft, to: company, now: updatedAt)

        #expect(company.name == "New Name")
        #expect(company.priority == 4)
        #expect(company.selectionStatus == .interviewScheduled)
        #expect(company.updatedAt == updatedAt)
    }
}
