import SwiftUI

struct InterviewLogRowView: View {
    let interviewLog: InterviewLog

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(interviewLog.phase.label)
                    .font(.headline)
                Spacer()
                Text(interviewLog.interviewAt, format: .dateTime.month().day().hour().minute())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let firstQuestion = interviewLog.askedQuestions.first {
                Text(firstQuestion)
                    .font(.subheadline)
                    .lineLimit(2)
            }

            Text("質問 \(interviewLog.askedQuestions.count) 件")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
