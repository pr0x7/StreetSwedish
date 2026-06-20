# SFI Course C/D Curriculum & Exams Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add SFI Course C and D exams to the app with timed sections, score tracking, and pass/fail results accessible from the existing SFI Hub.

**Architecture:** We add new exam model structs (`SFIExam`, `SFIExamSection`) in LearningModels.swift, create exam data in a new `SFIExamData.swift` file, add score tracking to ProgressManager, build an `SFIExamView` for the timed exam experience, and update `SFIHubView` with exam navigation cards.

**Tech Stack:** Swift 5.8+, SwiftUI, iOS 16+

## Global Constraints
- Do not introduce external dependencies.
- Follow the existing SwiftUI styling, color extensions (e.g., Color.appBackground, Color.appSurface, Color.primaryGold), and typography systems (`.sfRounded`, `.sfStandard`).
- Initializers must maintain backward-compatible default parameters.
- Verify compiling status by ensuring zero syntax errors in code.
- Reuse existing `Exercise` struct and `ExerciseRouter` for rendering individual exam questions.
- The existing `ProgressManager` manages a `UserProgress` struct stored via `@AppStorage`. New fields added to it must have default values.

---

### Task 1: Add SFI Exam Models and Progress Tracking

**Files:**
- Modify: `StreetSwedish/Models/LearningModels.swift`
- Modify: `StreetSwedish/Engine/ProgressManager.swift`

**Interfaces:**
- Consumes: None
- Produces: `SFIExamSection`, `SFIExam` structs; `sfiExamScores: [String: Double]` in `UserProgress`

- [ ] **Step 1: Add SFI exam model structs**
  At the bottom of `StreetSwedish/Models/LearningModels.swift` (before the final `VocabItem` extension), add:
  ```swift
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
      public let courseLevel: String // "C" or "D"
      public let title: String
      public let sections: [SFIExamSection]
      public let passingScore: Double // 0.0 to 1.0
      
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
  ```

- [ ] **Step 2: Add sfiExamScores to UserProgress**
  In `StreetSwedish/Engine/ProgressManager.swift`, locate the `UserProgress` struct. Add a new property:
  ```swift
  public var sfiExamScores: [String: Double] = [:]
  ```
  This stores `examID -> bestScore` mapping. Since it has a default value `= [:]`, existing encoded data will decode with this default (backward compatible).

- [ ] **Step 3: Add helper methods to ProgressManager**
  In `ProgressManager`, add these convenience methods:
  ```swift
  public func recordExamScore(examID: String, score: Double) {
      let currentBest = progress.sfiExamScores[examID] ?? 0.0
      if score > currentBest {
          progress.sfiExamScores[examID] = score
          save()
      }
  }
  
  public func examBestScore(examID: String) -> Double? {
      return progress.sfiExamScores[examID]
  }
  ```

- [ ] **Step 4: Commit changes**
  ```bash
  git add StreetSwedish/Models/LearningModels.swift StreetSwedish/Engine/ProgressManager.swift
  git commit -m "feat: add SFI exam models and score tracking"
  ```

---

### Task 2: Create SFI Exam Data

**Files:**
- Create: `StreetSwedish/Data/SFIExamData.swift`

**Interfaces:**
- Consumes: `SFIExam`, `SFIExamSection`, `Exercise` models from Task 1
- Produces: `SFIExamData.courseCExam` and `SFIExamData.courseDExam` static properties

