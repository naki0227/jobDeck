import SwiftUI

struct CompanyMetricsHeaderView: View {
    let metrics: CompanyListMetrics

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("準備状況")
                .font(.headline)

            HStack(spacing: 12) {
                metricCard(title: "選考中", value: "\(metrics.activeCompaniesCount)")
                metricCard(title: "面接予定", value: "\(metrics.interviewScheduledCount)")
                metricCard(title: "志望度高", value: "\(metrics.highPriorityCount)")
            }
        }
        .padding(.vertical, 8)
    }

    private func metricCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    CompanyMetricsHeaderView(
        metrics: CompanyListMetrics(
            activeCompaniesCount: 4,
            interviewScheduledCount: 2,
            highPriorityCount: 3
        )
    )
    .padding()
}
