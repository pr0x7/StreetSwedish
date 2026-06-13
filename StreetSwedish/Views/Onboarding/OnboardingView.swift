import SwiftUI

public struct OnboardingView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    @State private var currentStep = 0
    @State private var selectedPersona = "nomad"
    @State private var selectedDifficulty = "beginner"
    @State private var dailyGoalXP = 20
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack {
                // Progress Indicator
                HStack(spacing: 8) {
                    ForEach(0..<5) { index in
                        Capsule()
                            .fill(index <= currentStep ? Color.primaryGold : Color.appSurfaceElevated)
                            .frame(height: 6)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // Content Switcher
                switch currentStep {
                case 0:
                    welcomeStep()
                case 1:
                    personaStep()
                case 2:
                    diagnosticStep()
                case 3:
                    notificationStep()
                case 4:
                    goalStep()
                default:
                    welcomeStep()
                }
                
                Spacer()
                
                // Bottom Button
                Button(action: {
                    advanceStep()
                }) {
                    Text(currentStep == 4 ? "Börja lära dig nu" : "Nästa")
                        .font(.sfRounded(size: 16, weight: .bold))
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primaryGold)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
    
    // MARK: - Step 1: Welcome Screen
    private func welcomeStep() -> some View {
        VStack(spacing: 24) {
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 72))
                .foregroundColor(.primaryGold)
                .shadow(color: .primaryGold.opacity(0.3), radius: 10)
            
            VStack(spacing: 8) {
                Text("Välkommen till Svea")
                    .font(.sfRounded(size: 32, weight: .black))
                    .foregroundColor(.textPrimary)
                
                Text("Lär dig gatans svenska")
                    .font(.sfRounded(size: 20, weight: .bold))
                    .foregroundColor(.primaryBlue)
            }
            
            Text("Glöm tråkiga SFI-böcker. Här lär du dig språket som riktiga svenskar pratar på jobbet, i baren och på dejten. Fullt offline-stöd.")
                .font(.sfStandard(size: 15))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 20)
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
    // MARK: - Step 2: Persona Selection
    private func personaStep() -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                Text("Välj din profil")
                    .font(.sfRounded(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text("Vi anpassar exemplen efter dina behov")
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textSecondary)
            }
            
            VStack(spacing: 12) {
                personaCard(
                    id: "nomad",
                    title: "The Tech Nomad",
                    description: "Vill överleva standups, fika och prata agile-slang på IT-avdelningen.",
                    icon: "laptopcomputer",
                    accent: .accentWork
                )
                
                personaCard(
                    id: "butterfly",
                    title: "The Social Butterfly",
                    description: "Fokus på bar-häng, AW, dejting och vardagligt snack på stan.",
                    icon: "wineglass.fill",
                    accent: .accentSocial
                )
                
                personaCard(
                    id: "rebel",
                    title: "The SFI Rebel",
                    description: "Vill lära sig grova svordomar, slang och SMS-förkortningar som läraren inte lär ut.",
                    icon: "exclamationmark.bubble.fill",
                    accent: .accentSwearing
                )
            }
            .padding(.horizontal, 16)
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
    private func personaCard(id: String, title: String, description: String, icon: String, accent: Color) -> some View {
        let isSelected = selectedPersona == id
        
        return Button(action: {
            selectedPersona = id
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .appBackground : accent)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? accent : Color.appSurfaceElevated)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.sfRounded(size: 16, weight: .bold))
                        .foregroundColor(isSelected ? .appBackground : .textPrimary)
                    
                    Text(description)
                        .font(.sfStandard(size: 13))
                        .foregroundColor(isSelected ? .appBackground.opacity(0.8) : .textSecondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .padding(16)
            .background(isSelected ? accent : Color.appSurface)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.clear : Color.textMuted.opacity(0.2), lineWidth: 1.5)
            )
        }
    }
    
    // MARK: - Step 3: Diagnostic Quiz
    private func diagnosticStep() -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("Vad är din nivå?")
                    .font(.sfRounded(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text("Hjälp oss placera dig rätt i repetitionen")
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textSecondary)
            }
            
            VStack(spacing: 16) {
                Button(action: {
                    selectedDifficulty = "beginner"
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "baby.toddler.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primaryBlue)
                        Text("Helt nybörjare (Absolute Beginner)")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Jag börjar helt från noll.")
                            .font(.sfStandard(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(selectedDifficulty == "beginner" ? Color.primaryBlue.opacity(0.15) : Color.appSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedDifficulty == "beginner" ? Color.primaryBlue : Color.clear, lineWidth: 2)
                    )
                    .cornerRadius(20)
                }
                
                Button(action: {
                    selectedDifficulty = "basics"
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "brain.head.profile.fill")
                            .font(.largeTitle)
                            .foregroundColor(.primaryGold)
                        Text("Lite förkunskaper (Some Basics)")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Jag kan redan några basord.")
                            .font(.sfStandard(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(selectedDifficulty == "basics" ? Color.primaryGold.opacity(0.15) : Color.appSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedDifficulty == "basics" ? Color.primaryGold : Color.clear, lineWidth: 2)
                    )
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal, 20)
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
    // MARK: - Step 4: Notification Permission Mockup
    private func notificationStep() -> some View {
        VStack(spacing: 24) {
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 72))
                .foregroundColor(.appWarning)
                .shadow(color: .appWarning.opacity(0.3), radius: 10)
            
            VStack(spacing: 8) {
                Text("Håll igång din streak!")
                    .font(.sfRounded(size: 26, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("Slå på påminnelser")
                    .font(.sfRounded(size: 18, weight: .bold))
                    .foregroundColor(.textSecondary)
            }
            
            Text("Vi skickar en kort daglig påminnelse så att du inte tappar din vinstsvit (streak) eller fryser dina framsteg.")
                .font(.sfStandard(size: 15))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 24)
            
            Button(action: {
                // Request push notifications permissions (mocked for offline app)
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    // Complete step
                }
                advanceStep()
            }) {
                Text("Slå på aviseringar")
                    .font(.sfRounded(size: 15, weight: .bold))
                    .foregroundColor(.appBackground)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.primaryBlue)
                    .cornerRadius(12)
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
    // MARK: - Step 5: Daily Goal Selection
    private func goalStep() -> some View {
        VStack(spacing: 32) {
            VStack(spacing: 6) {
                Text("Välj ditt dagliga mål")
                    .font(.sfRounded(size: 24, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text("Hur mycket tid vill du lägga varje dag?")
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textSecondary)
            }
            
            VStack(spacing: 16) {
                goalRow(xp: 10, label: "Lätt (Easy) — 5 min/dag")
                goalRow(xp: 20, label: "Måttlig (Medium) — 10 min/dag")
                goalRow(xp: 30, label: "Seriös (Serious) — 15 min/dag")
                goalRow(xp: 50, label: "Intensiv (Hardcore) — 25 min/dag")
            }
            .padding(.horizontal, 20)
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
    
    private func goalRow(xp: Int, label: String) -> some View {
        let isSelected = dailyGoalXP == xp
        
        return Button(action: {
            dailyGoalXP = xp
        }) {
            HStack {
                Text(label)
                    .font(.sfRounded(size: 15, weight: .bold))
                    .foregroundColor(isSelected ? .appBackground : .textPrimary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.appBackground)
                        .font(.headline)
                }
            }
            .padding(16)
            .background(isSelected ? Color.primaryGold : Color.appSurface)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.clear : Color.textMuted.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Onboarding Actions
    private func advanceStep() {
        if currentStep < 4 {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                currentStep += 1
            }
        } else {
            // Apply preferences to progress/SRS
            progressManager.progress.dailySessionsGoal = dailyGoalXP / 10 // e.g. 2 sessions for 20 XP
            
            // If diagnostic baseline selected, seed some items at stage 2
            if selectedDifficulty == "basics" {
                // Grab first 5 items and schedule them as introduced/recognition
                let firstFive = LessonData.allVocabItems.prefix(5)
                for item in firstFive {
                    srsScheduler.items[item.id] = SRSItem(
                        itemID: item.id,
                        stage: 2,
                        easinessFactor: 2.5,
                        intervalDays: 1.0,
                        nextReviewDate: Date().addingTimeInterval(86400) // Tomorrow
                    )
                }
                srsScheduler.saveItems()
            }
            
            // Save completed status
            progressManager.completeOnboarding()
        }
    }
}
