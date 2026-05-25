import Foundation
import SwiftData

@Model
final class Episode {
    var id: UUID
    var title: String
    var situation: String
    var action: String
    var result: String
    var learning: String
    var summaryForInterview: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        situation: String = "",
        action: String = "",
        result: String = "",
        learning: String = "",
        summaryForInterview: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.situation = situation
        self.action = action
        self.result = result
        self.learning = learning
        self.summaryForInterview = summaryForInterview
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
