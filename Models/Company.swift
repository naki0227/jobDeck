import Foundation
import SwiftData

enum SelectionStatus: String, Codable, CaseIterable {
    case interested
    case applied
    case interviewScheduled
    case finalInterview
    case offered
    case rejected
    case declined

    var label: String {
        switch self {
        case .interested: "気になる"
        case .applied: "応募済み"
        case .interviewScheduled: "面接予定"
        case .finalInterview: "最終面接"
        case .offered: "内定"
        case .rejected: "不採用"
        case .declined: "辞退"
        }
    }
}

@Model
final class Company {
    var id: UUID
    var name: String
    var industry: String?
    var jobType: String?
    var selectionStatusRawValue: String
    var priority: Int
    var memo: String
    var nextInterviewAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        industry: String? = nil,
        jobType: String? = nil,
        selectionStatus: SelectionStatus = .interested,
        priority: Int = 3,
        memo: String = "",
        nextInterviewAt: Date? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.industry = industry
        self.jobType = jobType
        self.selectionStatusRawValue = selectionStatus.rawValue
        self.priority = priority
        self.memo = memo
        self.nextInterviewAt = nextInterviewAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var selectionStatus: SelectionStatus {
        get { SelectionStatus(rawValue: selectionStatusRawValue) ?? .interested }
        set { selectionStatusRawValue = newValue.rawValue }
    }
}
