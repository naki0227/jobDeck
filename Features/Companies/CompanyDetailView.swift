import SwiftUI
import SwiftData

struct CompanyDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \CompanyEpisodeLink.updatedAt, order: .reverse) private var allLinks: [CompanyEpisodeLink]
    @Query(sort: \Episode.updatedAt, order: .reverse) private var allEpisodes: [Episode]
    @Query(sort: \InterviewDeck.interviewAt) private var allInterviewDecks: [InterviewDeck]
    @Query(sort: \InterviewLog.interviewAt, order: .reverse) private var allInterviewLogs: [InterviewLog]

    @Bindable var company: Company

    @State private var draft: CompanyDraft
    @State private var errorMessage: String?
    @State private var showingDeleteAlert = false
    @State private var showingDeckSheet = false
    @State private var showingLinkSheet = false
    @State private var showingInterviewLogSheet = false
    @State private var interviewDeckDraft = InterviewDeckDraft()
    @State private var interviewLogDraft = InterviewLogDraft()

    private let editor = CompanyEditor()
    private let interviewDeckEditor = InterviewDeckEditor()
    private let linkEditor = CompanyEpisodeLinkEditor()
    private let interviewLogEditor = InterviewLogEditor()

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

                Section("面接ログ") {
                    if interviewLogs.isEmpty {
                        Text("まだ面接ログがありません")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(interviewLogs) { interviewLog in
                            NavigationLink {
                                InterviewLogDetailView(companyID: company.id, interviewLog: interviewLog)
                            } label: {
                                InterviewLogRowView(interviewLog: interviewLog)
                            }
                        }
                    }

                    Button {
                        interviewLogDraft = InterviewLogDraft()
                        showingInterviewLogSheet = true
                    } label: {
                        Label("面接ログを追加", systemImage: "plus.bubble")
                    }
                }

                Section("面接前デッキ") {
                    if interviewDecks.isEmpty {
                        Text("まだ面接前デッキがありません")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(interviewDecks) { interviewDeck in
                            NavigationLink {
                                InterviewDeckDetailView(companyID: company.id, interviewDeck: interviewDeck)
                            } label: {
                                InterviewDeckRowView(
                                    interviewDeck: interviewDeck,
                                    companyName: company.name
                                )
                            }
                        }
                    }

                    Button {
                        interviewDeckDraft = InterviewDeckDraft()
                        showingDeckSheet = true
                    } label: {
                        Label("面接前デッキを追加", systemImage: "rectangle.stack.badge.plus")
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
        .sheet(isPresented: $showingDeckSheet) {
            InterviewDeckFormView(
                title: "面接前デッキ追加",
                draft: $interviewDeckDraft,
                errorMessage: errorMessage,
                onSave: createInterviewDeck
            )
        }
        .sheet(isPresented: $showingInterviewLogSheet) {
            InterviewLogFormView(
                title: "面接ログ追加",
                draft: $interviewLogDraft,
                errorMessage: errorMessage,
                onSave: createInterviewLog
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

    private var interviewLogs: [InterviewLog] {
        allInterviewLogs.filter { $0.companyID == company.id }
    }

    private var interviewDecks: [InterviewDeck] {
        allInterviewDecks.filter { $0.companyID == company.id }
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
            for interviewLog in interviewLogs {
                modelContext.delete(interviewLog)
            }
            for interviewDeck in interviewDecks {
                modelContext.delete(interviewDeck)
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

    private func createInterviewLog() {
        do {
            _ = try interviewLogEditor.save(
                companyID: company.id,
                draft: interviewLogDraft,
                in: modelContext
            )
            showingInterviewLogSheet = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func createInterviewDeck() {
        do {
            _ = try interviewDeckEditor.save(
                companyID: company.id,
                draft: interviewDeckDraft,
                in: modelContext
            )
            showingDeckSheet = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
