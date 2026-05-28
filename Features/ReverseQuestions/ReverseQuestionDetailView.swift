import SwiftData
import SwiftUI

struct ReverseQuestionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Company.updatedAt, order: .reverse) private var companies: [Company]

    @Bindable var reverseQuestion: ReverseQuestion

    @State private var draft: ReverseQuestionDraft
    @State private var errorMessage: String?
    @State private var showingDeleteAlert = false

    private let editor = ReverseQuestionEditor()

    init(reverseQuestion: ReverseQuestion) {
        self.reverseQuestion = reverseQuestion
        _draft = State(initialValue: ReverseQuestionDraft(reverseQuestion: reverseQuestion))
    }

    var body: some View {
        ReverseQuestionFormView(
            title: "逆質問詳細",
            companies: companies,
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
        .alert("この逆質問カードを削除しますか？", isPresented: $showingDeleteAlert) {
            Button("削除", role: .destructive, action: deleteReverseQuestion)
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("面接で確認したい内容のメモも一覧から見えなくなります。")
        }
    }

    private func save() {
        do {
            _ = try editor.save(
                draft: draft,
                existingReverseQuestion: reverseQuestion,
                in: modelContext
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteReverseQuestion() {
        do {
            modelContext.delete(reverseQuestion)
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "削除に失敗しました。少し時間をおいて再度お試しください。"
        }
    }
}
