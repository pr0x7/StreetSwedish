# Interactive Linguistic Parsing Exercises Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a new grammar parsing exercise type that provides detailed grammatical breakdowns after answer submission, teaching users why Swedish sentences are structured a certain way.

**Architecture:** We extend `Exercise` with optional grammar fields, add a `.grammarParsing` case to `ExerciseType`, implement `GrammarParsingView` in ExerciseRouter.swift with an inline breakdown panel, populate grammar exercises in LessonData.swift, and wire it into the ExerciseRouter switch.

**Tech Stack:** Swift 5.8+, SwiftUI, iOS 16+

## Global Constraints
- Do not introduce external dependencies.
- Follow the existing SwiftUI styling, color extensions (e.g., Color.appBackground, Color.appSurface, Color.primaryGold), and typography systems (`.sfRounded`, `.sfStandard`).
- Initializers must maintain backward-compatible default parameters.
- Verify compiling status by ensuring zero syntax errors in code.
- All new exercise views must follow the same signature pattern as existing exercise views: `(exercise: Exercise, answeredCorrectly: Bool?, shakeTrigger: Bool, onAnswerSubmitted: (String) -> Void)`.

---

### Task 1: Extend Exercise Model with Grammar Fields

**Files:**
- Modify: `StreetSwedish/Models/LearningModels.swift`

**Interfaces:**
- Consumes: None
- Produces: `grammaticalBreakdown: String?`, `grammarRule: String?` on `Exercise`; `.grammarParsing` on `ExerciseType`

- [ ] **Step 1: Add `grammarParsing` to ExerciseType**
  In `StreetSwedish/Models/LearningModels.swift`, locate the `ExerciseType` enum (currently ending with `case sentenceBuilder = "sentenceBuilder"`). Add a new case after it:
  ```swift
  case grammarParsing = "grammarParsing"
  ```

- [ ] **Step 2: Add grammar fields to Exercise**
  In `StreetSwedish/Models/LearningModels.swift`, add two new optional properties to the `Exercise` struct after the `hint` property:
  ```swift
  public let grammaticalBreakdown: String?
  public let grammarRule: String?
  ```
  Update the initializer to include these with default `nil` values:
  ```swift
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
  ```

- [ ] **Step 3: Commit changes**
  ```bash
  git add StreetSwedish/Models/LearningModels.swift
  git commit -m "feat: add grammarParsing exercise type and grammar breakdown fields"
  ```

---

### Task 2: Implement GrammarParsingView and Wire Into ExerciseRouter

**Files:**
- Modify: `StreetSwedish/Views/Exercises/ExerciseRouter.swift`

**Interfaces:**
- Consumes: Exercise with `.grammarParsing` type, `grammaticalBreakdown`, `grammarRule`, and `words` fields
- Produces: Interactive grammar exercise UI with post-answer breakdown

- [ ] **Step 1: Add grammarParsing case to ExerciseRouter body**
  In `ExerciseRouter`'s `body` `switch exercise.type`, add a new case after `case .sentenceBuilder:`:
  ```swift
  case .grammarParsing:
      GrammarParsingView(
          exercise: exercise,
          answeredCorrectly: answeredCorrectly,
          shakeTrigger: shakeTrigger,
          onAnswerSubmitted: onAnswerSubmitted
      )
  ```

