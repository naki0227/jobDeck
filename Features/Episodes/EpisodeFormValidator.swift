import Foundation

struct EpisodeFormValidator {
    func validate(_ draft: EpisodeDraft) -> [String] {
        var messages: [String] = []

        if draft.trimmedTitle.isEmpty {
            messages.append("エピソード名は必須です。")
        }

        if draft.trimmedSituation.isEmpty {
            messages.append("状況は最低限書いておきましょう。")
        }

        if draft.trimmedSummary.count > 200 {
            messages.append("面接用一言要約は200文字以内にしてください。")
        }

        return messages
    }
}
