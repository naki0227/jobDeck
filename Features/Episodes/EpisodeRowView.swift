import SwiftUI

struct EpisodeRowView: View {
    let episode: Episode

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.title)
                .font(.headline)

            if !episode.summaryForInterview.isEmpty {
                Text(episode.summaryForInterview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Text(episode.updatedAt.formatted(date: .abbreviated, time: .omitted))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        EpisodeRowView(
            episode: Episode(
                title: "新人教育の改善",
                situation: "引き継ぎが属人的だった",
                action: "チェックリスト化した",
                result: "教育時間が短縮した",
                learning: "仕組み化の大切さを学んだ",
                summaryForInterview: "相手目線で仕組みを整えた経験"
            )
        )
    }
}
