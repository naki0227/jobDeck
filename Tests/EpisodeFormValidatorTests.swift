import Foundation
import Testing

@testable import JobDeck

struct EpisodeFormValidatorTests {
    @Test
    func requiresTitleAndSituation() {
        let draft = EpisodeDraft()

        let messages = EpisodeFormValidator().validate(draft)

        #expect(messages.contains("エピソード名は必須です。"))
        #expect(messages.contains("状況は最低限書いておきましょう。"))
    }

    @Test
    func rejectsTooLongSummary() {
        var draft = EpisodeDraft()
        draft.title = "改善経験"
        draft.situation = "アルバイトの教育が属人化していた"
        draft.summaryForInterview = String(repeating: "a", count: 201)

        let messages = EpisodeFormValidator().validate(draft)

        #expect(messages.contains("面接用一言要約は200文字以内にしてください。"))
    }
}
