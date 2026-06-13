import SwiftUI

public struct MainTabView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(progressManager.loc("Home", "Hem"), systemImage: "house.fill")
                }
                .tag(0)
            
            CoursesView()
                .tabItem {
                    Label(progressManager.loc("Learn", "Lär dig"), systemImage: "book.fill")
                }
                .tag(1)
            
            SFIHubView()
                .tabItem {
                    Label("SFI", systemImage: "graduationcap.fill")
                }
                .tag(2)
            
            PracticeView()
                .tabItem {
                    Label(progressManager.loc("Practice", "Öva"), systemImage: "doc.text.magnifyingglass")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label(progressManager.loc("Profile", "Profil"), systemImage: "person.fill")
                }
                .tag(4)
        }
        .tint(.primaryGold)
        .onAppear {
            // Customize TabBar appearance for a sleek dark mode look
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(Color.appSurface)
            
            // Unselected item styling
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.textMuted)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.textMuted)]
            
            // Selected item styling
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primaryGold)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.primaryGold)]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
