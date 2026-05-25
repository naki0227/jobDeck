import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel())
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }

            CompanyListView()
                .tabItem {
                    Label("企業", systemImage: "building.2")
                }

            SelfCardsView()
                .tabItem {
                    Label("自分カード", systemImage: "person.text.rectangle")
                }

            InterviewPrepView()
                .tabItem {
                    Label("面接前", systemImage: "rectangle.stack")
                }

            SettingsView()
                .tabItem {
                    Label("設定", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    RootTabView()
}
