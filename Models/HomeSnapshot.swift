import Foundation

struct HomeSnapshot: Equatable {
    let nextInterviewCompanyName: String?
    let nextInterviewDate: Date?
    let companiesNeedingDeckCount: Int
    let recentCompanyNames: [String]
    let remainingAICredits: Int
}
