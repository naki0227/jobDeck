import Foundation
import Testing

@testable import JobDeck

struct EpisodeEditorTests {
    @Test
    func trimsFieldsWhenCreatingEpisode() {
        var draft = EpisodeDraft()
        draft.title = "  新人教育の改善  "
        draft.situation = "  引き継ぎが属人化していた  "
        draft.action = "  チェックリスト化した  "
        draft.result = "  教育時間を短縮できた  "
        draft.learning = "  仕組み化の重要性を学んだ  "
        draft.summaryForInterview = "  相手目線で改善した経験  "
        let now = Date(timeIntervalSince1970: 1_700_000_000)

        let episode = EpisodeEditor().createEpisode(from: draft, now: now)

        #expect(episode.title == "新人教育の改善")
        #expect(episode.situation == "引き継ぎが属人化していた")
        #expect(episode.action == "チェックリスト化した")
        #expect(episode.result == "教育時間を短縮できた")
        #expect(episode.learning == "仕組み化の重要性を学んだ")
        #expect(episode.summaryForInterview == "相手目線で改善した経験")
        #expect(episode.updatedAt == now)
    }

    @Test
    func appliesDraftToExistingEpisode() {
        let episode = Episode(title: "旧タイトル", situation: "old")
        var draft = EpisodeDraft()
        draft.title = "新タイトル"
        draft.situation = "新しい状況"
        draft.action = "新しい行動"
        let updatedAt = Date(timeIntervalSince1970: 1_800_000_000)

        EpisodeEditor().apply(draft, to: episode, now: updatedAt)

        #expect(episode.title == "新タイトル")
        #expect(episode.situation == "新しい状況")
        #expect(episode.action == "新しい行動")
        #expect(episode.updatedAt == updatedAt)
    }
}
