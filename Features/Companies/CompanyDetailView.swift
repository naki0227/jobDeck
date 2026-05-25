import SwiftUI

struct CompanyDetailView: View {
    let company: Company

    var body: some View {
        List {
            Text(company.name)
            Text("詳細編集は次のコミットで追加します")
                .foregroundStyle(.secondary)
        }
        .navigationTitle("企業詳細")
    }
}
