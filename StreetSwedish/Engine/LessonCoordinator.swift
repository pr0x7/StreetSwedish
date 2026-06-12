import Foundation
import Combine

public final class LessonCoordinator: ObservableObject {
    public let lesson: Lesson
    
    // Act & Step tracking
    @Published public var currentAct: LessonAct = .sceneSetting
    @Published public var currentStepIndex: Int = 0
    
    // UI Feedback state
    @Published public var answeredCorrectly: Bool? = nil
    @Published public var shakeTrigger: Bool = false
    @Published public var selectedOption: String? = nil
    
    // Lesson completion
    @Published public var xpEarned: Int = 0
    @Published public var isCompleted: Bool = false
    @Published public var showCelebration: Bool = false
    
    // Dialogue roleplay state
    @Published public var userSpeakerID: String? = nil // Speaker ID the user is roleplaying (Act 5)
    
    // Filtered lists for current lesson
    public var recognitionExercises: [Exercise] = []
    public var contextExercises: [Exercise] = []
    public var dialogueLines: [DialogueLine] = []
    
    public init(lesson: Lesson) {
        self.lesson = lesson
        setupExercisesAndDialogue()
    }
    
    // MARK: - Setup
    private func setupExercisesAndDialogue() {
        // Recognition: Multiple choice and dialogue pick
        self.recognitionExercises = lesson.exercises.filter { 
            $0.type == .multipleChoice || $0.type == .dialoguePick 
        }
        // Fallback: If lesson has no specific recognition exercises, take first 4
        if self.recognitionExercises.isEmpty {
            self.recognitionExercises = Array(lesson.exercises.prefix(4))
        }
        
        // Context: Word order, fill blank, translate, builder, etc.
        self.contextExercises = lesson.exercises.filter {
            $0.type != .multipleChoice && $0.type != .dialoguePick
        }
        // Fallback: If empty, use remaining exercises
        if self.contextExercises.isEmpty {
            self.contextExercises = Array(lesson.exercises.dropFirst(4))
        }
        
        // Dialogue lines
        if let firstDialogue = lesson.dialogues.first {
            self.dialogueLines = firstDialogue.lines
            // User roleplays the second speaker (e.g. Maja/Erik), or a default
            if firstDialogue.lines.count > 1 {
                self.userSpeakerID = firstDialogue.lines[1].speakerID
            }
        }
    }
    
    // MARK: - Navigation / Progress
    public var totalStepsInCurrentAct: Int {
        switch currentAct {
        case .sceneSetting:
            return 1
        case .wordIntroductions:
            return lesson.vocabItems.count
        case .recognitionDrill:
            return recognitionExercises.count
        case .contextDrill:
            return contextExercises.count
        case .miniDialogue:
            return dialogueLines.count
        case .lessonSummary:
            return 1
        }
    }
    
    public var totalStepsInLesson: Int {
        // Act 1: 1
        // Act 2: vocab count
        // Act 3: recognition count
        // Act 4: context count
        // Act 5: dialogue count
        // Act 6: 1
        return 1 + lesson.vocabItems.count + recognitionExercises.count + contextExercises.count + dialogueLines.count + 1
    }
    
    public var absoluteStepOffset: Int {
        var offset = 0
        
        // Prior Acts
        if currentAct.rawValue > 1 { offset += 1 } // Scene Setting
        if currentAct.rawValue > 2 { offset += lesson.vocabItems.count }
        if currentAct.rawValue > 3 { offset += recognitionExercises.count }
        if currentAct.rawValue > 4 { offset += contextExercises.count }
        if currentAct.rawValue > 5 { offset += dialogueLines.count }
        
        // Current Act
        offset += currentStepIndex
        return offset
    }
    
    public var progressFraction: Double {
        return Double(absoluteStepOffset) / Double(totalStepsInLesson)
    }
    
    // MARK: - Act flow
    public func nextStep(onComplete: @escaping (Int) -> Void) {
        // Reset answer feedback state
        self.answeredCorrectly = nil
        self.selectedOption = nil
        
        if currentStepIndex < totalStepsInCurrentAct - 1 {
            // Next step in current Act
            currentStepIndex += 1
        } else {
            // Transition to next Act
            guard let nextAct = LessonAct(rawValue: currentAct.rawValue + 1) else {
                // End of Lesson (Act 6 completed)
                finishLesson(onComplete: onComplete)
                return
            }
            currentAct = nextAct
            currentStepIndex = 0
        }
    }
    
