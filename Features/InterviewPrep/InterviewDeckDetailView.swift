import SwiftData
import SwiftUI

struct InterviewDeckDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let companyID: UUID

    @Bindable var interviewDeck: InterviewDeck

    @State private var draft: InterviewDeckDraft
    @State private var errorMessage: String?
    @State private var showingDeleteAlert = false

    private let editor = InterviewDeckEditor()

    init(companyID: UUID, interviewDeck: InterviewDeck) {
        self.companyID = companyID
        self.interviewDeck = interviewDeck
        _draft = State(initialValue: InterviewDeckDraft(interviewDeck: interviewDeck))
    }

    var body: some View {
        InterviewDeckFormView(
            title: "面接前デッキ詳細",
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
        .alert("この面接前デッキを削除しますか？", isPresented: $showingDeleteAlert) {
            Button("削除", role: .destructive, action: deleteInterviewDeck)
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("直前に見返す内容も一覧から見えなくなります。")
        }
    }

    private func save() {
        do {
            _ = try editor.save(
                companyID: companyID,
                draft: draft,
                existingInterviewDeck: interviewDeck,
                in: modelContext
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteInterviewDeck() {
        do {
            modelContext.delete(interviewDeck)
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "削除に失敗しました。少し時間をおいて再度お試しください。"
        }
    }
}
