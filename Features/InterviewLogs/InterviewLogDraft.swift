import Foundation

struct InterviewLogDraft: Equatable {
    var interviewAt: Date = .now
    var phase: InterviewPhase = .firstInterview
    var askedQuestionsText: String = ""
    var myAnswersMemo: String = ""
    var stuckPoints: String = ""
    var interviewerReaction: String = ""
    var reverseQuestionsAskedText: String = ""
    var learnedInfo: String = ""
    var nextImprovement: String = ""

    init() {}

    init(interviewLog: InterviewLog) {
        interviewAt = interviewLog.interviewAt
        phase = interviewLog.phase
        askedQuestionsText = interviewLog.askedQuestionsText
        myAnswersMemo = interviewLog.myAnswersMemo
        stuckPoints = interviewLog.stuckPoints
        interviewerReaction = interviewLog.interviewerReaction
        reverseQuestionsAskedText = interviewLog.reverseQuestionsAskedText
        learnedInfo = interviewLog.learnedInfo
        nextImprovement = interviewLog.nextImprovement
    }

    var trimmedAskedQuestionsText: String {
        askedQuestionsText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedAnswersMemo: String {
        myAnswersMemo.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedStuckPoints: String {
        stuckPoints.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedInterviewerReaction: String {
        interviewerReaction.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedReverseQuestionsAskedText: String {
        reverseQuestionsAskedText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedLearnedInfo: String {
        learnedInfo.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedNextImprovement: String {
        nextImprovement.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
