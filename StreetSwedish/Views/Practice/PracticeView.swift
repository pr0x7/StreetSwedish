import SwiftUI

public struct PracticeView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    // Active review queue state
    @State private var reviewQueue: [String] = []
    @State private var currentQueueIndex = 0
    @State private var isReviewActive = false
    @State private var isCardFlipped = false
    
    @StateObject private var speechHelper = SpeechHelper.shared
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            if isReviewActive {
                reviewGameplayView()
            } else {
                dashboardView()
            }
        }
        .navigationTitle(progressManager.loc("Practice", "Öva"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - 1. Dashboard View
    private func dashboardView() -> some View {
        let allIDs = LessonData.allVocabItems.map { $0.id }
        let (dueCount, unseenCount) = srsScheduler.getQueueCounts(allItemIDs: allIDs)
        
        return ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                
                // Queue Summary Card
                VStack(spacing: 20) {
                    Circle()
                        .fill(dueCount > 0 ? Color.appWarning.opacity(0.15) : Color.appSuccess.opacity(0.15))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: dueCount > 0 ? "doc.text.magnifyingglass" : "checkmark.seal.fill")
                                .font(.system(size: 36))
                                .foregroundColor(dueCount > 0 ? .appWarning : .appSuccess)
                        )
                    
                    VStack(spacing: 6) {
                        Text(dueCount > 0 ? progressManager.loc("\(dueCount) words to review", "\(dueCount) ord att repetera") : progressManager.loc("Everything is reviewed!", "Allt är repeterat!"))
                            .font(.sfRounded(size: 22, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text(dueCount > 0 ? progressManager.loc("Your brain needs to refresh these words according to the SM-2 schedule.", "Din hjärna behöver fräscha upp dessa ord enligt SM-2 schemat.") : progressManager.loc("Good job! Come back tomorrow for the next SRS round.", "Bra jobbat! Kom tillbaka imorgon för nästa SRS-runda."))
                            .font(.sfStandard(size: 14))
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    if dueCount > 0 {
                        Button(action: {
                            startReviews()
                        }) {
                            Text(progressManager.loc("Start reviewing", "Börja repetera"))
                                .font(.sfRounded(size: 16, weight: .bold))
                                .foregroundColor(.appBackground)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.primaryGold)
                                .cornerRadius(16)
                        }
                    } else if unseenCount > 0 {
                        // Encourage learning new words
                        NavigationLink(destination: CoursesView()) {
                            Text(progressManager.loc("Learn new words", "Lär dig nya ord"))
                                .font(.sfRounded(size: 16, weight: .bold))
                                .foregroundColor(.appBackground)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.primaryBlue)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding(24)
                .background(Color.appSurface)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                
                // Link to complete dictionary
                NavigationLink(destination: WordListView()) {
                    HStack {
                        Image(systemName: "character.book.closed.fill")
                            .font(.title2)
                            .foregroundColor(.primaryBlue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(progressManager.loc("Dictionary & Word List", "Ordlista & Ordbok"))
                                .font(.sfRounded(size: 16, weight: .bold))
                                .foregroundColor(.textPrimary)
                            Text(progressManager.loc("Search, star, and track progress for all \(allIDs.count) words.", "Sök, stjärnmarkera och återställ framsteg för alla \(allIDs.count) ord."))
                                .font(.sfStandard(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.textMuted)
                    }
                    .padding(20)
                    .background(Color.appSurface)
                    .cornerRadius(20)
                }
            }
            .padding(20)
        }
    }
    
    // MARK: - 2. Active Review Screen
    private func reviewGameplayView() -> some View {
        guard currentQueueIndex < reviewQueue.count else {
            return AnyView(reviewCompletedView())
        }
        
        let itemID = reviewQueue[currentQueueIndex]
        guard let item = LessonData.allVocabItems.first(where: { $0.id == itemID }) else {
            return AnyView(reviewCompletedView())
        }
        
        return AnyView(VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    withAnimation {
                        isReviewActive = false
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.textMuted)
                        .font(.title3)
                }
                
                Spacer()
                
                Text("\(currentQueueIndex + 1) / \(reviewQueue.count)")
                    .font(.sfRounded(size: 14, weight: .bold))
                    .foregroundColor(.textSecondary)
                
                Spacer()
                
                // Star Button
                Button(action: {
                    progressManager.toggleStar(wordID: item.id)
                }) {
                    Image(systemName: progressManager.progress.starredWords.contains(item.id) ? "star.fill" : "star")
                        .foregroundColor(.primaryGold)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            Spacer()
            
            // Flipped Card Container
            ZStack {
                if isCardFlipped {
                    // Back of card
                    VStack(spacing: 20) {
                        Text(item.swedish)
                            .font(.sfRounded(size: 34, weight: .bold))
                            .foregroundColor(.primaryGold)
                        
                        Text("/\(item.pronunciation)/")
                            .font(.sfRounded(size: 15, weight: .medium))
                            .foregroundColor(.textSecondary)
                        
                        Divider()
                            .background(Color.textMuted.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(progressManager.loc("MEANING", "BETYDELSE"))
                                .font(.sfRounded(size: 10, weight: .bold))
                                .foregroundColor(.textMuted)
                                .tracking(1.0)
                            Text(item.english)
                                .font(.sfStandard(size: 18, weight: .bold))
                                .foregroundColor(.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let example = item.exampleSentences.first {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(progressManager.loc("EXAMPLE SENTENCE", "EXEMPELMENING"))
                                    .font(.sfRounded(size: 10, weight: .bold))
                                    .foregroundColor(.textMuted)
                                    .tracking(1.0)
                                Text(example.swedish)
                                    .font(.sfStandard(size: 15, weight: .semibold))
                                    .foregroundColor(.textPrimary)
                                Text(example.english)
                                    .font(.sfStandard(size: 13))
                                    .foregroundColor(.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer()
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, maxHeight: 380)
                    .background(Color.appSurfaceElevated)
                    .cornerRadius(24)
                    .shadow(radius: 10)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                } else {
                    // Front of card
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Text(item.swedish)
                            .font(.sfRounded(size: 40, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("/\(item.pronunciation)/")
                            .font(.sfRounded(size: 16, weight: .medium))
                            .foregroundColor(.textSecondary)
                        
                        Button(action: {
                            speechHelper.speak(item.swedish, itemID: item.id, rate: progressManager.progress.ttsRate)
                        }) {
                            Image(systemName: speechHelper.isSpeaking && speechHelper.currentlySpeakingID == item.id ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .font(.title3)
                                .foregroundColor(.primaryBlue)
                                .padding(14)
                                .background(Color.appSurfaceElevated)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text(progressManager.loc("Tap to flip card", "Klicka för att se svar"))
                            .font(.sfRounded(size: 12, weight: .semibold))
                            .foregroundColor(.textMuted)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, maxHeight: 380)
                    .background(Color.appSurface)
                    .cornerRadius(24)
                    .shadow(radius: 10)
                }
            }
            .rotation3DEffect(.degrees(isCardFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .padding(.horizontal, 24)
            .onTapGesture {
                flipCard()
            }
            
            Spacer()
            
            // Bottom Action buttons
            VStack {
                if !isCardFlipped {
                    Button(action: {
                        flipCard()
                    }) {
                        Text(progressManager.loc("Show Answer", "Visa svar"))
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primaryGold)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                } else {
                    HStack(spacing: 16) {
                        // Failed button
                        Button(action: {
                            recordReview(itemID: item.id, isCorrect: false)
                        }) {
                            Text(progressManager.loc("Forgot", "Misslyckades"))
                                .font(.sfRounded(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.appError)
                                .cornerRadius(16)
                        }
                        
                        // Correct button
                        Button(action: {
                            recordReview(itemID: item.id, isCorrect: true)
                        }) {
                            Text(progressManager.loc("Remembered", "Klarade"))
                                .font(.sfRounded(size: 16, weight: .bold))
                                .foregroundColor(.appBackground)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.appSuccess)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        })
    }
    
    // MARK: - 3. Review Completed View
    private func reviewCompletedView() -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 80))
                .foregroundColor(.appSuccess)
                .shadow(radius: 10)
            
            Text(progressManager.loc("Review Complete!", "Repetition klar!"))
                .font(.sfRounded(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text(progressManager.loc("You have reviewed \(reviewQueue.count) words. Your progress has been updated in your local SM-2 database.", "Du har repeterat \(reviewQueue.count) ord. Dina framsteg har sparats i ditt lokala SM-2 register."))
                .font(.sfStandard(size: 16))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    isReviewActive = false
                }
            }) {
                Text(progressManager.loc("Go Back", "Gå tillbaka"))
                    .font(.sfRounded(size: 16, weight: .bold))
                    .foregroundColor(.appBackground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primaryGold)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
    
    // MARK: - Actions & Helpers
    private func startReviews() {
        let allIDs = LessonData.allVocabItems.map { $0.id }
        reviewQueue = srsScheduler.getDailyQueue(allItemIDs: allIDs)
        currentQueueIndex = 0
        isCardFlipped = false
        
        if !reviewQueue.isEmpty {
            withAnimation {
                isReviewActive = true
            }
        }
    }
    
    private func flipCard() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            isCardFlipped.toggle()
        }
    }
    
    private func recordReview(itemID: String, isCorrect: Bool) {
        // Log in SM-2
        srsScheduler.recordResponse(itemID: itemID, isCorrect: isCorrect, responseQuality: isCorrect ? 1.0 : 0.0)
        
        // Award small XP bonus for reviewing
        if isCorrect {
            progressManager.addXP(5)
        }
        
        // Advance
        withAnimation {
            isCardFlipped = false
            currentQueueIndex += 1
        }
    }
}
