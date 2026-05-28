import SwiftUI

struct ReverseQuestionFormView: View {
    let title: String
    let companies: [Company]
    @Binding var draft: ReverseQuestionDraft
    let errorMessage: String?
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    Picker("紐付け企業", selection: $draft.companyID) {
                        Text("汎用ストック").tag(nil as UUID?)

                        ForEach(companies) { company in
                            Text(company.name).tag(company.id as UUID?)
                        }
                    }

                    Picker("使うフェーズ", selection: $draft.phase) {
                        ForEach(InterviewPhase.allCases, id: \.self) { phase in
                            Text(phase.label).tag(phase)
                        }
                    }
                }

                Section("逆質問") {
                    TextField("質問文", text: $draft.question, axis: .vertical)
                        .lineLimit(3 ... 5)
                    TextField("この質問で確認したいこと", text: $draft.intent, axis: .vertical)
                        .lineLimit(2 ... 4)
                }

                Section("メモ") {
                    TextField("返答メモ", text: $draft.answerMemo, axis: .vertical)
                        .lineLimit(3 ... 5)
                    TextField("次に深掘りしたいこと", text: $draft.nextDeepDive, axis: .vertical)
                        .lineLimit(2 ... 4)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("閉じる") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存", action: onSave)
                        .disabled(draft.trimmedQuestion.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ReverseQuestionFormView(
        title: "逆質問追加",
        companies: [Company(name: "Atlas Systems")],
        draft: .constant(ReverseQuestionDraft()),
        errorMessage: nil,
        onSave: {}
    )
}
