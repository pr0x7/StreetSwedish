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
                    Label("Hem", systemImage: "house.fill")
                }
                .tag(0)
            
            CoursesView()
                .tabItem {
                    Label("Lär dig", systemImage: "book.fill")
                }
                .tag(1)
            
            PracticeView()
                .tabItem {
                    Label("Öva", systemImage: "doc.text.magnifyingglass")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
                .tag(3)
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
