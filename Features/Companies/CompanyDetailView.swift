import SwiftUI
import SwiftData

struct CompanyDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var company: Company

    @State private var draft: CompanyDraft
    @State private var errorMessage: String?
    @State private var showingDeleteAlert = false

    private let editor = CompanyEditor()

    init(company: Company) {
        self.company = company
        _draft = State(initialValue: CompanyDraft(company: company))
    }

    var body: some View {
        CompanyFormView(
            title: "企業詳細",
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
        .alert("この企業カードを削除しますか？", isPresented: $showingDeleteAlert) {
            Button("削除", role: .destructive, action: deleteCompany)
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("企業メモや面接予定の内容も一覧から見えなくなります。")
        }
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
        modelContext.delete(company)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = "削除に失敗しました。少し時間をおいて再度お試しください。"
        }
    }
}
