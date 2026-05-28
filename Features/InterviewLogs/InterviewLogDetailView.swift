import SwiftData
import SwiftUI

struct InterviewLogDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let companyID: UUID

    @Bindable var interviewLog: InterviewLog

    @State private var draft: InterviewLogDraft
    @State private var errorMessage: String?
    @State private var showingDeleteAlert = false

    private let editor = InterviewLogEditor()

    init(companyID: UUID, interviewLog: InterviewLog) {
        self.companyID = companyID
        self.interviewLog = interviewLog
        _draft = State(initialValue: InterviewLogDraft(interviewLog: interviewLog))
    }

    var body: some View {
        InterviewLogFormView(
            title: "面接ログ詳細",
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
        .alert("この面接ログを削除しますか？", isPresented: $showingDeleteAlert) {
            Button("削除", role: .destructive, action: deleteInterviewLog)
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("振り返り内容も一覧から見えなくなります。")
        }
    }

    private func save() {
        do {
            _ = try editor.save(
                companyID: companyID,
                draft: draft,
                existingInterviewLog: interviewLog,
                in: modelContext
            )
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteInterviewLog() {
        do {
            modelContext.delete(interviewLog)
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "削除に失敗しました。少し時間をおいて再度お試しください。"
        }
    }
}
