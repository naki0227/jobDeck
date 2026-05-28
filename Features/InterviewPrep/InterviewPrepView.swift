import SwiftData
import SwiftUI

struct InterviewPrepView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \InterviewDeck.interviewAt) private var interviewDecks: [InterviewDeck]
    @Query(sort: \Company.updatedAt, order: .reverse) private var companies: [Company]

    @State private var showingCreateSheet = false
    @State private var selectedCompanyID: UUID?
    @State private var draft = InterviewDeckDraft()
    @State private var errorMessage: String?

    private let editor = InterviewDeckEditor()

    var body: some View {
        NavigationStack {
            List {
                if interviewDecks.isEmpty {
                    Section {
                        ContentUnavailableView(
                            "面接前デッキがまだありません",
                            systemImage: "rectangle.stack",
                            description: Text("企業ごとに話す軸や使うエピソードをまとめておくと、面接直前の見返しがかなり楽になります。")
                        )
                    }
                } else {
                    Section("面接前10分デッキ") {
                        ForEach(interviewDecks) { interviewDeck in
                            NavigationLink {
                                InterviewDeckDetailView(
                                    companyID: interviewDeck.companyID,
                                    interviewDeck: interviewDeck
                                )
                            } label: {
                                InterviewDeckRowView(
                                    interviewDeck: interviewDeck,
                                    companyName: companyName(for: interviewDeck.companyID)
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("面接前")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        draft = InterviewDeckDraft()
                        errorMessage = nil
                        selectedCompanyID = companies.first?.id
                        showingCreateSheet = true
                    } label: {
                        Label("追加", systemImage: "plus")
                    }
                    .disabled(companies.isEmpty)
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                NavigationStack {
                    Form {
                        Section("企業") {
                            if companies.isEmpty {
                                Text("先に企業カードを作成してください")
                                    .foregroundStyle(.secondary)
                            } else {
                                Picker("企業", selection: $selectedCompanyID) {
                                    ForEach(companies) { company in
                                        Text(company.name).tag(Optional(company.id))
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("企業を選ぶ")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("閉じる") {
                                showingCreateSheet = false
                            }
                        }

                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink("次へ") {
                                InterviewDeckFormView(
                                    title: "面接前デッキ追加",
                                    draft: $draft,
                                    errorMessage: errorMessage,
                                    onSave: createInterviewDeck
                                )
                            }
                            .disabled(selectedCompanyID == nil)
                        }
                    }
                }
            }
        }
    }

    private func companyName(for companyID: UUID) -> String? {
        companies.first(where: { $0.id == companyID })?.name
    }

    private func createInterviewDeck() {
        guard let selectedCompanyID else { return }

        do {
            _ = try editor.save(
                companyID: selectedCompanyID,
                draft: draft,
                in: modelContext
            )
            showingCreateSheet = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    InterviewPrepView()
        .modelContainer(for: [Company.self, InterviewDeck.self], inMemory: true)
}
