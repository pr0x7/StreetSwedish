import SwiftUI

@main
struct StreetSwedishApp: App {
    @StateObject private var progressManager = ProgressManager()
    @StateObject private var srsScheduler = SRSScheduler()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if progressManager.progress.hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(progressManager)
            .environmentObject(srsScheduler)
            .preferredColorScheme(.dark) // Lock the app to a beautiful dark mode
        }
    }
}
