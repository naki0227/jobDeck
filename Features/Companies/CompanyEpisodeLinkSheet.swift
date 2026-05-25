import SwiftUI

struct CompanyEpisodeLinkSheet: View {
    let episodeCandidates: [CompanyEpisodeLinkCandidate]
    let onAdd: (_ episodeID: UUID, _ reasonToUse: String, _ expectedQuestion: String, _ priority: Int) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var selectedEpisodeID: UUID?
    @State private var reasonToUse = ""
    @State private var expectedQuestion = ""
    @State private var priority = 3

    var body: some View {
        NavigationStack {
            Form {
                if episodeCandidates.isEmpty {
                    ContentUnavailableView(
                        "追加できるエピソードがありません",
                        systemImage: "link.badge.plus",
                        description: Text("先にエピソードカードを作ると、ここで企業と結びつけられます。")
                    )
                } else {
                    EpisodeCandidateSection(
                        episodeCandidates: episodeCandidates,
                        selectedEpisodeID: $selectedEpisodeID
                    )

                    Section("使う理由") {
                        TextField("この企業で使いたい理由", text: $reasonToUse, axis: .vertical)
                            .lineLimit(2 ... 4)
                        TextField("想定質問", text: $expectedQuestion, axis: .vertical)
                            .lineLimit(2 ... 4)
                        Stepper(value: $priority, in: 1 ... 5) {
                            Text("優先度 \(priority)")
                        }
                    }
                }
            }
            .navigationTitle("エピソード紐付け")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("閉じる") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("追加") {
                        guard let selectedEpisodeID else { return }
                        onAdd(selectedEpisodeID, reasonToUse, expectedQuestion, priority)
                        dismiss()
                    }
                    .disabled(selectedEpisodeID == nil)
                }
            }
        }
    }
}

private struct EpisodeCandidateSection: View {
    let episodeCandidates: [CompanyEpisodeLinkCandidate]
    @Binding var selectedEpisodeID: UUID?

    var body: some View {
        Section("エピソードを選ぶ") {
            ForEach(episodeCandidates, id: \.id) { (candidate: CompanyEpisodeLinkCandidate) in
                Button {
                    selectedEpisodeID = candidate.id
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(candidate.title)
                                .foregroundStyle(.primary)

                            if !candidate.summary.isEmpty {
                                Text(candidate.summary)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }

                        Spacer()

                        if selectedEpisodeID == candidate.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CompanyEpisodeLinkSheet(
        episodeCandidates: [
            CompanyEpisodeLinkCandidate(
                id: UUID(),
                title: "新人教育の改善",
                summary: "仕組み化で教育の再現性を上げた経験",
                updatedAt: .now
            )
        ],
        onAdd: { _, _, _, _ in }
    )
}
