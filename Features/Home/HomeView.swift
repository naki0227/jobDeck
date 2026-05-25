import SwiftUI

struct HomeView: View {
    let viewModel: HomeViewModel

    private static let interviewFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter
    }()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("今やるべき準備")
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)

                    SummaryCardView(
                        title: "次の面接",
                        value: viewModel.snapshot.nextInterviewCompanyName ?? "未設定",
                        caption: nextInterviewCaption
                    )

                    SummaryCardView(
                        title: "未作成デッキ",
                        value: "\(viewModel.snapshot.companiesNeedingDeckCount)社",
                        caption: "面接前10分デッキが必要です"
                    )

                    SummaryCardView(
                        title: "AIクレジット",
                        value: "\(viewModel.snapshot.remainingAICredits)",
                        caption: "今月の残数"
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        Text("最近更新した企業")
                            .font(.headline)

                        ForEach(viewModel.snapshot.recentCompanyNames, id: \.self) { companyName in
                            Text(companyName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color(.separator), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("ホーム")
        }
    }

    private var nextInterviewCaption: String {
        guard let date = viewModel.snapshot.nextInterviewDate else {
            return "次回面接を登録すると表示されます"
        }

        return Self.interviewFormatter.localizedString(for: date, relativeTo: .now)
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel())
}
