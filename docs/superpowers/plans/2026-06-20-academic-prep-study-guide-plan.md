# Academic Lesson Prep & Study Guide Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "Studieguide" (Study Guide) tab to each lesson's detail sheet, displaying grammar overviews and interactive vocabulary breakdown cards with verb conjugations.

**Architecture:** We update `LearningModels.swift` to add `grammarOverview` (to `Lesson`) and `grammarNote` (to `VocabItem`). We add an extension to `VocabItem` to fetch corresponding conjugations from `VerbData.allVerbs`. In `CoursesView.swift`, we replace the static vocabulary list inside `LessonDetailSheet` with a segmented tab control, allowing users to toggle between the original Word List and the new Study Guide. The Study Guide displays the grammar text and expandable vocab items.

**Tech Stack:** Swift 5.8+, SwiftUI, iOS 16+ (Swift Playgrounds App format)

## Global Constraints
- Do not introduce external dependencies.
- Follow the existing SwiftUI styling, color extensions (e.g., `Color.appBackground`, `Color.appSurface`, `Color.primaryGold`), and typography systems.
- Initializers must maintain backward-compatible default parameters.
- Verify compiling status by ensuring zero syntax errors in code.

---

### Task 1: Update Data Models in LearningModels.swift

**Files:**
- Modify: `StreetSwedish/Models/LearningModels.swift`

**Interfaces:**
- Consumes: None
- Produces: `grammarOverview` (on `Lesson`), `grammarNote` (on `VocabItem`), and `verbConjugation` (computed property on `VocabItem`)

- [ ] **Step 1: Add grammarOverview to Lesson**
  Modify the `Lesson` struct to include `grammarOverview`:
  ```swift
  public let grammarOverview: String?
  ```
  Update its initializer to default to `nil`:
  ```swift
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
  ```

- [ ] **Step 2: Add grammarNote to VocabItem**
  Modify the `VocabItem` struct to include `grammarNote`:
  ```swift
  public let grammarNote: String?
  ```
  Update its initializer to default to `nil`:
  ```swift
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
  ```

- [ ] **Step 3: Implement VocabItem verbConjugation extension**
  At the bottom of `LearningModels.swift`, add:
  ```swift
  extension VocabItem {
      public var verbConjugation: SwedishVerb? {
          VerbData.allVerbs.first { $0.infinitive.lowercased() == self.swedish.lowercased() }
      }
  }
  ```

- [ ] **Step 4: Commit changes**
  Run:
  ```bash
  git add StreetSwedish/Models/LearningModels.swift
  git commit -m "feat: update learning models with grammar overview and notes"
  ```

---

### Task 2: Populate Data with Grammar & Notes

**Files:**
- Modify: `StreetSwedish/Data/LessonData.swift`
- Modify: `StreetSwedish/Data/VocabDataExpansion.swift`

**Interfaces:**
- Consumes: Updated model properties from Task 1

- [ ] **Step 1: Populate grammarOverview for Lesson 1**
  In `StreetSwedish/Data/LessonData.swift`, locate the `tech_basics` lesson instantiation and populate `grammarOverview`:
  ```swift
  grammarOverview: """
  VÄLKOMMEN TILL TECH-BASICS!
  
  Grammar Focus: The V2 Word Order Rule
  In Swedish, the verb must always be the second element in a declarative sentence. If you start a sentence with a time or place adverbial, the subject and verb invert:
  - Normal: "Vi tar (verb) det på vår standup klockan nio."
  - Inverted: "Klockan nio tar (verb) vi (subject) det på vår standup."
  
  Cultural Vibe: Konsensus & Fika
  Corporate Sweden values equality and flat hierarchies. If a meeting drags on, use the verb 'ta det offline' to politely defer details.
  """
  ```

- [ ] **Step 2: Add grammarNote to VocabItems**
  In `StreetSwedish/Data/VocabDataExpansion.swift`, update helper method `q` to accept and pass an optional `grammarNote: String?`:
  ```swift
  static func q(_ id: String, _ sv: String, _ en: String, _ pron: String, _ exSv: String, _ exEn: String, _ hook: String, _ reg: RegisterLevel, _ grammarNote: String? = nil) -> VocabItem {
      VocabItem(id: id, swedish: sv, english: en, pronunciation: pron,
                exampleSentences: [ExampleSentence(swedish: exSv, english: exEn, registerLabel: reg)],
                soundHook: hook, visualHook: "", cultureHook: "", registerLabel: reg, grammarNote: grammarNote)
  }
  ```
  Update `v_notan` and `v_kvitto` to include gender and plural noun grammar notes:
  - `v_notan`: `"N-noun (en nota). Definite singular form. Plural: notorna."`
  - `v_kvitto`: `"T-noun (ett kvitto). Indefinite singular. Plural: kvitton. Definite: kvittot."`

