import Foundation

struct ReverseQuestionFormValidator {
    func validate(_ draft: ReverseQuestionDraft) -> [String] {
        var messages: [String] = []

        if draft.trimmedQuestion.isEmpty {
            messages.append("逆質問は必須です。")
        }

        if draft.trimmedQuestion.count > 200 {
            messages.append("逆質問は200文字以内にしてください。")
        }

        if draft.trimmedIntent.count > 120 {
            messages.append("意図メモは120文字以内にしてください。")
        }

        return messages
    }
}
