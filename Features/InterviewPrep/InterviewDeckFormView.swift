import SwiftUI

struct InterviewDeckFormView: View {
    let title: String
    @Binding var draft: InterviewDeckDraft
    let errorMessage: String?
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    DatePicker(
                        "面接日時",
                        selection: $draft.interviewAt,
                        displayedComponents: [.date, .hourAndMinute]
                    )

                    Picker("フェーズ", selection: $draft.phase) {
                        ForEach(InterviewPhase.allCases, id: \.self) { phase in
                            Text(phase.label).tag(phase)
                        }
                    }
                }

                Section("今日伝えること") {
                    TextField("今日伝える軸", text: $draft.mainAxis, axis: .vertical)
                        .lineLimit(2 ... 4)
                    TextField("冒頭の自己紹介メモ", text: $draft.openingSelfIntro, axis: .vertical)
                        .lineLimit(3 ... 6)
                }

                Section("使うカード") {
                    TextField("使うエピソードを改行区切りで記録", text: $draft.selectedEpisodesText, axis: .vertical)
                        .lineLimit(4 ... 8)
                    TextField("逆質問を改行区切りで記録", text: $draft.reverseQuestionsText, axis: .vertical)
                        .lineLimit(4 ... 8)
                }

                Section("注意点") {
                    TextField("注意点を改行区切りで記録", text: $draft.cautionPointsText, axis: .vertical)
                        .lineLimit(3 ... 6)
                    TextField("前回の反省", text: $draft.previousReflection, axis: .vertical)
                        .lineLimit(3 ... 6)
                    TextField("最後のチェックリストを改行区切りで記録", text: $draft.checklistText, axis: .vertical)
                        .lineLimit(3 ... 6)
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
                        .disabled(draft.trimmedMainAxis.isEmpty)
                }
            }
        }
    }
}
