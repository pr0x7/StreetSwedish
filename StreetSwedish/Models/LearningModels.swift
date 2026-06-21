import Foundation

// MARK: - Register Level
public enum RegisterLevel: String, Codable, CaseIterable, Hashable {
    case neutral = "neutral"
    case informal = "informal"
    case slang = "slang"
    case vulgar = "vulgar"
    case textOnly = "textOnly"
    case workplaceOK = "workplaceOK"
    
    public var displayName: String {
        switch self {
        case .neutral: return "Neutral"
        case .informal: return "Vardaglig" // Everyday/informal
        case .slang: return "Slang"
        case .vulgar: return "Fult språk" // Vulgar/swear word
        case .textOnly: return "Sms-språk"
        case .workplaceOK: return "Jobb-säker" // Safe for work
        }
    }
}

// MARK: - Vocabulary Items
public struct ExampleSentence: Codable, Identifiable, Hashable {
    public var id: String { swedish }
    public let swedish: String
    public let english: String
    public let contextNote: String?
    public let registerLabel: RegisterLevel
    
    public init(swedish: String, english: String, contextNote: String? = nil, registerLabel: RegisterLevel = .neutral) {
        self.swedish = swedish
        self.english = english
        self.contextNote = contextNote
        self.registerLabel = registerLabel
    }
}

public struct VocabItem: Codable, Identifiable, Hashable {
    public let id: String
    public let swedish: String
    public let english: String
    public let pronunciation: String
    public let exampleSentences: [ExampleSentence]
    public let soundHook: String
    public let visualHook: String
    public let cultureHook: String
    public let registerLabel: RegisterLevel
    public let usageWarning: String?
    public let relatedItemIDs: [String]
    public let grammarNote: String?
    
    public init(
        id: String,
        swedish: String,
        english: String,
        pronunciation: String,
        exampleSentences: [ExampleSentence],
        soundHook: String,
        visualHook: String,
        cultureHook: String,
        registerLabel: RegisterLevel,
        usageWarning: String? = nil,
        relatedItemIDs: [String] = [],
        grammarNote: String? = nil
    ) {
        self.id = id
        self.swedish = swedish
        self.english = english
        self.pronunciation = pronunciation
        self.exampleSentences = exampleSentences
        self.soundHook = soundHook
        self.visualHook = visualHook
        self.cultureHook = cultureHook
        self.registerLabel = registerLabel
        self.usageWarning = usageWarning
        self.relatedItemIDs = relatedItemIDs
        self.grammarNote = grammarNote
    }
}

// MARK: - Characters
public struct Character: Codable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let age: Int
    public let bio: String
    public let dialectNote: String
    public let avatarAssetName: String
    public let moduleIDs: [String]
    
    public init(id: String, name: String, age: Int, bio: String, dialectNote: String, avatarAssetName: String, moduleIDs: [String]) {
        self.id = id
        self.name = name
        self.age = age
        self.bio = bio
        self.dialectNote = dialectNote
        self.avatarAssetName = avatarAssetName
        self.moduleIDs = moduleIDs
    }
}

// MARK: - Dialogue
public struct DialogueLine: Codable, Identifiable, Hashable {
    public var id: String { swedish }
    public let speakerID: String
    public let swedish: String
    public let english: String
    public let alternativeSlang: String?
    public let alternativeFormal: String?
    public let culturalNote: String?
    
    public init(
        speakerID: String,
        swedish: String,
        english: String,
        alternativeSlang: String? = nil,
        alternativeFormal: String? = nil,
        culturalNote: String? = nil
    ) {
        self.speakerID = speakerID
        self.swedish = swedish
        self.english = english
        self.alternativeSlang = alternativeSlang
        self.alternativeFormal = alternativeFormal
        self.culturalNote = culturalNote
    }
}

public struct Dialogue: Codable, Identifiable, Hashable {
    public var id: String { title }
    public let title: String
    public let lines: [DialogueLine]
    public let pullQuote: String?
    
