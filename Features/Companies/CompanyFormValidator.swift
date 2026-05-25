import Foundation

struct CompanyFormValidator {
    func validate(_ draft: CompanyDraft) -> [String] {
        var messages: [String] = []

        if draft.trimmedName.isEmpty {
            messages.append("企業名は必須です。")
        }

        if draft.priority < 1 || draft.priority > 5 {
            messages.append("志望度は1から5で設定してください。")
        }

        if draft.trimmedMemo.count > 1_000 {
            messages.append("メモは1000文字以内にしてください。")
        }

        return messages
    }
}