- [ ] **Step 1: Create SFIExamData.swift**
  Create `StreetSwedish/Data/SFIExamData.swift` with the following content:
  ```swift
  import Foundation

  public struct SFIExamData {
      
      // MARK: - Course C Exam (B1 Level)
      public static let courseCExam = SFIExam(
          id: "sfi_exam_c",
          courseLevel: "C",
          title: "SFI Kurs C Prov",
          sections: [
              SFIExamSection(
                  id: "sfi_c_reading",
                  title: "Läsförståelse (Reading)",
                  timeLimitSeconds: 180,
                  exercises: [
                      Exercise(
                          id: "sfi_c_r1",
                          type: .multipleChoice,
                          prompt: "Anna bor i Stockholm. Hon jobbar på ett café. Hon tycker om att träffa nya människor.\n\nVad jobbar Anna med?",
                          correctAnswer: "Hon jobbar på ett café",
                          options: ["Hon jobbar på ett kontor", "Hon jobbar på ett café", "Hon jobbar hemma", "Hon studerar på universitetet"]
                      ),
                      Exercise(
                          id: "sfi_c_r2",
                          type: .multipleChoice,
                          prompt: "Idag är det måndag. Erik ska handla mat efter jobbet. Han behöver mjölk, bröd och ost.\n\nNär ska Erik handla?",
                          correctAnswer: "Efter jobbet",
                          options: ["På morgonen", "På lunchen", "Efter jobbet", "På helgen"]
                      ),
                      Exercise(
                          id: "sfi_c_r3",
                          type: .multipleChoice,
                          prompt: "Bussen avgår klockan 8:15 från Centralstationen. Resan tar 45 minuter.\n\nNär kommer bussen fram?",
                          correctAnswer: "Klockan 9:00",
                          options: ["Klockan 8:45", "Klockan 9:00", "Klockan 9:15", "Klockan 8:30"]
                      ),
                      Exercise(
                          id: "sfi_c_r4",
                          type: .multipleChoice,
                          prompt: "Biblioteket är öppet måndag till fredag 10-18. På lördagar 10-14. Stängt på söndagar.\n\nKan man besöka biblioteket på söndag?",
                          correctAnswer: "Nej, det är stängt",
                          options: ["Ja, 10-18", "Ja, 10-14", "Nej, det är stängt", "Bara på förmiddagen"]
                      ),
                      Exercise(
                          id: "sfi_c_r5",
                          type: .multipleChoice,
                          prompt: "Sara har ont i halsen. Hon ringer till vårdcentralen. De säger att hon kan komma klockan 14.\n\nVarför ringer Sara?",
                          correctAnswer: "Hon är sjuk",
                          options: ["Hon vill boka semester", "Hon är sjuk", "Hon söker jobb", "Hon vill handla medicin"]
                      )
                  ]
              ),
              SFIExamSection(
                  id: "sfi_c_grammar",
                  title: "Grammatik (Grammar)",
                  timeLimitSeconds: 180,
                  exercises: [
                      Exercise(
                          id: "sfi_c_g1",
                          type: .fillBlank,
                          prompt: "Jag ______ till jobbet varje dag.",
                          correctAnswer: "åker",
                          options: ["åker", "åkte", "åkt", "åka"]
                      ),
                      Exercise(
                          id: "sfi_c_g2",
                          type: .fillBlank,
                          prompt: "Det är ______ hus. (a/an)",
                          correctAnswer: "ett",
                          options: ["en", "ett", "den", "det"]
                      ),
                      Exercise(
                          id: "sfi_c_g3",
                          type: .fillBlank,
                          prompt: "Igår ______ vi på bio.",
                          correctAnswer: "var",
                          options: ["är", "var", "varit", "vara"]
                      ),
                      Exercise(
                          id: "sfi_c_g4",
                          type: .fillBlank,
                          prompt: "Hon har ______ hela dagen.",
                          correctAnswer: "jobbat",
                          options: ["jobba", "jobbade", "jobbat", "jobbar"]
                      ),
                      Exercise(
                          id: "sfi_c_g5",
                          type: .fillBlank,
                          prompt: "Barnen leker i ______ trädgården.",
                          correctAnswer: "den",
                          options: ["en", "den", "ett", "det"]
                      )
                  ]
              ),
              SFIExamSection(
                  id: "sfi_c_vocab",
                  title: "Ordförråd (Vocabulary)",
                  timeLimitSeconds: 180,
                  exercises: [
                      Exercise(
                          id: "sfi_c_v1",
                          type: .translate,
                          prompt: "Translate: 'Jag behöver hjälp'",
                          correctAnswer: "I need help",
                          hint: "behöver = need, hjälp = help"
                      ),
                      Exercise(
                          id: "sfi_c_v2",
                          type: .translate,
                          prompt: "Translate: 'Var ligger närmaste busshållplats?'",
                          correctAnswer: "Where is the nearest bus stop?",
                          hint: "närmaste = nearest, busshållplats = bus stop"
                      ),
                      Exercise(
                          id: "sfi_c_v3",
                          type: .translate,
                          prompt: "Translate: 'Tack så mycket för hjälpen'",
                          correctAnswer: "Thank you so much for the help",
                          hint: "Tack = thanks, hjälpen = the help"
                      ),
                      Exercise(
                          id: "sfi_c_v4",
                          type: .translate,
                          prompt: "Translate: 'Hur mycket kostar det?'",
                          correctAnswer: "How much does it cost?",
                          hint: "kostar = costs"
                      ),
                      Exercise(
                          id: "sfi_c_v5",
                          type: .translate,
                          prompt: "Translate: 'Jag förstår inte'",
                          correctAnswer: "I do not understand",
                          hint: "förstår = understand, inte = not"
                      )
                  ]
              )
          ],
          passingScore: 0.6
      )
      
      // MARK: - Course D Exam (B2 Level)
      public static let courseDExam = SFIExam(
          id: "sfi_exam_d",
          courseLevel: "D",
          title: "SFI Kurs D Prov",
          sections: [
              SFIExamSection(
                  id: "sfi_d_reading",
                  title: "Läsförståelse (Reading)",
                  timeLimitSeconds: 240,
                  exercises: [
                      Exercise(
                          id: "sfi_d_r1",
                          type: .multipleChoice,
                          prompt: "Arbetsförmedlingen erbjuder stöd till arbetssökande genom individuella handlingsplaner, praktikplatser och utbildningar. Syftet är att hjälpa människor att hitta ett arbete som matchar deras kompetens.\n\nVad är huvudsyftet med Arbetsförmedlingens stöd?",
                          correctAnswer: "Att matcha arbetssökande med rätt arbete",
                          options: ["Att ge alla samma jobb", "Att matcha arbetssökande med rätt arbete", "Att erbjuda gratis utbildning", "Att betala ut a-kassa"]
                      ),
                      Exercise(
                          id: "sfi_d_r2",
                          type: .multipleChoice,
                          prompt: "Enligt kollektivavtalet har anställda rätt till minst 25 semesterdagar per år. Semesterlön betalas ut under ledigheten och beräknas utifrån den ordinarie lönen.\n\nHur många semesterdagar har man minst rätt till?",
                          correctAnswer: "25 dagar",
                          options: ["20 dagar", "25 dagar", "30 dagar", "15 dagar"]
                      ),
                      Exercise(
                          id: "sfi_d_r3",
                          type: .multipleChoice,
                          prompt: "Diskriminering i arbetslivet innebär att någon behandlas sämre på grund av kön, ålder, etnisk tillhörighet eller funktionsnedsättning. Diskrimineringsombudsmannen (DO) tar emot anmälningar.\n\nVad gör DO?",
                          correctAnswer: "Tar emot anmälningar om diskriminering",
                          options: ["Anställer nya medarbetare", "Tar emot anmälningar om diskriminering", "Skriver nya lagar", "Betalar ut skadestånd"]
                      ),
                      Exercise(
                          id: "sfi_d_r4",
                          type: .multipleChoice,
                          prompt: "Fackföreningar förhandlar om löner och arbetsvillkor å medlemmarnas vägnar. I Sverige är ungefär 70% av alla arbetstagare fackligt anslutna.\n\nVad förhandlar fackföreningar om?",
                          correctAnswer: "Löner och arbetsvillkor",
                          options: ["Semesterresor", "Löner och arbetsvillkor", "Bostadspriser", "Skattenivåer"]
                      ),
                      Exercise(
                          id: "sfi_d_r5",
                          type: .multipleChoice,
                          prompt: "En provanställning kan vara högst sex månader. Under provanställningen kan både arbetsgivaren och den anställde avsluta anställningen utan särskilda skäl.\n\nHur länge kan en provanställning vara?",
                          correctAnswer: "Högst sex månader",
                          options: ["Tre månader", "Högst sex månader", "Ett år", "Två månader"]
                      )
                  ]
              ),
              SFIExamSection(
                  id: "sfi_d_grammar",
                  title: "Grammatik & Ordföljd (Grammar & Word Order)",
                  timeLimitSeconds: 240,
                  exercises: [
                      Exercise(
                          id: "sfi_d_g1",
                          type: .wordOrder,
                          prompt: "Build: 'Tomorrow I will start my new job'",
                          correctAnswer: "Imorgon börjar jag mitt nya jobb",
                          words: ["jag", "börjar", "mitt", "nya", "jobb", "Imorgon"]
                      ),
                      Exercise(
                          id: "sfi_d_g2",
                          type: .fillBlank,
                          prompt: "Om jag ______ tid, skulle jag studera mer.",
                          correctAnswer: "hade",
                          options: ["har", "hade", "haft", "ha"]
                      ),
                      Exercise(
                          id: "sfi_d_g3",
                          type: .fillBlank,
                          prompt: "Det var en ______ bok som jag läste förra veckan.",
                          correctAnswer: "intressant",
                          options: ["intressant", "intressanta", "intressante", "intressants"]
                      ),
                      Exercise(
                          id: "sfi_d_g4",
                          type: .wordOrder,
                          prompt: "Build: 'At the meeting we discussed the budget'",
                          correctAnswer: "På mötet diskuterade vi budgeten",
                          words: ["vi", "diskuterade", "budgeten", "På mötet"]
                      ),
                      Exercise(
                          id: "sfi_d_g5",
                          type: .fillBlank,
                          prompt: "Hon berättade att hon ______ bott i Sverige i fem år.",
                          correctAnswer: "hade",
                          options: ["har", "hade", "har haft", "haft"]
                      )
                  ]
              ),
              SFIExamSection(
                  id: "sfi_d_vocab",
                  title: "Ordförråd & Översättning (Vocabulary & Translation)",
                  timeLimitSeconds: 240,
                  exercises: [
                      Exercise(
                          id: "sfi_d_v1",
                          type: .translate,
                          prompt: "Translate: 'Jag vill ansöka om uppehållstillstånd'",
                          correctAnswer: "I want to apply for a residence permit",
                          hint: "ansöka = apply, uppehållstillstånd = residence permit"
                      ),
                      Exercise(
                          id: "sfi_d_v2",
                          type: .translate,
                          prompt: "Translate: 'Kan du förklara vad kollektivavtal innebär?'",
                          correctAnswer: "Can you explain what a collective agreement means?",
                          hint: "förklara = explain, kollektivavtal = collective agreement"
                      ),
                      Exercise(
                          id: "sfi_d_v3",
                          type: .translate,
                          prompt: "Translate: 'Arbetsgivaren erbjöd mig fast anställning'",
                          correctAnswer: "The employer offered me permanent employment",
                          hint: "arbetsgivaren = employer, fast anställning = permanent employment"
                      ),
                      Exercise(
                          id: "sfi_d_v4",
                          type: .translate,
                          prompt: "Translate: 'Facket förhandlar om bättre arbetsvillkor'",
                          correctAnswer: "The union negotiates for better working conditions",
                          hint: "facket = the union, arbetsvillkor = working conditions"
                      ),
                      Exercise(
                          id: "sfi_d_v5",
                          type: .translate,
                          prompt: "Translate: 'Skattedeklarationen ska lämnas in senast den 2 maj'",
                          correctAnswer: "The tax declaration must be submitted by May 2nd at the latest",
                          hint: "skattedeklarationen = tax declaration, lämnas in = submitted"
                      )
                  ]
              )
          ],
          passingScore: 0.7
      )
      
      public static let allExams: [SFIExam] = [courseCExam, courseDExam]
  }
  ```

