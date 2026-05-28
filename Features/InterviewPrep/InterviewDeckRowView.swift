import SwiftUI

struct InterviewDeckRowView: View {
    let interviewDeck: InterviewDeck
    let companyName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(companyName ?? "企業未設定")
                    .font(.headline)
                Spacer()
                Text(interviewDeck.phase.label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(interviewDeck.mainAxis)
                .font(.subheadline)

            HStack {
                Label(interviewDeck.interviewAt.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                Spacer()
                Text("エピソード \(interviewDeck.selectedEpisodes.count)")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