- [ ] **Step 2: Implement GrammarParsingView**
  At the bottom of `ExerciseRouter.swift` (after the last view struct), add the `GrammarParsingView`. It is a word-order-style exercise but with a grammar breakdown panel that appears after answering:
  ```swift
  // MARK: - 10. Grammar Parsing View
  struct GrammarParsingView: View {
      let exercise: Exercise
      let answeredCorrectly: Bool?
      let shakeTrigger: Bool
      let onAnswerSubmitted: (String) -> Void
      
      @State private var selectedWords: [String] = []
      @State private var poolWords: [String] = []
      @State private var showBreakdown: Bool = false
      
      var body: some View {
          VStack(alignment: .leading, spacing: 20) {
              // Grammar Rule Badge
              if let rule = exercise.grammarRule {
                  HStack(spacing: 6) {
                      Image(systemName: "text.magnifyingglass")
                          .font(.caption)
                      Text(rule.uppercased())
                          .font(.sfRounded(size: 11, weight: .black))
                          .tracking(1.2)
                  }
                  .foregroundColor(.primaryGold)
                  .padding(.horizontal, 12)
                  .padding(.vertical, 6)
                  .background(Color.primaryGold.opacity(0.12))
                  .cornerRadius(8)
              }
              
              Text(exercise.prompt)
                  .font(.sfRounded(size: 18, weight: .semibold))
                  .foregroundColor(.textPrimary)
              
              // Sentence Build Area
              VStack {
                  if selectedWords.isEmpty {
                      Text("Bygg meningen i rätt ordning")
                          .font(.sfStandard(size: 14))
                          .foregroundColor(.textMuted)
                          .frame(maxWidth: .infinity, minHeight: 60)
                  } else {
                      FlowLayout(spacing: 8) {
                          ForEach(Array(selectedWords.enumerated()), id: \.offset) { index, word in
                              Button(action: {
                                  if answeredCorrectly == nil {
                                      removeWord(at: index)
                                  }
                              }) {
                                  Text(word)
                                      .font(.sfRounded(size: 15, weight: .bold))
                                      .foregroundColor(.textPrimary)
                                      .padding(.horizontal, 14)
                                      .padding(.vertical, 8)
                                      .background(Color.primaryBlue)
                                      .cornerRadius(10)
                              }
                              .disabled(answeredCorrectly != nil)
                          }
                      }
                      .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                  }
              }
              .padding(16)
              .frame(maxWidth: .infinity)
              .background(Color.appSurface)
              .cornerRadius(16)
              .overlay(
                  RoundedRectangle(cornerRadius: 16)
                      .stroke(
                          answeredCorrectly == true ? Color.appSuccess :
                          answeredCorrectly == false ? Color.appError : Color.clear,
                          lineWidth: 2
                      )
              )
              .offset(x: (answeredCorrectly == false && shakeTrigger) ? -10 : 0)
              .animation(
                  (answeredCorrectly == false && shakeTrigger) ?
                      .spring(response: 0.12, dampingFraction: 0.2).repeatCount(3, autoreverses: true) :
                      .default,
                  value: shakeTrigger
              )
              
              // Word Pool
              FlowLayout(spacing: 8) {
                  ForEach(Array(poolWords.enumerated()), id: \.offset) { _, word in
                      Button(action: {
                          if answeredCorrectly == nil {
                              addWord(word)
                          }
                      }) {
                          Text(word)
                              .font(.sfRounded(size: 15, weight: .bold))
                              .foregroundColor(.textPrimary)
                              .padding(.horizontal, 14)
                              .padding(.vertical, 8)
                              .background(Color.appSurfaceElevated)
                              .cornerRadius(10)
                      }
                      .disabled(answeredCorrectly != nil)
                  }
              }
              .padding(.vertical, 8)
              
              // Submit Button
              if answeredCorrectly == nil {
                  Button(action: {
                      let fullSentence = selectedWords.joined(separator: " ")
                      onAnswerSubmitted(fullSentence)
                  }) {
                      Text("Kontrollera")
                          .font(.sfRounded(size: 16, weight: .bold))
                          .foregroundColor(.appBackground)
                          .frame(maxWidth: .infinity)
                          .padding(.vertical, 16)
                          .background(selectedWords.isEmpty ? Color.textMuted : Color.primaryGold)
                          .cornerRadius(16)
                  }
                  .disabled(selectedWords.isEmpty)
              }
              
              // Grammar Breakdown Panel (shows after answer)
              if answeredCorrectly != nil, let breakdown = exercise.grammaticalBreakdown {
                  VStack(alignment: .leading, spacing: 12) {
                      HStack(spacing: 8) {
                          Image(systemName: "brain.head.profile")
                              .font(.system(size: 16))
                              .foregroundColor(.primaryGold)
                          Text("GRAMMATISK ANALYS")
                              .font(.sfRounded(size: 11, weight: .black))
                              .foregroundColor(.primaryGold)
                              .tracking(1.5)
                      }
                      
                      // Correct sentence display
                      Text(exercise.correctAnswer)
                          .font(.sfRounded(size: 17, weight: .bold))
                          .foregroundColor(.textPrimary)
                      
                      // Rule name
                      if let rule = exercise.grammarRule {
                          HStack(spacing: 6) {
                              Image(systemName: "lightbulb.fill")
                                  .font(.caption)
                                  .foregroundColor(.accentStreet)
                              Text(rule)
                                  .font(.sfRounded(size: 13, weight: .bold))
                                  .foregroundColor(.accentStreet)
                          }
                      }
                      
                      // Breakdown explanation
                      Text(breakdown)
                          .font(.sfStandard(size: 14))
                          .foregroundColor(.textSecondary)
                          .lineSpacing(4)
                  }
                  .padding(16)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(Color.primaryGold.opacity(0.08))
                  .cornerRadius(16)
                  .overlay(
                      RoundedRectangle(cornerRadius: 16)
                          .stroke(Color.primaryGold.opacity(0.25), lineWidth: 1.5)
                  )
                  .transition(.move(edge: .bottom).combined(with: .opacity))
                  .animation(.spring(response: 0.4, dampingFraction: 0.8), value: answeredCorrectly)
              }
          }
          .onAppear {
              poolWords = exercise.words.shuffled()
          }
      }
      
      private func addWord(_ word: String) {
          if let index = poolWords.firstIndex(of: word) {
              poolWords.remove(at: index)
              selectedWords.append(word)
          }
      }
      
      private func removeWord(at index: Int) {
          let word = selectedWords.remove(at: index)
          poolWords.append(word)
      }
  }
  ```