- [ ] **Step 3: Commit changes**
  Run:
  ```bash
  git add StreetSwedish/Data/LessonData.swift StreetSwedish/Data/VocabDataExpansion.swift
  git commit -m "feat: populate grammar overview and vocab notes in lesson data"
  ```

---

### Task 3: Implement Segmented Control in LessonDetailSheet

**Files:**
- Modify: `StreetSwedish/Views/Learn/CoursesView.swift`

**Interfaces:**
- Consumes: `LessonDetailSheet` view state

- [ ] **Step 1: Add State Variable**
  Inside `struct LessonDetailSheet: View`, add a state variable:
  ```swift
  @State private var selectedTab: Int = 0 // 0: Word List, 1: Study Guide
  ```

- [ ] **Step 2: Add Segmented Picker**
  Add a segmented `Picker` at the top of the detail sheet content layout (just below the title block):
  ```swift
  Picker("", selection: $selectedTab) {
      Text(progressManager.loc("Word List", "Ordlista")).tag(0)
      Text(progressManager.loc("Study Guide", "Studieguide")).tag(1)
  }
  .pickerStyle(.segmented)
  .padding(.horizontal, 20)
  ```

- [ ] **Step 3: Segment Content Rendering**
  Wrap the current vocab list scroll view inside a conditional block:
  ```swift
  if selectedTab == 0 {
      // Current vocab scroll view goes here
  } else {
      // Temporary placeholder content for Study Guide
      ScrollView {
          Text("Study Guide Content")
              .foregroundColor(.textSecondary)
              .padding()
      }
  }
  ```

- [ ] **Step 4: Commit changes**
  Run:
  ```bash
  git add StreetSwedish/Views/Learn/CoursesView.swift
  git commit -m "feat: integrate segmented control tabs in lesson detail sheet"
  ```

---

### Task 4: Implement Study Guide UI & Verb Conjugation Tables

**Files:**
- Modify: `StreetSwedish/Views/Learn/CoursesView.swift`

**Interfaces:**
- Consumes: `VocabItem.verbConjugation` from Task 1, dynamic detail views

- [ ] **Step 1: Implement Local Expansion State**
  In `LessonDetailSheet`, add a state variable to track which vocab cards are expanded:
  ```swift
  @State private var expandedVocabIDs: Set<String> = []
  ```

