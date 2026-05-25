import Foundation

struct PreviewStore {
    func makeCompanies(now: Date = .now) -> [Company] {
        [
            Company(
                name: "Atlas Systems",
                industry: "IT",
                jobType: "iOS Engineer",
                selectionStatus: .interviewScheduled,
                priority: 5,
                memo: "ユーザー体験と内製文化を重視",
                nextInterviewAt: Calendar.current.date(byAdding: .day, value: 2, to: now)
            ),
            Company(
                name: "Northwind Design",
                industry: "Design",
                jobType: "Product Engineer",
                selectionStatus: .applied,
                priority: 4,
                memo: "少人数で裁量が大きい"
            ),
            Company(
                name: "Harbor AI",
                industry: "AI",
                jobType: "Backend Engineer",
                selectionStatus: .finalInterview,
                priority: 5,
                memo: "面接ごとに深掘りが鋭い",
                nextInterviewAt: Calendar.current.date(byAdding: .day, value: 5, to: now)
            ),
        ]
    }

    func makeDecks(companies: [Company], now: Date = .now) -> [InterviewDeck] {
        guard let firstCompany = companies.first else {
            return []
        }

        return [
            InterviewDeck(
                companyID: firstCompany.id,
                interviewAt: Calendar.current.date(byAdding: .day, value: 2, to: now) ?? now,
                mainAxis: "人の行動変化をプロダクトで支えたい",
                openingSelfIntro: "改善を積み上げる開発が得意です。",
                cautionPoints: ["志望理由を抽象化しすぎない"],
                checklist: ["企業名を言い間違えない"],
                generatedByAI: false
            )
        ]
    }
}