- [ ] **Step 2: Commit changes**
  ```bash
  git add StreetSwedish/Data/SFIExamData.swift
  git commit -m "feat: add SFI Course C and D exam data"
  ```

---

### Task 3: Implement SFI Exam View

**Files:**
- Create: `StreetSwedish/Views/SFI/SFIExamView.swift`

**Interfaces:**
- Consumes: `SFIExam` data, `ExerciseRouter` for question rendering, `ProgressManager` for score saving
- Produces: Full timed exam experience with results screen

- [ ] **Step 1: Create SFIExamView.swift**
  Create `StreetSwedish/Views/SFI/SFIExamView.swift` with the exam UI. Key requirements:
  
  The view receives an `SFIExam` and manages exam state:
  - `@State private var currentSectionIndex: Int = 0`
  - `@State private var currentQuestionIndex: Int = 0`
  - `@State private var correctAnswers: Int = 0`
  - `@State private var sectionCorrect: [String: Int] = [:]` — tracks correct per section
  - `@State private var timeRemaining: Int` — countdown timer for current section
  - `@State private var timer: Timer?` — the Timer publisher
  - `@State private var answeredCorrectly: Bool? = nil`
  - `@State private var shakeTrigger: Bool = false`
  - `@State private var examFinished: Bool = false`
  - `@State private var showingTimeUpAlert: Bool = false`

  The view layout:
  ```swift
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
          .onDisappear {
              stopTimer()
          }
      }
      
      // MARK: - Exam Content
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
      }
      
      // MARK: - Results
      private func resultsView() -> some View {
          ScrollView {
              VStack(spacing: 28) {
                  // Score icon
                  let score = Double(correctAnswers) / Double(exam.totalQuestions)
                  let passed = score >= exam.passingScore
                  
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
          stopTimer()
          Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
              if timeRemaining > 0 {
                  timeRemaining -= 1
              } else {
                  t.invalidate()
                  advanceToNextSection()
              }
          }
      }
      
      private func stopTimer() {
          // Timer stops itself on invalidation
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
          examFinished = true
          let score = Double(correctAnswers) / Double(exam.totalQuestions)
          progressManager.recordExamScore(examID: exam.id, score: score)
      }
  }
  ```

