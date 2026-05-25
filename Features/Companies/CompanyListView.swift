import SwiftUI

struct CompanyListView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("企業カード") {
                    Text("ここから企業一覧を実装します")
                    Text("次のコミットで CRUD を切り出します")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("企業")
        }
    }
}

#Preview {
    CompanyListView()
}
