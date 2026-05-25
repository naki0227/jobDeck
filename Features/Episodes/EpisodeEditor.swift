import Foundation
import SwiftData

struct EpisodeEditor {
    func createEpisode(from draft: EpisodeDraft, now: Date = .now) -> Episode {
        Episode(
            title: draft.trimmedTitle,
            situation: draft.trimmedSituation,
            action: draft.trimmedAction,
            result: draft.trimmedResult,
            learning: draft.trimmedLearning,
            summaryForInterview: draft.trimmedSummary,
            createdAt: now,
            updatedAt: now
        )
    }

    func apply(_ draft: EpisodeDraft, to episode: Episode, now: Date = .now) {
        episode.title = draft.trimmedTitle
        episode.situation = draft.trimmedSituation
        episode.action = draft.trimmedAction
        episode.result = draft.trimmedResult
        episode.learning = draft.trimmedLearning
        episode.summaryForInterview = draft.trimmedSummary
        episode.updatedAt = now
    }

    func save(
        draft: EpisodeDraft,
        existingEpisode: Episode? = nil,
        in modelContext: ModelContext,
        now: Date = .now
    ) throws -> Episode {
        let validator = EpisodeFormValidator()
        let errors = validator.validate(draft)
        if let firstError = errors.first {
            throw EpisodeFormError.validation(firstError)
        }

        if let existingEpisode {
            apply(draft, to: existingEpisode, now: now)
            try modelContext.save()
            return existingEpisode
        }

        let episode = createEpisode(from: draft, now: now)
        modelContext.insert(episode)
        try modelContext.save()
        return episode
    }
}

enum EpisodeFormError: LocalizedError {
    case validation(String)

    var errorDescription: String? {
        switch self {
        case let .validation(message):
            return message
        }
    }
}