    public init(title: String, lines: [DialogueLine], pullQuote: String? = nil) {
        self.title = title
        self.lines = lines
        self.pullQuote = pullQuote
    }
}

// MARK: - Cultural Context
public struct CulturalContextCard: Codable, Hashable {
    public let bodyText: String
    public let illustrationName: String
    public let dialogueIDs: [String]
    
    public init(bodyText: String, illustrationName: String, dialogueIDs: [String] = []) {
        self.bodyText = bodyText
        self.illustrationName = illustrationName
        self.dialogueIDs = dialogueIDs
    }
}

// MARK: - Exercise Types
public enum ExerciseType: String, Codable, CaseIterable, Hashable {
    case multipleChoice = "multipleChoice"
    case fillBlank = "fillBlank"
    case translate = "translate"
    case wordOrder = "wordOrder"
    case dialoguePick = "dialoguePick"
    case conversationSim = "conversationSim"
    case errorCorrection = "errorCorrection"
    case storyQuiz = "storyQuiz"
    case sentenceBuilder = "sentenceBuilder"
    case grammarParsing = "grammarParsing"
}

public struct Exercise: Codable, Identifiable, Hashable {
    public let id: String
    public let type: ExerciseType
    public let prompt: String
    public let correctAnswer: String
    public let options: [String]
    public let words: [String] // Used for wordOrder, sentenceBuilder, etc.
    public let hint: String?
    public let grammaticalBreakdown: String?
    public let grammarRule: String?
    
    public init(
        id: String,
        type: ExerciseType,
        prompt: String,
        correctAnswer: String,
        options: [String] = [],
        words: [String] = [],
        hint: String? = nil,
        grammaticalBreakdown: String? = nil,
        grammarRule: String? = nil
    ) {
        self.id = id
        self.type = type
        self.prompt = prompt
        self.correctAnswer = correctAnswer
        self.options = options
        self.words = words
        self.hint = hint
        self.grammaticalBreakdown = grammaticalBreakdown
        self.grammarRule = grammarRule
    }
}

// MARK: - Lesson & Module Structure
public struct Lesson: Codable, Identifiable, Hashable {
    public let id: String
    public let moduleID: String
    public let title: String
    public let estimatedMinutes: Int
    public let vocabItems: [VocabItem]
    public let culturalContextCard: CulturalContextCard?
    public let dialogues: [Dialogue]
    public let exercises: [Exercise]
    public let characterIDs: [String]
    public let eliteOnly: Bool
    public let grammarOverview: String?
    
    public init(
        id: String,
        moduleID: String,
        title: String,
        estimatedMinutes: Int,
        vocabItems: [VocabItem],
        culturalContextCard: CulturalContextCard? = nil,
        dialogues: [Dialogue] = [],
        exercises: [Exercise] = [],
        characterIDs: [String] = [],
        eliteOnly: Bool = false,
        grammarOverview: String? = nil
    ) {
        self.id = id
        self.moduleID = moduleID
        self.title = title
        self.estimatedMinutes = estimatedMinutes
        self.vocabItems = vocabItems
        self.culturalContextCard = culturalContextCard
        self.dialogues = dialogues
        self.exercises = exercises
        self.characterIDs = characterIDs
        self.eliteOnly = eliteOnly
        self.grammarOverview = grammarOverview
    }
}

public struct Module: Codable, Identifiable, Hashable {
    public let id: String
    public let categoryID: String
    public let title: String
    public let subtitle: String
    public let lessonIDs: [String]
    public let bossLevelID: String
    public let elitePhraseIDs: [String]
    public let unlockRequirement: String?
    public let wordCount: Int
    
    public init(
        id: String,
        categoryID: String,
        title: String,
        subtitle: String,
        lessonIDs: [String],
        bossLevelID: String,
        elitePhraseIDs: [String] = [],
        unlockRequirement: String? = nil,
        wordCount: Int
    ) {
        self.id = id
        self.categoryID = categoryID
        self.title = title
        self.subtitle = subtitle
        self.lessonIDs = lessonIDs
        self.bossLevelID = bossLevelID
        self.elitePhraseIDs = elitePhraseIDs
        self.unlockRequirement = unlockRequirement
        self.wordCount = wordCount
    }
}

