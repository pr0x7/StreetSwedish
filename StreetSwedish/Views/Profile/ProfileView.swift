import SwiftUI

public struct ProfileView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    @State private var ttsRateSlider: Double = 0.5
    @State private var showingResetConfirmation = false
    @State private var showingResetFinalConfirmation = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // User Profile summary
                        profileHeader()
                        
                        // Statistics Grid
                        statsGrid()
                        
                        // Navigation Links (Progress Map)
                        NavigationLink(destination: ProgressMapView()) {
                            HStack {
                                Image(systemName: "square.grid.3x3.topleft.filled")
                                    .foregroundColor(.primaryBlue)
                                    .font(.title3)
                                
                                Text("Visa framstegskarta (Progress Map)")
                                    .font(.sfRounded(size: 16, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.textMuted)
                            }
                            .padding(20)
                            .background(Color.appSurface)
                            .cornerRadius(20)
                        }
                        
                        // Settings & Controls
                        settingsSection()
                        
                        // Danger Zone (Reset)
                        dangerZoneSection()
                        
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Profil (Profile)")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Radera all data?", isPresented: $showingResetConfirmation) {
                Button("Avbryt", role: .cancel) {}
                Button("Fortsätt", role: .destructive) {
                    showingResetFinalConfirmation = true
                }
            } message: {
                Text("Detta kommer att nollställa alla dina poäng, lektioner och stjärnmarkerade ord. Är du säker?")
            }
            .alert("ÄR DU HELT SÄKER?", isPresented: $showingResetFinalConfirmation) {
                Button("Avbryt", role: .cancel) {}
                Button("JA, RADERA ALLT", role: .destructive) {
                    resetAllAppData()
                }
            } message: {
                Text("Detta val går inte att ångra. All din inlärningshistorik försvinner permanent.")
            }
            .onAppear {
                ttsRateSlider = Double(progressManager.progress.ttsRate)
            }
        }
    }
    
    // MARK: - Profile Header
    private func profileHeader() -> some View {
        VStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(Color.appSurfaceElevated)
                .frame(width: 90, height: 90)
                .overlay(
                    Text("🇸🇪")
                        .font(.system(size: 44))
                )
                .shadow(radius: 5)
            
            VStack(spacing: 4) {
                Text("Svea Elev")
                    .font(.sfRounded(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Nivå \(progressManager.currentLevel) Språkforskare")
                    .font(.sfRounded(size: 14, weight: .semibold))
                    .foregroundColor(.textSecondary)
            }
            
            // Level progress bar
            let xpInCurrentLevel = progressManager.progress.xp % 100
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(xpInCurrentLevel) / 100 XP för nästa nivå")
                        .font(.sfRounded(size: 12, weight: .bold))
                        .foregroundColor(.textSecondary)
                    Spacer()
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.appSurfaceElevated)
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(Color.primaryGold)
                            .frame(width: geo.size.width * CGFloat(Double(xpInCurrentLevel) / 100.0), height: 8)
                    }
                }
                .frame(height: 8)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color.appSurface)
        .cornerRadius(24)
    }
    
    // MARK: - Stats Grid
    private func statsGrid() -> some View {
        let itemsCount = LessonData.allVocabItems.count
        
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            // Stat 1: XP
            statCard(title: "TOTALT XP", value: "\(progressManager.progress.xp)", icon: "bolt.fill", color: .primaryGold)
            
            // Stat 2: Streak
            statCard(title: "AKTIV STREAK", value: "\(progressManager.progress.streak) d", icon: "flame.fill", color: .streakFlame)
            
            // Stat 3: Mastered Words
            let mastered = srsScheduler.items.values.filter { $0.stage == 5 }.count
            statCard(title: "MÄSTRADE ORD", value: "\(mastered)/\(itemsCount)", icon: "checkmark.seal.fill", color: .appSuccess)
            
            // Stat 4: Starred Words
            statCard(title: "SPARADE ORD", value: "\(progressManager.progress.starredWords.count)", icon: "star.fill", color: .accentSMS)
        }
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.body)
                Spacer()
            }
            
            Text(value)
                .font(.sfRounded(size: 22, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(.sfRounded(size: 11, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
        }
        .padding(16)
        .background(Color.appSurface)
        .cornerRadius(20)
    }
    
    // MARK: - Settings Section
    private func settingsSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("INSTÄLLNINGAR (SETTINGS)")
                .font(.sfRounded(size: 12, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.5)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Talhastighet (Speech Speed)")
                    .font(.sfRounded(size: 14, weight: .bold))
                    .foregroundColor(.textSecondary)
                
                HStack {
                    Image(systemName: "tortoise.fill")
                        .foregroundColor(.textMuted)
                    
                    Slider(value: $ttsRateSlider, in: 0.3...0.7) { editing in
                        if !editing {
                            progressManager.progress.ttsRate = Float(ttsRateSlider)
                            progressManager.save()
                        }
                    }
                    .tint(.primaryBlue)
                    
                    Image(systemName: "hare.fill")
                        .foregroundColor(.textMuted)
                }
                
                Text(String(format: "Nuvarande hastighet: %.0f%%", ttsRateSlider * 200))
                    .font(.sfRounded(size: 12, weight: .semibold))
                    .foregroundColor(.textMuted)
            }
            .padding(20)
            .background(Color.appSurface)
            .cornerRadius(20)
        }
    }
    
    // MARK: - Danger Zone
    private func dangerZoneSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                showingResetConfirmation = true
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.appError)
                    Text("Nollställ all appdata")
                        .font(.sfRounded(size: 15, weight: .bold))
                        .foregroundColor(.appError)
                    Spacer()
                }
                .padding(20)
                .background(Color.appSurface)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.appError.opacity(0.3), lineWidth: 1.5)
                )
            }
        }
    }
    
    // MARK: - Clear data helper
    private func resetAllAppData() {
        progressManager.progress = UserProgress()
        progressManager.save()
        srsScheduler.items = [:]
        srsScheduler.saveItems()
        ttsRateSlider = 0.5
    }
}
