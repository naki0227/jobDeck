import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("設定") {
                    Text("AI利用状況")
                    Text("通知")
                    Text("プライバシー")
                }
            }
            .navigationTitle("設定")
        }
    }
}

#Preview {
    SettingsView()
}
