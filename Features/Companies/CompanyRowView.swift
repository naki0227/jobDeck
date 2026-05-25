import SwiftUI

struct CompanyRowView: View {
    let company: Company

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(company.name)
                    .font(.headline)
                Spacer()
                Text(company.selectionStatus.label)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            HStack(spacing: 12) {
                if let industry = company.industry, !industry.isEmpty {
                    Label(industry, systemImage: "building.2.crop.circle")
                }

                if let jobType = company.jobType, !jobType.isEmpty {
                    Label(jobType, systemImage: "briefcase")
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            HStack {
                Text("志望度 \(company.priority)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Spacer()

                if let nextInterviewAt = company.nextInterviewAt {
                    Text(Self.formatter.string(from: nextInterviewAt))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        CompanyRowView(
            company: Company(
                name: "Atlas Systems",
                industry: "IT",
                jobType: "iOS Engineer",
                selectionStatus: .interviewScheduled,
                priority: 5,
                memo: "Preview"
            )
        )
    }
}
