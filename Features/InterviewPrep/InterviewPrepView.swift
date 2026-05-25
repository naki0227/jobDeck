import SwiftUI

struct InterviewPrepView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("面接前10分") {
                    Text("ここに今日の企業、使うエピソード、逆質問を集約します")
                }
            }
            .navigationTitle("面接前")
        }
    }
}

#Preview {
    InterviewPrepView()
}
