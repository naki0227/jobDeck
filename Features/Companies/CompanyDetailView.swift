import SwiftUI
import SwiftData

struct CompanyDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \CompanyEpisodeLink.updatedAt, order: .reverse) private var allLinks: [CompanyEpisodeLink]
    @Query(sort: \Episode.updatedAt, order: .reverse) private var allEpisodes: [Episode]

    @Bindable var company: Company

    @State private var draft: CompanyDraft
    @State private var errorMessage: String?
    @State private var showingDeleteAlert = false
    @State private var showingLinkSheet = false

    private let editor = CompanyEditor()
    private let linkEditor = CompanyEpisodeLinkEditor()

    init(company: Company) {
        self.company = company
        _draft = State(initialValue: CompanyDraft(company: company))
    }

    var body: some View {
        CompanyFormView(
            title: "企業詳細",
            draft: $draft,
            errorMessage: errorMessage,
            onSave: save,
            extraContent: {
                Section("紐付けエピソード") {
                    if linkedEpisodes.isEmpty {
                        Text("まだ紐付けがありません")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(linkedEpisodes, id: \.link.id) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(item.episode.title)
                                        .font(.headline)
                                    Spacer()
                                    Text("優先度 \(item.link.priority)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                if !item.link.reasonToUse.isEmpty {
                                    Text(item.link.reasonToUse)
                                        .font(.subheadline)
                                }

                                if !item.link.expectedQuestion.isEmpty {
                                    Text("想定質問: \(item.link.expectedQuestion)")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteLink(item.link)
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }
                    }

                    Button {
                        showingLinkSheet = true
                    } label: {
                        Label("エピソードを紐付ける", systemImage: "link.badge.plus")
                    }
                }
            }
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
        .alert("この企業カードを削除しますか？", isPresented: $showingDeleteAlert) {
            Button("削除", role: .destructive, action: deleteCompany)
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("企業メモや面接予定の内容も一覧から見えなくなります。")
        }
        .sheet(isPresented: $showingLinkSheet) {
            CompanyEpisodeLinkSheet(
                episodeCandidates: availableEpisodeCandidates,
                onAdd: addLink
            )
        }
    }

    private var companyLinks: [CompanyEpisodeLink] {
        allLinks.filter { $0.companyID == company.id }
    }

    private var linkedEpisodes: [(link: CompanyEpisodeLink, episode: Episode)] {
        companyLinks.compactMap { link in
            guard let episode = allEpisodes.first(where: { $0.id == link.episodeID }) else {
                return nil
            }
            return (link, episode)
        }
    }

    private var availableEpisodeCandidates: [CompanyEpisodeLinkCandidate] {
        CompanyEpisodeLinkBuilder().availableEpisodes(
            allEpisodes: allEpisodes,
            existingLinks: companyLinks
        )
    }

    private func save() {
        do {
            _ = try editor.save(
                draft: draft,
                existingCompany: company,
                in: modelContext
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteCompany() {
        do {
            for link in companyLinks {
                modelContext.delete(link)
            }
            modelContext.delete(company)
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "削除に失敗しました。少し時間をおいて再度お試しください。"
        }
    }

    private func addLink(
        episodeID: UUID,
        reasonToUse: String,
        expectedQuestion: String,
        priority: Int
    ) {
        do {
            _ = try linkEditor.save(
                companyID: company.id,
                episodeID: episodeID,
                reasonToUse: reasonToUse,
                expectedQuestion: expectedQuestion,
                priority: priority,
                in: modelContext
            )
        } catch {
            errorMessage = "紐付けの保存に失敗しました。"
        }
    }

    private func deleteLink(_ link: CompanyEpisodeLink) {
        do {
            modelContext.delete(link)
            try modelContext.save()
        } catch {
            errorMessage = "紐付けの削除に失敗しました。"
        }
    }
}
