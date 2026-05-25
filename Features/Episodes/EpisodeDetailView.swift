import SwiftData
import SwiftUI

struct EpisodeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \CompanyEpisodeLink.updatedAt, order: .reverse) private var allLinks: [CompanyEpisodeLink]

    @Bindable var episode: Episode

    @State private var draft: EpisodeDraft
    @State private var errorMessage: String?
    @State private var showingDeleteAlert = false

    private let editor = EpisodeEditor()

    init(episode: Episode) {
        self.episode = episode
        _draft = State(initialValue: EpisodeDraft(episode: episode))
    }

    var body: some View {
        EpisodeFormView(
            title: "エピソード詳細",
            draft: $draft,
            errorMessage: errorMessage,
            onSave: save
        )
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("削除", systemImage: "trash")
                }
            }
        }
        .alert("このエピソードを削除しますか？", isPresented: $showingDeleteAlert) {
            Button("削除", role: .destructive, action: deleteEpisode)
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("面接準備で使うメモも一覧から見えなくなります。")
        }
    }

    private func save() {
        do {
            _ = try editor.save(draft: draft, existingEpisode: episode, in: modelContext)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteEpisode() {
        do {
            for link in episodeLinks {
                modelContext.delete(link)
            }
            modelContext.delete(episode)
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "削除に失敗しました。少し時間をおいて再度お試しください。"
        }
    }

    private var episodeLinks: [CompanyEpisodeLink] {
        allLinks.filter { $0.episodeID == episode.id }
    }
}
