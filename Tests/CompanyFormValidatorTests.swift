import Foundation
import Testing

@testable import JobDeck

struct CompanyFormValidatorTests {
    @Test
    func requiresCompanyName() {
        let draft = CompanyDraft()

        let messages = CompanyFormValidator().validate(draft)

        #expect(messages.contains("企業名は必須です。"))
    }

    @Test
    func rejectsPriorityOutsideAllowedRange() {
        var draft = CompanyDraft()
        draft.name = "Atlas"
        draft.priority = 6

        let messages = CompanyFormValidator().validate(draft)

        #expect(messages.contains("志望度は1から5で設定してください。"))
    }
}
