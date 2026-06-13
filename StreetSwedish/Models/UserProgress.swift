import Foundation

// MARK: - SRS Item
public struct SRSItem: Codable, Identifiable, Hashable {
    public var id: String { itemID }
    public let itemID: String
    public var stage: Int                  // 0 to 5
    public var easinessFactor: Double       // Starting at 2.5, min 1.3
    public var intervalDays: Double         // Interval in days before next review
    public var nextReviewDate: Date         // When the item is next due
    public var repetitionCount: Int         // Number of consecutive correct reviews
    public var failureCount: Int            // Total times failed
    public var lastSeenDate: Date           // Timestamp of last review
    public var lastResponseQuality: Double  // Quality score (0.0 to 1.0)
    
    public init(
        itemID: String,
        stage: Int = 0,
        easinessFactor: Double = 2.5,
        intervalDays: Double = 0.0,
        nextReviewDate: Date = Date(),
        repetitionCount: Int = 0,
        failureCount: Int = 0,
        lastSeenDate: Date = Date(),
        lastResponseQuality: Double = 0.0
    ) {
        self.itemID = itemID
        self.stage = stage
        self.easinessFactor = easinessFactor
        self.intervalDays = intervalDays
        self.nextReviewDate = nextReviewDate
        self.repetitionCount = repetitionCount
        self.failureCount = failureCount
        self.lastSeenDate = lastSeenDate
        self.lastResponseQuality = lastResponseQuality
    }
}

// MARK: - Module Progress
public enum BossStatus: String, Codable, CaseIterable {
    case locked = "locked"
    case unlocked = "unlocked"
    case bronze = "bronze"
    case gold = "gold"
}

public struct ModuleProgress: Codable, Identifiable, Hashable {
    public var id: String { moduleID }
    public let moduleID: String
    public var lessonCompletions: [String: Int] // lessonID: completionCount
    public var bossAttempts: Int
    public var bossStatus: BossStatus
    public var elitePhraseUnlocked: Bool
    
    public init(
        moduleID: String,
        lessonCompletions: [String: Int] = [:],
        bossAttempts: Int = 0,
        bossStatus: BossStatus = .locked,
        elitePhraseUnlocked: Bool = false
    ) {
        self.moduleID = moduleID
        self.lessonCompletions = lessonCompletions
        self.bossAttempts = bossAttempts
        self.bossStatus = bossStatus
        self.elitePhraseUnlocked = elitePhraseUnlocked
    }
}

// MARK: - User Progress
public struct UserProgress: Codable, Hashable {
    // Game stats
    public var xp: Int
    public var streak: Int
    public var streakFreezeCount: Int
    public var streakFreezeUsedDates: [Date]
    public var longestStreak: Int
    
    // Goals & Activity
    public var dailySessionsGoal: Int          // Goal count of sessions per day
    public var weeklyXP: Int                    // XP accumulated this week
    public var weeklyXPGoalLevel: Int           // Threshold for goal
    public var dailySessionsCompleted: Int      // Sessions completed today
    public var lastActiveDate: Date?            // Last day they completed a lesson
    
    // Lessons & Vocab
    public var completedLessonIDs: Set<String>
    public var starredWords: Set<String>
    
    // Onboarding & Settings
    public var onboardingPurpose: String        // E.g. "Work", "Partner"
    public var hasCompletedOnboarding: Bool
    public var showGrammarNotes: Bool
    public var vulgarsHidden: Bool
    public var ttsRate: Float                  // Rate parameter for AVSpeech (default ~0.5)
    public var autoAdvanceDelay: Double         // Auto-advance delay for correct answers (e.g. 0.8)
    public var isEnglishUI: Bool?               // Language of the user interface (defaults to true/English)
    
    // Maps
    public var categoryProgressMap: [String: Double]    // categoryID: completionPercentage (0.0 to 1.0)
    public var moduleProgressMap: [String: ModuleProgress] // moduleID: ModuleProgress
    public var lessonResumeActs: [String: Int]?
    public var lessonResumeStepIndices: [String: Int]?
    
    public init(
        xp: Int = 0,
        streak: Int = 0,
        streakFreezeCount: Int = 0,
        streakFreezeUsedDates: [Date] = [],
        longestStreak: Int = 0,
        dailySessionsGoal: Int = 5,
        weeklyXP: Int = 0,
        weeklyXPGoalLevel: Int = 250,
        dailySessionsCompleted: Int = 0,
        lastActiveDate: Date? = nil,
        completedLessonIDs: Set<String> = [],
        starredWords: Set<String> = [],
        onboardingPurpose: String = "",
        hasCompletedOnboarding: Bool = false,
        showGrammarNotes: Bool = true,
        vulgarsHidden: Bool = false,
        ttsRate: Float = 0.5,
        autoAdvanceDelay: Double = 0.8,
        isEnglishUI: Bool? = true,
        categoryProgressMap: [String: Double] = [:],
        moduleProgressMap: [String: ModuleProgress] = [:],
        lessonResumeActs: [String: Int]? = [:],
        lessonResumeStepIndices: [String: Int]? = [:]
    ) {
        self.xp = xp
        self.streak = streak
        self.streakFreezeCount = streakFreezeCount
        self.streakFreezeUsedDates = streakFreezeUsedDates
        self.longestStreak = longestStreak
        self.dailySessionsGoal = dailySessionsGoal
        self.weeklyXP = weeklyXP
        self.weeklyXPGoalLevel = weeklyXPGoalLevel
        self.dailySessionsCompleted = dailySessionsCompleted
        self.lastActiveDate = lastActiveDate
        self.completedLessonIDs = completedLessonIDs
        self.starredWords = starredWords
        self.onboardingPurpose = onboardingPurpose
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.showGrammarNotes = showGrammarNotes
        self.vulgarsHidden = vulgarsHidden
        self.ttsRate = ttsRate
        self.autoAdvanceDelay = autoAdvanceDelay
        self.isEnglishUI = isEnglishUI
        self.categoryProgressMap = categoryProgressMap
        self.moduleProgressMap = moduleProgressMap
        self.lessonResumeActs = lessonResumeActs
        self.lessonResumeStepIndices = lessonResumeStepIndices
    }
}
