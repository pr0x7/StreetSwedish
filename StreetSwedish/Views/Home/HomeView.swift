import SwiftUI

public struct HomeView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    @State private var showingLesson: Lesson? = nil
    @State private var wordOfTheDayCollapsed = false
    @StateObject private var speechHelper = SpeechHelper.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Header: Streak & Freezes
                        headerBar()
                        
                        // Dynamic Swedish Greeting
                        greetingSection()
                        
                        // Active Continue Card
                        continueCard()
                        
                        // Word of the Day
                        wordOfTheDaySection()
                        
                        // Quick Status Badges (Due reviews / Starred count)
                        quickStatsRow()
                        
                    }
                    .padding(20)
                }
            }
            .navigationDestination(item: $showingLesson) { lesson in
                LessonView(lesson: lesson)
            }
        }
    }
    
    // MARK: - Header Bar
    private func headerBar() -> some View {
        HStack {
            // Streak Flame
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.streakFlame)
                    .font(.title3)
                
                Text("\(progressManager.progress.streak)")
                    .font(.sfRounded(size: 18, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Text("dagar")
                    .font(.sfRounded(size: 13, weight: .semibold))
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.appSurface)
            .cornerRadius(20)
            
            Spacer()
            
            // Streak Freeze Info
            HStack(spacing: 8) {
                Image(systemName: "snowflake")
                    .foregroundColor(.accentWork)
                    .font(.body)
                
                Text("\(progressManager.progress.streakFreezeCount)")
                    .font(.sfRounded(size: 15, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                // Purchase button if low on freezes
                if progressManager.progress.streakFreezeCount < 3 {
                    Button(action: {
                        progressManager.purchaseStreakFreeze()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.primaryGold)
                            .font(.body)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.appSurface)
            .cornerRadius(20)
        }
    }
    
    // MARK: - Greeting
    private func greetingSection() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Tja! Redo att lära?")
                .font(.sfRounded(size: 28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Text("Nivå \(progressManager.currentLevel) • \(progressManager.progress.xp) XP totalt")
                .font(.sfRounded(size: 14, weight: .semibold))
                .foregroundColor(.textSecondary)
        }
    }
    
    // MARK: - Continue Card
    private func continueCard() -> some View {
        let nextLesson = getNextLessonToStudy()
        
        return VStack(alignment: .leading, spacing: 18) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("FORTSÄTT DÄR DU SLUTADE")
                        .font(.sfRounded(size: 11, weight: .bold))
                        .foregroundColor(.textMuted)
                        .tracking(1.5)
                    
                    Text(nextLesson.title)
                        .font(.sfRounded(size: 22, weight: .bold))
                        .foregroundColor(.primaryGold)
                }
                Spacer()
                
                // Circular daily session goal ring
                ZStack {
                    Circle()
                        .stroke(Color.appSurfaceElevated, lineWidth: 6)
                        .frame(width: 48, height: 48)
                    
                    let fraction = Double(progressManager.progress.dailySessionsCompleted) / Double(progressManager.progress.dailySessionsGoal)
                    Circle()
                        .trim(from: 0, to: CGFloat(min(fraction, 1.0)))
                        .stroke(Color.appSuccess, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 48, height: 48)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(progressManager.progress.dailySessionsCompleted)/\(progressManager.progress.dailySessionsGoal)")
                        .font(.sfRounded(size: 10, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
            }
            
            Text("Lär dig typiskt kontors-svenska och agility-slang för att överleva fikan på IT-avdelningen.")
                .font(.sfStandard(size: 15))
                .foregroundColor(.textPrimary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            Button(action: {
                showingLesson = nextLesson
            }) {
                HStack {
                    Text("Starta nästa lektion")
                        .font(.sfRounded(size: 16, weight: .bold))
                    Spacer()
                    Image(systemName: "play.fill")
                }
                .foregroundColor(.appBackground)
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .background(Color.primaryGold)
                .cornerRadius(16)
            }
        }
        .padding(24)
        .background(Color.appSurface)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.25), radius: 15, y: 8)
    }
    
    // MARK: - Word of the Day
    private func wordOfTheDaySection() -> some View {
        let word = getWordOfTheDay()
        
        return VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.spring()) {
                    wordOfTheDayCollapsed.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.primaryBlue)
                    Text("Dagens ord (Word of the Day)")
                        .font(.sfRounded(size: 14, weight: .bold))
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Image(systemName: wordOfTheDayCollapsed ? "chevron.down" : "chevron.up")
                        .foregroundColor(.textMuted)
                        .font(.caption)
                }
            }
            
            if !wordOfTheDayCollapsed {
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(word.swedish)
                                .font(.sfRounded(size: 26, weight: .bold))
                                .foregroundColor(.primaryGold)
                            Text("/\(word.pronunciation)/")
                                .font(.sfRounded(size: 14, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            speechHelper.speak(word.swedish, itemID: "wotd", rate: progressManager.progress.ttsRate)
                        }) {
                            Image(systemName: speechHelper.isSpeaking && speechHelper.currentlySpeakingID == "wotd" ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .font(.body)
                                .foregroundColor(.primaryBlue)
                                .padding(12)
                                .background(Color.appSurface)
                                .clipShape(Circle())
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("BETYDELSE")
                            .font(.sfRounded(size: 10, weight: .bold))
                            .foregroundColor(.textMuted)
                            .tracking(1.0)
                        Text(word.english)
                            .font(.sfStandard(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }
                    
                    if let example = word.exampleSentences.first {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("EXEMPELMENING")
                                .font(.sfRounded(size: 10, weight: .bold))
                                .foregroundColor(.textMuted)
                                .tracking(1.0)
                            Text(example.swedish)
                                .font(.sfStandard(size: 14, weight: .medium))
                                .foregroundColor(.textPrimary)
                            Text(example.english)
                                .font(.sfStandard(size: 13))
                                .foregroundColor(.textSecondary)
                        }
                    }
                }
                .padding(16)
                .background(Color.appSurfaceElevated)
                .cornerRadius(18)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(20)
        .background(Color.appSurface)
        .cornerRadius(24)
    }
    
    // MARK: - Quick Stats Row
    private func quickStatsRow() -> some View {
        let allIDs = LessonData.allVocabItems.map { $0.id }
        let (due, _) = srsScheduler.getQueueCounts(allItemIDs: allIDs)
        
        return HStack(spacing: 16) {
            // Due reviews card
            NavigationLink(destination: PracticeView()) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(due > 0 ? Color.appError : Color.appSurfaceElevated)
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "doc.text.magnifyingglass")
                            .foregroundColor(due > 0 ? .white : .textMuted)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(due)")
                            .font(.sfRounded(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Att repetera")
                            .font(.sfRounded(size: 12, weight: .semibold))
                            .foregroundColor(.textSecondary)
                    }
                    Spacer()
                }
                .padding(16)
                .background(Color.appSurface)
                .cornerRadius(20)
            }
            
            // Starred words card
            NavigationLink(destination: WordListView()) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.appSurfaceElevated)
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.primaryGold)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(progressManager.progress.starredWords.count)")
                            .font(.sfRounded(size: 20, weight: .bold))
                            .foregroundColor(.textPrimary)
                        Text("Sparade ord")
                            .font(.sfRounded(size: 12, weight: .semibold))
                            .foregroundColor(.textSecondary)
                    }
                    Spacer()
                }
                .padding(16)
                .background(Color.appSurface)
                .cornerRadius(20)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func getNextLessonToStudy() -> Lesson {
        // Return first lesson whose ID is not completed, default to first lesson
        for lesson in LessonData.allLessons {
            if !progressManager.progress.completedLessonIDs.contains(lesson.id) {
                return lesson
            }
        }
        return LessonData.allLessons[0]
    }
    
    private func getWordOfTheDay() -> VocabItem {
        // Pick index based on calendar day
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % LessonData.allVocabItems.count
        return LessonData.allVocabItems[index]
    }
}
