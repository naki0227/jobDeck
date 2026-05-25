import SwiftUI
import SwiftData

struct CompanyListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Company.updatedAt, order: .reverse) private var companies: [Company]

    @State private var showingCreateSheet = false
    @State private var draft = CompanyDraft()
    @State private var errorMessage: String?

    private let editor = CompanyEditor()

    var body: some View {
        NavigationStack {
            List {
                if companies.isEmpty {
                    Section {
                        ContentUnavailableView(
                            "企業カードがまだありません",
                            systemImage: "building.2.crop.circle",
                            description: Text("まずは1社追加して、企業ごとの面接準備をためていきましょう。")
                        )
                    }
                } else {
                    Section("企業カード") {
                        ForEach(companies) { company in
                            NavigationLink {
                                CompanyDetailView(company: company)
                            } label: {
                                CompanyRowView(company: company)
                            }
                        }
                    }
                }
            }
            .navigationTitle("企業")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        draft = CompanyDraft()
                        errorMessage = nil
                        showingCreateSheet = true
                    } label: {
                        Label("追加", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                CompanyFormView(
                    title: "企業追加",
                    draft: $draft,
                    errorMessage: errorMessage,
                    onSave: createCompany
                )
            }
        }
    }

    private func createCompany() {
        do {
            _ = try editor.save(draft: draft, in: modelContext)
            showingCreateSheet = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    CompanyListView()
        .modelContainer(for: [Company.self], inMemory: true)
}
