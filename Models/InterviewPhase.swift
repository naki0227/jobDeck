import Foundation

enum InterviewPhase: String, Codable, CaseIterable {
    case casual
    case firstInterview
    case secondInterview
    case finalInterview
    case offerMeeting
    case other

    var label: String {
        switch self {
        case .casual: "カジュアル面談"
        case .firstInterview: "一次面接"
        case .secondInterview: "二次面接"
        case .finalInterview: "最終面接"
        case .offerMeeting: "面談・オファー"
        case .other: "その他"
        }
    }
}
