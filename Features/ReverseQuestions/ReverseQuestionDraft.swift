import Foundation

struct ReverseQuestionDraft: Equatable {
    var companyID: UUID?
    var question: String = ""
    var intent: String = ""
    var phase: InterviewPhase = .firstInterview
    var answerMemo: String = ""
    var nextDeepDive: String = ""

    init() {}

    init(reverseQuestion: ReverseQuestion) {
        companyID = reverseQuestion.companyID
        question = reverseQuestion.question
        intent = reverseQuestion.intent
        phase = reverseQuestion.phase
        answerMemo = reverseQuestion.answerMemo
        nextDeepDive = reverseQuestion.nextDeepDive
    }

    var trimmedQuestion: String {
        question.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedIntent: String {
        intent.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedAnswerMemo: String {
        answerMemo.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedNextDeepDive: String {
        nextDeepDive.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
