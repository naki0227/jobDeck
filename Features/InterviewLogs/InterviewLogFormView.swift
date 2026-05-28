import SwiftUI

struct InterviewLogFormView: View {
    let title: String
    @Binding var draft: InterviewLogDraft
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

                Section("聞かれたこと") {
                    TextField("聞かれた質問を改行区切りで記録", text: $draft.askedQuestionsText, axis: .vertical)
                        .lineLimit(4 ... 8)
                    TextField("自分の回答メモ", text: $draft.myAnswersMemo, axis: .vertical)
                        .lineLimit(4 ... 8)
                    TextField("詰まったポイント", text: $draft.stuckPoints, axis: .vertical)
                        .lineLimit(3 ... 6)
                    TextField("面接官の反応", text: $draft.interviewerReaction, axis: .vertical)
                        .lineLimit(3 ... 6)
                }

                Section("逆質問と学び") {
                    TextField("実際に聞いた逆質問を改行区切りで記録", text: $draft.reverseQuestionsAskedText, axis: .vertical)
                        .lineLimit(3 ... 6)
                    TextField("得られた情報", text: $draft.learnedInfo, axis: .vertical)
                        .lineLimit(4 ... 8)
                    TextField("次回の改善点", text: $draft.nextImprovement, axis: .vertical)
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
                        .disabled(draft.trimmedAskedQuestionsText.isEmpty)
                }
            }
        }
    }
}
