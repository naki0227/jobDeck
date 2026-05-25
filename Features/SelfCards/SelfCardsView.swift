import SwiftUI

struct SelfCardsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("自分カード") {
                    Label("価値観", systemImage: "heart.text.square")
                    Label("強み", systemImage: "bolt.badge.checkmark")
                    Label("エピソード", systemImage: "text.quote")
                }
            }
            .navigationTitle("自分カード")
        }
    }
}

#Preview {
    SelfCardsView()
}