- [ ] **Step 2: Render Study Guide Content Block**
  Replace the placeholder in the `else` block of `selectedTab` with the actual Study Guide UI:
  ```swift
  ScrollView(.vertical, showsIndicators: true) {
      VStack(spacing: 20) {
          // 1. Grammar Overview Card
          if let overview = lesson.grammarOverview {
              VStack(alignment: .leading, spacing: 10) {
                  Text(progressManager.loc("GRAMMAR OVERVIEW", "GRAMMATISK ÖVERSIKT"))
                      .font(.sfRounded(size: 11, weight: .bold))
                      .foregroundColor(.primaryGold)
                      .tracking(1.5)
                  
                  Text(overview)
                      .font(.sfStandard(size: 14))
                      .foregroundColor(.textPrimary)
                      .lineSpacing(4)
              }
              .padding(16)
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color.appSurface)
              .cornerRadius(16)
              .overlay(
                  RoundedRectangle(cornerRadius: 16)
                      .stroke(Color.primaryGold.opacity(0.2), lineWidth: 1.5)
              )
          }
          
          // 2. Expandable Vocab Cards
          VStack(alignment: .leading, spacing: 12) {
              Text(progressManager.loc("DETAILED BREAKDOWNS", "DETALJERAD ANALYS"))
                  .font(.sfRounded(size: 11, weight: .bold))
                  .foregroundColor(.textSecondary)
                  .tracking(1.0)
              
              ForEach(lesson.vocabItems, id: \.id) { item in
                  VStack(spacing: 0) {
                      // Header button
                      Button(action: {
                          withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                              if expandedVocabIDs.contains(item.id) {
                                  expandedVocabIDs.remove(item.id)
                              } else {
                                  expandedVocabIDs.insert(item.id)
                              }
                          }
                      }) {
                          HStack {
                              VStack(alignment: .leading, spacing: 2) {
                                  Text(item.swedish)
                                      .font(.sfRounded(size: 16, weight: .bold))
                                      .foregroundColor(.primaryGold)
                                  Text(item.english)
                                      .font(.sfStandard(size: 13))
                                      .foregroundColor(.textSecondary)
                              }
                              Spacer()
                              Image(systemName: "chevron.down")
                                  .foregroundColor(.textMuted)
                                  .rotationEffect(expandedVocabIDs.contains(item.id) ? .degrees(180) : .degrees(0))
                          }
                          .padding(14)
                          .background(Color.appSurface)
                      }
                      
                      // Expanded details
                      if expandedVocabIDs.contains(item.id) {
                          VStack(alignment: .leading, spacing: 12) {
                              Divider()
                              
                              Text("Pronunciation: / \(item.pronunciation) /")
                                  .font(.sfStandard(size: 13, weight: .semibold))
                                  .foregroundColor(.textPrimary)
                              
                              if let note = item.grammarNote {
                                  Text("Grammar Note: \(note)")
                                      .font(.sfStandard(size: 13))
                                      .foregroundColor(.textSecondary)
                              }
                              
                              // Verb Conjugation Table
                              if let verb = item.verbConjugation {
                                  VStack(alignment: .leading, spacing: 6) {
                                      Text(progressManager.loc("CONJUGATIONS", "BÖJNINGAR"))
                                          .font(.sfRounded(size: 10, weight: .black))
                                          .foregroundColor(.primaryBlue)
                                      
                                      VStack(alignment: .leading, spacing: 4) {
                                          conjugationRow(label: "Infinitive", form: verb.infinitive, example: verb.exPresent, exampleEn: verb.exPresentEn)
                                          conjugationRow(label: "Present", form: verb.present, example: verb.exPresent, exampleEn: verb.exPresentEn)
                                          conjugationRow(label: "Past", form: verb.past, example: verb.exPast, exampleEn: verb.exPastEn)
                                          conjugationRow(label: "Supinum", form: verb.supinum, example: verb.exSupinum, exampleEn: verb.exSupinumEn)
                                          conjugationRow(label: "Imperative", form: verb.imperative, example: "", exampleEn: "")
                                      }
                                      .padding(8)
                                      .background(Color.appSurfaceElevated)
                                      .cornerRadius(8)
                                  }
                              }
                          }
                          .padding(14)
                          .background(Color.appSurface.opacity(0.5))
                      }
                  }
                  .cornerRadius(12)
                  .overlay(
                      RoundedRectangle(cornerRadius: 12)
                          .stroke(Color.appSurfaceElevated, lineWidth: 1)
                  )
              }
          }
      }
      .padding(.horizontal, 20)
  }
  ```

- [ ] **Step 3: Add conjugationRow helper**
  Add the `conjugationRow` helper method inside `LessonDetailSheet`:
  ```swift
  @ViewBuilder
  private func conjugationRow(label: String, form: String, example: String, exampleEn: String) -> some View {
      VStack(alignment: .leading, spacing: 2) {
          HStack {
              Text(label)
                  .font(.sfRounded(size: 11, weight: .bold))
                  .foregroundColor(.textMuted)
                  .frame(width: 80, alignment: .leading)
              
              Text(form)
                  .font(.sfRounded(size: 13, weight: .bold))
                  .foregroundColor(.primaryGold)
              
              Spacer()
          }
          if !example.isEmpty {
              Text("\"\(example)\" — \(exampleEn)")
                  .font(.sfStandard(size: 11))
                  .foregroundColor(.textSecondary)
                  .padding(.leading, 80)
          }
      }
      .padding(.vertical, 2)
  }
  ```

- [ ] **Step 4: Commit changes**
  Run:
  ```bash
  git add StreetSwedish/Views/Learn/CoursesView.swift
  git commit -m "feat: complete study guide UI with verb conjugation tables and expandable cards"
  ```
