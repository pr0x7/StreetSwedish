import Foundation
import Combine

public final class ProgressManager: ObservableObject {
    private let userDefaultsKey = "user_progress_v1"
    
    @Published public var progress: UserProgress
    
    public init() {
        self.progress = UserProgress() // Fallback default
        loadProgress()
        checkStreak()
    }
    
    // MARK: - Persistence
    public func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            // No saved progress, keep default
            self.progress = UserProgress(
                xp: 0,
                streak: 0,
                streakFreezeCount: 1, // Start with 1 freeze for safety!
                longestStreak: 0,
                dailySessionsGoal: 5,
                weeklyXP: 0,
                weeklyXPGoalLevel: 250,
                dailySessionsCompleted: 0,
                completedLessonIDs: [],
                starredWords: [],
                onboardingPurpose: "Work",
                showGrammarNotes: true,
                vulgarsHidden: false,
                ttsRate: 0.5,
                autoAdvanceDelay: 0.8
            )
            return
        }
        
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(UserProgress.self, from: data) {
            self.progress = decoded
        }
    }
    
    public func save() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(progress) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    public func completeOnboarding() {
        progress.hasCompletedOnboarding = true
        save()
    }
    
    // MARK: - Localization
    public func loc(_ en: String, _ sv: String) -> String {
        return (progress.isEnglishUI ?? true) ? en : sv
    }
    
    // MARK: - XP & Rewards
    public func addXP(_ amount: Int) {
        progress.xp += amount
        progress.weeklyXP += amount
        save()
    }
    
    // MARK: - Lesson Completion
    public func completeLesson(lessonID: String, moduleID: String, categoryID: String, xpEarned: Int) {
        // Record completed lesson
        progress.completedLessonIDs.insert(lessonID)
        
        // Add XP
        addXP(xpEarned)
        
        // Update Module progress
        var moduleProgress = progress.moduleProgressMap[moduleID] ?? ModuleProgress(moduleID: moduleID)
        let completions = moduleProgress.lessonCompletions[lessonID] ?? 0
        moduleProgress.lessonCompletions[lessonID] = completions + 1
        
        // Check if all lessons in the module are completed to unlock the Boss level
        if let module = LessonData.getModule(byID: moduleID) {
            let allCompleted = module.lessonIDs.allSatisfy { progress.completedLessonIDs.contains($0) }
            if allCompleted && moduleProgress.bossStatus == .locked {
                moduleProgress.bossStatus = .unlocked
            }
            
            // Calculate module completion fraction
            let totalLessons = module.lessonIDs.count
            let completedLessonsCount = module.lessonIDs.filter { progress.completedLessonIDs.contains($0) }.count
            let percent = Double(completedLessonsCount) / Double(totalLessons)
            
            progress.categoryProgressMap[categoryID] = percent
        }
        
        progress.moduleProgressMap[moduleID] = moduleProgress
        
        // Handle Streak increment
        recordActivityToday()
        
        save()
    }
    
    // MARK: - Boss Completion
    public func completeBossLevel(moduleID: String, status: BossStatus, xpEarned: Int) {
        var moduleProgress = progress.moduleProgressMap[moduleID] ?? ModuleProgress(moduleID: moduleID)
        moduleProgress.bossAttempts += 1
        
        // Only upgrade status (gold > bronze > unlocked)
        if status == .gold {
            moduleProgress.bossStatus = .gold
            moduleProgress.elitePhraseUnlocked = true
        } else if status == .bronze && moduleProgress.bossStatus != .gold {
            moduleProgress.bossStatus = .bronze
        }
        
        progress.moduleProgressMap[moduleID] = moduleProgress
        addXP(xpEarned)
        recordActivityToday()
        save()
    }
    
    // MARK: - Star Words
    public func toggleStar(wordID: String) {
        if progress.starredWords.contains(wordID) {
            progress.starredWords.remove(wordID)
        } else {
            progress.starredWords.insert(wordID)
        }
        save()
    }
    
    public func purchaseStreakFreeze() {
        let freezeCost = 100 // XP cost for streak freeze
        if progress.xp >= freezeCost {
            progress.xp -= freezeCost
            progress.streakFreezeCount += 1
            save()
        }
    }
    
    // MARK: - Streak Management
    private func recordActivityToday() {
        let now = Date()
        let calendar = Calendar.current
        
        // Increment sessions completed today
        if let lastActive = progress.lastActiveDate, calendar.isDateInToday(lastActive) {
            progress.dailySessionsCompleted += 1
        } else {
            progress.dailySessionsCompleted = 1
            
            // Check if active yesterday to increment streak
            if let lastActive = progress.lastActiveDate, calendar.isDateInYesterday(lastActive) {
                progress.streak += 1
            } else if progress.streak == 0 {
                progress.streak = 1
            }
        }
        
        progress.lastActiveDate = now
        
        if progress.streak > progress.longestStreak {
            progress.longestStreak = progress.streak
        }
        
        save()
    }
    
    /// Checks if a streak was broken and applies streak freezes if available.
    public func checkStreak() {
        guard let lastActive = progress.lastActiveDate else { return }
        
        let calendar = Calendar.current
        let now = Date()
        
        // If active today or yesterday, streak is safe
        if calendar.isDateInToday(lastActive) || calendar.isDateInYesterday(lastActive) {
            return
        }
        
        // Missed days! Let's calculate exactly how many days were missed
        let startOfLastActive = calendar.startOfDay(for: lastActive)
        let startOfToday = calendar.startOfDay(for: now)
        
        guard let daysBetween = calendar.dateComponents([.day], from: startOfLastActive, to: startOfToday).day else { return }
        
        // Subtract 1 because yesterday is a valid non-break day
        let missedDays = daysBetween - 1
        
        if missedDays <= 0 { return }
        
        var freezesToUse = min(missedDays, progress.streakFreezeCount)
        
        if freezesToUse > 0 {
            // Consume freezes
            progress.streakFreezeCount -= freezesToUse
            
            // Log freeze usage dates (yesterday, day before, etc.)
            for dayOffset in 1...freezesToUse {
                if let freezeDate = calendar.date(byAdding: .day, value: -dayOffset, to: startOfToday) {
                    progress.streakFreezeUsedDates.append(freezeDate)
                }
            }
            
            // Streak is preserved, pretend last active day was yesterday
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday) {
                progress.lastActiveDate = yesterday
            }
        } else {
            // No freezes left! Streak reset
            progress.streak = 0
        }
        
        save()
    }
    
    // MARK: - Level Logic
    public var currentLevel: Int {
        // level = 1 + sqrt(xp / 100)
        if progress.xp <= 0 { return 1 }
        return 1 + Int(squareRoot(Double(progress.xp) / 100.0))
    }
    
    private func squareRoot(_ value: Double) -> Double {
        return value.squareRoot()
    }
}
