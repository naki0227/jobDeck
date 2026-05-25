import SwiftUI

struct EpisodeFormView: View {
    let title: String
    @Binding var draft: EpisodeDraft
    let errorMessage: String?
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("基本") {
                    TextField("エピソード名", text: $draft.title)
                    TextField("面接用一言要約", text: $draft.summaryForInterview, axis: .vertical)
                        .lineLimit(2 ... 4)
                }

                Section("状況") {
                    TextField("何が起きていたか", text: $draft.situation, axis: .vertical)
                        .lineLimit(3 ... 6)
                }

                Section("行動") {
                    TextField("自分がしたこと", text: $draft.action, axis: .vertical)
                        .lineLimit(3 ... 6)
                }

                Section("結果と学び") {
                    TextField("結果", text: $draft.result, axis: .vertical)
                        .lineLimit(2 ... 4)
                    TextField("学び", text: $draft.learning, axis: .vertical)
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
                        .disabled(draft.trimmedTitle.isEmpty)
                }
            }
        }
    }
}

#Preview {
    EpisodeFormView(
        title: "エピソード追加",
        draft: .constant(EpisodeDraft()),
        errorMessage: nil,
        onSave: {}
    )
}
