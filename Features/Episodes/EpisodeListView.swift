import SwiftData
import SwiftUI

struct EpisodeListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Episode.updatedAt, order: .reverse) private var episodes: [Episode]

    @State private var showingCreateSheet = false
    @State private var draft = EpisodeDraft()
    @State private var errorMessage: String?

    private let editor = EpisodeEditor()

    var body: some View {
        List {
            if episodes.isEmpty {
                Section {
                    ContentUnavailableView(
                        "エピソードカードがまだありません",
                        systemImage: "text.quote",
                        description: Text("面接で話せる経験を1つずつカードにしていきましょう。")
                    )
                }
            } else {
                Section("エピソードカード") {
                    ForEach(episodes) { episode in
                        NavigationLink {
                            EpisodeDetailView(episode: episode)
                        } label: {
                            EpisodeRowView(episode: episode)
                        }
                    }
                }
            }
        }
        .navigationTitle("エピソード")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    draft = EpisodeDraft()
                    errorMessage = nil
                    showingCreateSheet = true
                } label: {
                    Label("追加", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateSheet) {
            EpisodeFormView(
                title: "エピソード追加",
                draft: $draft,
                errorMessage: errorMessage,
                onSave: createEpisode
            )
        }
    }

    private func createEpisode() {
        do {
            _ = try editor.save(draft: draft, in: modelContext)
            showingCreateSheet = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        EpisodeListView()
    }
    .modelContainer(for: [Episode.self], inMemory: true)
}
