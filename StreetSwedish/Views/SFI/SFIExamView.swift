import SwiftUI

public struct SFIExamView: View {
    let exam: SFIExam
    @EnvironmentObject var progressManager: ProgressManager
    @Environment(\.dismiss) var dismiss
    
    @State private var currentSectionIndex: Int = 0
    @State private var currentQuestionIndex: Int = 0
    @State private var correctAnswers: Int = 0
    @State private var sectionCorrect: [String: Int] = [:]
    @State private var timeRemaining: Int = 0
    @State private var answeredCorrectly: Bool? = nil
    @State private var shakeTrigger: Bool = false
    @State private var examFinished: Bool = false
    @State private var timerActive: Bool = false
    
    private var currentSection: SFIExamSection? {
        guard currentSectionIndex < exam.sections.count else { return nil }
        return exam.sections[currentSectionIndex]
    }
    
    private var currentExercise: Exercise? {
        guard let section = currentSection, currentQuestionIndex < section.exercises.count else { return nil }
        return section.exercises[currentQuestionIndex]
    }
    
    private var overallProgress: Double {
        let totalQuestions = exam.totalQuestions
        guard totalQuestions > 0 else { return 0 }
        var completed = 0
        for i in 0..<currentSectionIndex {
            completed += exam.sections[i].exercises.count
        }
        completed += currentQuestionIndex
        return Double(completed) / Double(totalQuestions)
    }
    
    public init(exam: SFIExam) {
        self.exam = exam
    }
    