// MARK: - Boss Levels
public enum BossRoundType: String, Codable, CaseIterable, Hashable {
    case speedRecognition = "speedRecognition"
    case sentenceReconstruction = "sentenceReconstruction"
    case scenario = "scenario"
    case errorHunter = "errorHunter"
    case translationSprint = "translationSprint"
}

public struct BossRound: Codable, Hashable {
    public let number: Int
    public let type: BossRoundType
    public let itemCount: Int
    public let timePerItemSeconds: Double
    
    public init(number: Int, type: BossRoundType, itemCount: Int, timePerItemSeconds: Double) {
        self.number = number
        self.type = type
        self.itemCount = itemCount
        self.timePerItemSeconds = timePerItemSeconds
    }
}

public struct BossLevel: Codable, Identifiable, Hashable {
    public let id: String
    public let moduleID: String
    public let rounds: [BossRound]
    public let passThreshold: Double // E.g., 0.8
    public let partialThreshold: Double // E.g., 0.6
    
    public init(id: String, moduleID: String, rounds: [BossRound], passThreshold: Double = 0.8, partialThreshold: Double = 0.6) {
        self.id = id
        self.moduleID = moduleID
        self.rounds = rounds
        self.passThreshold = passThreshold
        self.partialThreshold = partialThreshold
    }
}

// MARK: - Swedish Verb Conjugation
public struct SwedishVerb: Codable, Identifiable, Hashable {
    public let id: String
    public let infinitive: String
    public let present: String
    public let past: String
    public let supinum: String
    public let imperative: String
    public let english: String
    public let group: String
    public let exPresent: String       // "Jag äter lunch."
    public let exPresentEn: String     // "I eat lunch."
    public let exPast: String          // "Jag åt lunch."
    public let exPastEn: String        // "I ate lunch."
    public let exSupinum: String       // "Jag har ätit lunch."
    public let exSupinumEn: String     // "I have eaten lunch."
    
    public init(id: String, infinitive: String, present: String, past: String, supinum: String, imperative: String, english: String, group: String,
                exPresent: String, exPresentEn: String, exPast: String, exPastEn: String, exSupinum: String, exSupinumEn: String) {
        self.id = id; self.infinitive = infinitive; self.present = present; self.past = past
        self.supinum = supinum; self.imperative = imperative; self.english = english; self.group = group
        self.exPresent = exPresent; self.exPresentEn = exPresentEn
        self.exPast = exPast; self.exPastEn = exPastEn
        self.exSupinum = exSupinum; self.exSupinumEn = exSupinumEn
    }
}

extension VocabItem {
    public var verbConjugation: SwedishVerb? {
        VerbData.allVerbs.first { $0.infinitive.lowercased() == self.swedish.lowercased() }
    }
}

// MARK: - SFI Exam Models
public struct SFIExamSection: Codable, Identifiable, Hashable {
    public let id: String
    public let title: String
    public let timeLimitSeconds: Int
    public let exercises: [Exercise]
    
    public init(id: String, title: String, timeLimitSeconds: Int, exercises: [Exercise]) {
        self.id = id
        self.title = title
        self.timeLimitSeconds = timeLimitSeconds
        self.exercises = exercises
    }
}

public struct SFIExam: Codable, Identifiable, Hashable {
    public let id: String
    public let courseLevel: String
    public let title: String
    public let sections: [SFIExamSection]
    public let passingScore: Double
    
    public init(id: String, courseLevel: String, title: String, sections: [SFIExamSection], passingScore: Double = 0.7) {
        self.id = id
        self.courseLevel = courseLevel
        self.title = title
        self.sections = sections
        self.passingScore = passingScore
    }
    
    public var totalQuestions: Int {
        sections.reduce(0) { $0 + $1.exercises.count }
    }
}
