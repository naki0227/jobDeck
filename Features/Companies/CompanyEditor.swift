import Foundation
import SwiftData

struct CompanyEditor {
    func createCompany(from draft: CompanyDraft, now: Date = .now) -> Company {
        Company(
            name: draft.trimmedName,
            industry: draft.trimmedIndustry,
            jobType: draft.trimmedJobType,
            selectionStatus: draft.selectionStatus,
            priority: draft.priority,
            memo: draft.trimmedMemo,
            nextInterviewAt: draft.nextInterviewAt,
            createdAt: now,
            updatedAt: now
        )
    }

    func apply(_ draft: CompanyDraft, to company: Company, now: Date = .now) {
        company.name = draft.trimmedName
        company.industry = draft.trimmedIndustry
        company.jobType = draft.trimmedJobType
        company.selectionStatus = draft.selectionStatus
        company.priority = draft.priority
        company.memo = draft.trimmedMemo
        company.nextInterviewAt = draft.nextInterviewAt
        company.updatedAt = now
    }

    func save(
        draft: CompanyDraft,
        existingCompany: Company? = nil,
        in modelContext: ModelContext,
        now: Date = .now
    ) throws -> Company {
        let validator = CompanyFormValidator()
        let errors = validator.validate(draft)
        if let firstError = errors.first {
            throw CompanyFormError.validation(firstError)
        }

        if let existingCompany {
            apply(draft, to: existingCompany, now: now)
            try modelContext.save()
            return existingCompany
        }

        let company = createCompany(from: draft, now: now)
        modelContext.insert(company)
        try modelContext.save()
        return company
    }
}

enum CompanyFormError: LocalizedError {
    case validation(String)

    var errorDescription: String? {
        switch self {
        case let .validation(message):
            message
        }
    }
}