    private func finishLesson(onComplete: (Int) -> Void) {
        self.isCompleted = true
        self.showCelebration = true
        // Earned XP: 50 XP base + 10 XP per exercise
        let baseXP = 50
        let exerciseBonus = (recognitionExercises.count + contextExercises.count) * 10
        self.xpEarned = baseXP + exerciseBonus
        
        onComplete(self.xpEarned)
    }
    
    // MARK: - Exercise Validation
    public func submitAnswer(
        answer: String,
        scheduler: SRSScheduler,
        onSuccess: @escaping () -> Void
    ) {
        guard let exercise = currentExercise else { return }
        
        // Clean strings for fuzzy comparison (lowercase, trimmed)
        let cleanAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanCorrect = exercise.correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let isCorrect = cleanAnswer == cleanCorrect
        
        if isCorrect {
            self.answeredCorrectly = true
            
            // Advance any relevant vocab items in SRS
            // For lessons, we find which vocab items match this exercise and boost them
            promoteVocabForExercise(exerciseID: exercise.id, scheduler: scheduler)
            
            // Success callback (e.g., sound feedback or trigger auto-advance after 0.8s)
            onSuccess()
        } else {
            self.answeredCorrectly = false
            self.shakeTrigger = true
            
            // Reset shake trigger quickly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.shakeTrigger = false
            }
            
            // Demote vocab in SRS
            demoteVocabForExercise(exerciseID: exercise.id, scheduler: scheduler)
        }
    }
    
    private func promoteVocabForExercise(exerciseID: String, scheduler: SRSScheduler) {
        // Find if the exercise prompt or correction matches any vocabulary in the current lesson
        for vocab in lesson.vocabItems {
            if exerciseID.contains(vocab.id) || exerciseContainsWord(vocab: vocab) {
                scheduler.recordResponse(itemID: vocab.id, isCorrect: true, responseQuality: 1.0)
            }
        }
    }
    
    private func demoteVocabForExercise(exerciseID: String, scheduler: SRSScheduler) {
        for vocab in lesson.vocabItems {
            if exerciseID.contains(vocab.id) || exerciseContainsWord(vocab: vocab) {
                scheduler.recordResponse(itemID: vocab.id, isCorrect: false, responseQuality: 0.0)
            }
        }
    }
    
    private func exerciseContainsWord(vocab: VocabItem) -> Bool {
        guard let exercise = currentExercise else { return false }
        let swedishWord = vocab.swedish.lowercased()
        
        return exercise.prompt.lowercased().contains(swedishWord) ||
               exercise.correctAnswer.lowercased().contains(swedishWord) ||
               exercise.options.contains(where: { $0.lowercased().contains(swedishWord) }) ||
               exercise.words.contains(where: { $0.lowercased().contains(swedishWord) })
    }
    
    // MARK: - Current getters
    public var currentVocabItem: VocabItem? {
        guard currentAct == .wordIntroductions, currentStepIndex < lesson.vocabItems.count else {
            return nil
        }
        return lesson.vocabItems[currentStepIndex]
    }
    
    public var currentExercise: Exercise? {
        if currentAct == .recognitionDrill, currentStepIndex < recognitionExercises.count {
            return recognitionExercises[currentStepIndex]
        } else if currentAct == .contextDrill, currentStepIndex < contextExercises.count {
            return contextExercises[currentStepIndex]
        }
        return nil
    }
    
    public var currentDialogueLine: DialogueLine? {
        guard currentAct == .miniDialogue, currentStepIndex < dialogueLines.count else {
            return nil
        }
        return dialogueLines[currentStepIndex]
    }
}

// MARK: - LessonAct enum helper
public enum LessonAct: Int, CaseIterable, Codable {
    case sceneSetting = 1
    case wordIntroductions = 2
    case recognitionDrill = 3
    case contextDrill = 4
    case miniDialogue = 5
    case lessonSummary = 6
    
    public var name: String {
        switch self {
        case .sceneSetting: return "1. Introduktion"
        case .wordIntroductions: return "2. Nya ord"
        case .recognitionDrill: return "3. Känna igen"
        case .contextDrill: return "4. Använda ord"
        case .miniDialogue: return "5. Konversation"
        case .lessonSummary: return "6. Sammanfattning"
        }
    }
}
