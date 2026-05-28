import SwiftData
import SwiftUI

struct ReverseQuestionListView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \ReverseQuestion.updatedAt, order: .reverse) private var reverseQuestions: [ReverseQuestion]
    @Query(sort: \Company.updatedAt, order: .reverse) private var companies: [Company]

    @State private var showingCreateSheet = false
    @State private var draft = ReverseQuestionDraft()
    @State private var errorMessage: String?

    private let editor = ReverseQuestionEditor()

    var body: some View {
        List {
            if reverseQuestions.isEmpty {
                Section {
                    ContentUnavailableView(
                        "逆質問カードがまだありません",
                        systemImage: "questionmark.bubble",
                        description: Text("企業ごとに確認したいことを先にストックしておくと、面接直前に迷いにくくなります。")
                    )
                }
            } else {
                Section("逆質問カード") {
                    ForEach(reverseQuestions) { reverseQuestion in
                        NavigationLink {
                            ReverseQuestionDetailView(reverseQuestion: reverseQuestion)
                        } label: {
                            ReverseQuestionRowView(
                                reverseQuestion: reverseQuestion,
                                companyName: companyName(for: reverseQuestion.companyID)
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("逆質問")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    draft = ReverseQuestionDraft()
                    errorMessage = nil
                    showingCreateSheet = true
                } label: {
                    Label("追加", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateSheet) {
            ReverseQuestionFormView(
                title: "逆質問追加",
                companies: companies,
                draft: $draft,
                errorMessage: errorMessage,
                onSave: createReverseQuestion
            )
        }
    }

    private func companyName(for companyID: UUID?) -> String? {
        guard let companyID else { return nil }
        return companies.first(where: { $0.id == companyID })?.name
    }

    private func createReverseQuestion() {
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
        ReverseQuestionListView()
    }
    .modelContainer(for: [Company.self, ReverseQuestion.self], inMemory: true)
}