- [ ] **Step 2: Commit changes**
  ```bash
  git add StreetSwedish/Views/SFI/SFIExamView.swift
  git commit -m "feat: implement SFI exam view with timer and results"
  ```

---

### Task 4: Update SFI Hub with Exam Navigation

**Files:**
- Modify: `StreetSwedish/Views/SFI/SFIHubView.swift`

**Interfaces:**
- Consumes: `SFIExamData`, `SFIExamView`, `ProgressManager.examBestScore()`
- Produces: Course C and Course D exam cards in SFI Hub

- [ ] **Step 1: Add exam cards to SFIHubView**
  In `StreetSwedish/Views/SFI/SFIHubView.swift`, locate the `VStack(spacing: 20)` inside the ScrollView (after the Verbs Card NavigationLink around line 54). Add two new NavigationLinks for the exams before the closing `}` of the VStack:
  ```swift
  // Divider
  HStack {
      VStack { Divider().background(Color.textMuted.opacity(0.3)) }
      Text(progressManager.loc("EXAMS", "PROV"))
          .font(.sfRounded(size: 11, weight: .black))
          .foregroundColor(.textMuted)
          .tracking(1.5)
      VStack { Divider().background(Color.textMuted.opacity(0.3)) }
  }
  .padding(.horizontal, 20)
  .padding(.top, 8)
  
  // Course C Exam
  NavigationLink(destination: SFIExamView(exam: SFIExamData.courseCExam)) {
      examCard(
          exam: SFIExamData.courseCExam,
          icon: "doc.text.fill",
          iconColor: .appSuccess,
          subtitle: progressManager.loc("Everyday Swedish — Reading, Grammar & Vocabulary", "Vardagssvenska — Läsning, Grammatik & Ordförråd")
      )
  }
  
  // Course D Exam
  NavigationLink(destination: SFIExamView(exam: SFIExamData.courseDExam)) {
      examCard(
          exam: SFIExamData.courseDExam,
          icon: "doc.text.fill",
          iconColor: .primaryBlue,
          subtitle: progressManager.loc("Workplace Swedish — Advanced Reading & Grammar", "Arbetssvenska — Avancerad Läsning & Grammatik")
      )
  }
  ```