- [ ] **Step 3: Commit changes**
  ```bash
  git add StreetSwedish/Views/Exercises/ExerciseRouter.swift
  git commit -m "feat: implement GrammarParsingView with inline grammar breakdown"
  ```

---

### Task 3: Populate Grammar Parsing Exercises in Lesson Data

**Files:**
- Modify: `StreetSwedish/Data/LessonData.swift`

**Interfaces:**
- Consumes: Updated Exercise model from Task 1 (`.grammarParsing`, `grammaticalBreakdown`, `grammarRule`)
- Produces: Grammar parsing exercises added to `lesson1Exercises` array

- [ ] **Step 1: Add grammar parsing exercises to lesson1Exercises**
  In `StreetSwedish/Data/LessonData.swift`, locate the `lesson1Exercises` array (around line 1658). Append 3 new grammar parsing exercises at the end of the array (before the closing `]`):
  ```swift
  // Grammar Parsing Exercises
  Exercise(
      id: "ex_l1_gp1",
      type: .grammarParsing,
      prompt: "Build the sentence: 'Yesterday I bought a beer' using Swedish V2 word order",
      correctAnswer: "Igår köpte jag en öl",
      words: ["jag", "köpte", "en öl", "Igår"],
      grammaticalBreakdown: "Position 1 (Fundament): 'Igår' — the time adverb leads the sentence.\nPosition 2 (Verb): 'köpte' — the verb MUST be second (V2 rule).\nPosition 3 (Subject): 'jag' — when a non-subject leads, the subject inverts to after the verb.\nPosition 4 (Object): 'en öl' — the object fills the remaining slot.\n\nThis is INVERSION: because 'Igår' (not the subject) starts the sentence, 'jag' flips behind the verb.",
      grammarRule: "V2-regeln (Verb Second Rule)"
  ),
  Exercise(
      id: "ex_l1_gp2",
      type: .grammarParsing,
      prompt: "Build: 'I eat lunch every day' in Swedish",
      correctAnswer: "Jag äter lunch varje dag",
      words: ["varje", "Jag", "lunch", "äter", "dag"],
      grammaticalBreakdown: "Position 1 (Subject/Fundament): 'Jag' — subject leads, so no inversion needed.\nPosition 2 (Verb): 'äter' — present tense of 'äta' (Group 4 irregular verb, -er ending).\nPosition 3 (Object): 'lunch' — direct object.\nPosition 4 (Adverb): 'varje dag' — time expression at the end.\n\nStandard SVO word order — no inversion because the subject is in first position.",
      grammarRule: "V2-regeln (Standard SVO)"
  ),
  Exercise(
      id: "ex_l1_gp3",
      type: .grammarParsing,
      prompt: "Build: 'On Slack we discuss the code' in Swedish",
      correctAnswer: "På Slack diskuterar vi koden",
      words: ["vi", "diskuterar", "koden", "På Slack"],
      grammaticalBreakdown: "Position 1 (Fundament): 'På Slack' — location/manner adverb leads.\nPosition 2 (Verb): 'diskuterar' — present tense, -ar ending (Group 1 verb).\nPosition 3 (Subject): 'vi' — INVERSION: subject moves after verb because a non-subject started the sentence.\nPosition 4 (Object): 'koden' — 'the code' (definite form: kod + en).\n\nINVERSION again: 'På Slack' occupies the fundament, forcing the verb to position 2 and the subject to position 3.",
      grammarRule: "V2-regeln (Inversion)"
  ),
  ```

- [ ] **Step 2: Commit changes**
  ```bash
  git add StreetSwedish/Data/LessonData.swift
  git commit -m "feat: add grammar parsing exercises with V2 rule breakdowns"
  ```