    public var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            if examFinished {
                resultsView()
            } else {
                examContentView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startSectionTimer()
        }
    }
    
    // MARK: - Exam Content
    @ViewBuilder
    private func examContentView() -> some View {
        VStack(spacing: 0) {
            // Top bar with progress and timer
            VStack(spacing: 12) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Section label
                    if let section = currentSection {
                        Text(section.title)
                            .font(.sfRounded(size: 13, weight: .bold))
                            .foregroundColor(.textSecondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    // Timer
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                        Text(timerString)
                            .font(.sfRounded(size: 14, weight: .bold))
                            .monospacedDigit()
                    }
                    .foregroundColor(timeRemaining <= 30 ? .appError : .primaryGold)
                }
                .padding(.horizontal, 20)
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.appSurfaceElevated)
                            .frame(height: 6)
                        Capsule()
                            .fill(Color.primaryGold)
                            .frame(width: geo.size.width * overallProgress, height: 6)
                            .animation(.spring(response: 0.3), value: overallProgress)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 20)
            }
            .padding(.top, 16)
            .padding(.bottom, 12)
            .background(Color.appSurface)
            
            // Question content
            ScrollView {
                VStack(spacing: 24) {
                    // Question counter
                    HStack {
                        Text(progressManager.loc("Question", "Fråga"))
                            .font(.sfRounded(size: 12, weight: .bold))
                            .foregroundColor(.textMuted)
                        Text("\(currentQuestionIndex + 1)/\(currentSection?.exercises.count ?? 0)")
                            .font(.sfRounded(size: 12, weight: .bold))
                            .foregroundColor(.primaryGold)
                        Spacer()
                        Text(progressManager.loc("Section", "Del"))
                            .font(.sfRounded(size: 12, weight: .bold))
                            .foregroundColor(.textMuted)
                        Text("\(currentSectionIndex + 1)/\(exam.sections.count)")
                            .font(.sfRounded(size: 12, weight: .bold))
                            .foregroundColor(.primaryGold)
                    }
                    .padding(.horizontal, 4)
                    
                    // Exercise
                    if let exercise = currentExercise {
                        ExerciseRouter(
                            exercise: exercise,
                            answeredCorrectly: answeredCorrectly,
                            shakeTrigger: shakeTrigger,
                            onAnswerSubmitted: { answer in
                                handleAnswer(answer, exercise: exercise)
                            }
                        )
                    }
                }
                .padding(20)
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard timerActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false
                advanceToNextSection()
            }
        }
    }
    
    // MARK: - Results
    @ViewBuilder
    private func resultsView() -> some View {
        let score = exam.totalQuestions > 0 ? Double(correctAnswers) / Double(exam.totalQuestions) : 0
        let passed = score >= exam.passingScore
        
        ScrollView {
            VStack(spacing: 28) {
                // Score icon
                VStack(spacing: 16) {
                    Image(systemName: passed ? "checkmark.seal.fill" : "xmark.seal.fill")
                        .font(.system(size: 64))
                        .foregroundColor(passed ? .appSuccess : .appError)
                    
                    Text(passed ?
                         progressManager.loc("Exam Passed!", "Provet Godkänt!") :
                         progressManager.loc("Not Passed", "Ej Godkänt"))
                        .font(.sfRounded(size: 28, weight: .black))
                        .foregroundColor(.textPrimary)
                    
                    Text("\(exam.title) — \(progressManager.loc("Course", "Kurs")) \(exam.courseLevel)")
                        .font(.sfRounded(size: 14, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 40)
                
                // Overall score
                VStack(spacing: 8) {
                    Text("\(correctAnswers)/\(exam.totalQuestions)")
                        .font(.sfRounded(size: 44, weight: .black))
                        .foregroundColor(.primaryGold)
                    
                    Text("\(Int(score * 100))%")
                        .font(.sfRounded(size: 18, weight: .bold))
                        .foregroundColor(.textSecondary)
                    
                    Text(progressManager.loc("Passing score: \(Int(exam.passingScore * 100))%", "Godkänt: \(Int(exam.passingScore * 100))%"))
                        .font(.sfStandard(size: 13))
                        .foregroundColor(.textMuted)
                }
                .padding(24)
                .frame(maxWidth: .infinity)
                .background(Color.appSurface)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                
                // Per-section breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text(progressManager.loc("SECTION RESULTS", "DELRESULTAT"))
                        .font(.sfRounded(size: 11, weight: .black))
                        .foregroundColor(.textMuted)
                        .tracking(1.5)
                        .padding(.horizontal, 20)
                    
                    ForEach(exam.sections) { section in
                        let correct = sectionCorrect[section.id] ?? 0
                        let total = section.exercises.count
                        let sectionScore = total > 0 ? Double(correct) / Double(total) : 0
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(section.title)
                                    .font(.sfRounded(size: 15, weight: .bold))
                                    .foregroundColor(.textPrimary)
                                Text("\(correct)/\(total) \(progressManager.loc("correct", "rätt"))")
                                    .font(.sfStandard(size: 13))
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            Text("\(Int(sectionScore * 100))%")
                                .font(.sfRounded(size: 18, weight: .bold))
                                .foregroundColor(sectionScore >= exam.passingScore ? .appSuccess : .appError)
                        }
                        .padding(16)
                        .background(Color.appSurface)
                        .cornerRadius(14)
                        .padding(.horizontal, 20)
                    }
                }
                
                // Close button
                Button(action: { dismiss() }) {
                    Text(progressManager.loc("Close", "Stäng"))
                        .font(.sfRounded(size: 16, weight: .bold))
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.primaryGold)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
    
    // MARK: - Timer
    private var timerString: String {
        let m = timeRemaining / 60
        let s = timeRemaining % 60
        return String(format: "%d:%02d", m, s)
    }
    
    private func startSectionTimer() {
        guard let section = currentSection else { return }
        timeRemaining = section.timeLimitSeconds
        timerActive = true
    }
    
    // MARK: - Answer Handling
    private func handleAnswer(_ answer: String, exercise: Exercise) {
        let clean = answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let correct = exercise.correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let isCorrect = clean == correct
        
        answeredCorrectly = isCorrect
        
        if isCorrect {
            correctAnswers += 1
            let sectionID = currentSection?.id ?? ""
            sectionCorrect[sectionID] = (sectionCorrect[sectionID] ?? 0) + 1
        } else {
            shakeTrigger = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                shakeTrigger = false
            }
        }
        
        // Auto-advance after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            advanceQuestion()
        }
    }
    
    private func advanceQuestion() {
        answeredCorrectly = nil
        guard let section = currentSection else { return }
        
        if currentQuestionIndex < section.exercises.count - 1 {
            currentQuestionIndex += 1
        } else {
            advanceToNextSection()
        }
    }
    
    private func advanceToNextSection() {
        if currentSectionIndex < exam.sections.count - 1 {
            currentSectionIndex += 1
            currentQuestionIndex = 0
            answeredCorrectly = nil
            startSectionTimer()
        } else {
            finishExam()
        }
    }
    
    private func finishExam() {
        timerActive = false
        examFinished = true
        let score = exam.totalQuestions > 0 ? Double(correctAnswers) / Double(exam.totalQuestions) : 0
        progressManager.recordExamScore(examID: exam.id, score: score)
    }
}
