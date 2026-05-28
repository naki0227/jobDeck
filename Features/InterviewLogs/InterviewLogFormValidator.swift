import Foundation

struct InterviewLogFormValidator {
    func validate(_ draft: InterviewLogDraft) -> [String] {
        var messages: [String] = []

        if draft.trimmedAskedQuestionsText.isEmpty {
            messages.append("聞かれた質問は最低1つ残しておきましょう。")
        }

        if draft.trimmedLearnedInfo.isEmpty {
            messages.append("面接で得た情報は最低限残しておきましょう。")
        }

        if draft.trimmedNextImprovement.isEmpty {
            messages.append("次回への改善点を1つ書いておきましょう。")
        }

        return messages
    }
}