- [ ] **Step 2: Add examCard helper method**
  Add a new helper method `examCard` inside `SFIHubView`, below the existing `sfiCard` method:
  ```swift
  private func examCard(exam: SFIExam, icon: String, iconColor: Color, subtitle: String) -> some View {
      HStack(spacing: 16) {
          Circle()
              .fill(iconColor.opacity(0.15))
              .frame(width: 56, height: 56)
              .overlay(
                  Image(systemName: icon)
                      .font(.system(size: 24))
                      .foregroundColor(iconColor)
              )
          
          VStack(alignment: .leading, spacing: 4) {
              HStack(spacing: 8) {
                  Text(progressManager.loc("Course \(exam.courseLevel) Exam", "Kurs \(exam.courseLevel) Prov"))
                      .font(.sfRounded(size: 20, weight: .bold))
                      .foregroundColor(.textPrimary)
                  
                  if let best = progressManager.examBestScore(examID: exam.id), best >= exam.passingScore {
                      Image(systemName: "checkmark.seal.fill")
                          .font(.system(size: 16))
                          .foregroundColor(.appSuccess)
                  }
              }
              Text(subtitle)
                  .font(.sfStandard(size: 13))
                  .foregroundColor(.textSecondary)
                  .lineLimit(2)
          }
          
          Spacer()
          
          VStack(spacing: 4) {
              Text("\(exam.totalQuestions) \(progressManager.loc("Q", "F"))")
                  .font(.sfRounded(size: 11, weight: .bold))
                  .foregroundColor(iconColor)
                  .padding(.horizontal, 10)
                  .padding(.vertical, 5)
                  .background(iconColor.opacity(0.12))
                  .cornerRadius(8)
              Image(systemName: "chevron.right")
                  .font(.caption)
                  .foregroundColor(.textMuted)
          }
      }
      .padding(20)
      .background(Color.appSurface)
      .cornerRadius(20)
      .padding(.horizontal, 20)
  }
  ```

- [ ] **Step 3: Commit changes**
  ```bash
  git add StreetSwedish/Views/SFI/SFIHubView.swift
  git commit -m "feat: add SFI exam cards to hub with pass badges"
  ```
