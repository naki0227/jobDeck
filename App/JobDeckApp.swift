import SwiftData
import SwiftUI

@main
struct JobDeckApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [
            Company.self,
            Episode.self,
            InterviewDeck.self,
        ])
    }
}
