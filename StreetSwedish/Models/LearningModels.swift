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
        relatedItemIDs: [String] = []
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
public struct DialogueLine: Codable, Hashable {
    public let speakerID: String
    public let swedish: String
    public let english: String
    
    public init(speakerID: String, swedish: String, english: String) {
        self.speakerID = speakerID
        self.swedish = swedish
        self.english = english
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
}

public struct Exercise: Codable, Identifiable, Hashable {
    public let id: String
    public let type: ExerciseType
    public let prompt: String
    public let correctAnswer: String
    public let options: [String]
    public let words: [String] // Used for wordOrder, sentenceBuilder, etc.
    public let hint: String?
    
    public init(
        id: String,
        type: ExerciseType,
        prompt: String,
        correctAnswer: String,
        options: [String] = [],
        words: [String] = [],
        hint: String? = nil
    ) {
        self.id = id
        self.type = type
        self.prompt = prompt
        self.correctAnswer = correctAnswer
        self.options = options
        self.words = words
        self.hint = hint
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
        eliteOnly: Bool = false
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
