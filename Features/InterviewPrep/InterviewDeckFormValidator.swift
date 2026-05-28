import Foundation

struct InterviewDeckFormValidator {
    func validate(_ draft: InterviewDeckDraft) -> [String] {
        var messages: [String] = []

        if draft.trimmedMainAxis.isEmpty {
            messages.append("今日伝える軸を1つ書いておきましょう。")
        }

        if draft.trimmedSelectedEpisodesText.isEmpty {
            messages.append("使うエピソードを最低1つ残しておきましょう。")
        }

        if draft.trimmedReverseQuestionsText.isEmpty {
            messages.append("逆質問を最低1つ入れておきましょう。")
        }

        if draft.trimmedChecklistText.isEmpty {
            messages.append("最後のチェックリストを最低1つ入れておきましょう。")
        }

        return messages
    }
}
