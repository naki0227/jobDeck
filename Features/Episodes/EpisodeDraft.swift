import Foundation

struct EpisodeDraft: Equatable {
    var title: String = ""
    var situation: String = ""
    var action: String = ""
    var result: String = ""
    var learning: String = ""
    var summaryForInterview: String = ""

    init() {}

    init(episode: Episode) {
        title = episode.title
        situation = episode.situation
        action = episode.action
        result = episode.result
        learning = episode.learning
        summaryForInterview = episode.summaryForInterview
    }

    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedSituation: String {
        situation.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedAction: String {
        action.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedResult: String {
        result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedLearning: String {
        learning.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedSummary: String {
        summaryForInterview.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
