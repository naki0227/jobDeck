import SwiftUI

struct ReverseQuestionRowView: View {
    let reverseQuestion: ReverseQuestion
    let companyName: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(reverseQuestion.question)
                .font(.headline)

            HStack(spacing: 8) {
                Text(reverseQuestion.phase.label)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let companyName, !companyName.isEmpty {
                    Text(companyName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("汎用ストック")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !reverseQuestion.intent.isEmpty {
                Text(reverseQuestion.intent)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}
