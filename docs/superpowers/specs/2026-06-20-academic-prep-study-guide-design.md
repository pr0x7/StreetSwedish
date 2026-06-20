# Spec: Academic Lesson Prep & Study Guide (Sub-project 1)

## Overview
Transform each lesson node into a detailed, interactive self-study reference interface by introducing a "Studieguide" (Study Guide) panel inside the lesson detail sheet. This guide will contain:
1. A unified lesson-level grammar & structural overview article.
2. An interactive vocabulary list with expandable detail cards showing grammar notes (e.g., noun genders/plurals) and premium verb conjugation tables.

---

## Architectural Changes & Data Models

### 1. Model Updates in `StreetSwedish/Models/LearningModels.swift`

We will add properties to existing structs with backward-compatible defaults:

* **`Lesson` struct updates:**
  ```swift
  public let grammarOverview: String?
  ```
  *Update memberwise initializer to include `grammarOverview: String? = nil`.*

* **`VocabItem` struct updates:**
  ```swift
  public let grammarNote: String?
  ```
  *Update initializer to include `grammarNote: String? = nil`.*

### 2. Verb Conjugation Lookup Extension
We will create an extension on `VocabItem` inside `StreetSwedish/Models/LearningModels.swift` to resolve verb forms from the global `VerbData.allVerbs` array:
```swift
extension VocabItem {
    public var verbConjugation: SwedishVerb? {
        VerbData.allVerbs.first { $0.infinitive.lowercased() == self.swedish.lowercased() }
    }
}
```

---

## UI Components & Layout in `StreetSwedish/Views/Learn/CoursesView.swift`

We will enhance the existing `LessonDetailSheet` view to render a dual-pane segmented interface:

### 1. Segmented Navigation Tab
Add a state variable `@State private var selectedTab: Int = 0` (0 for "Ordlista" / Vocab list, 1 for "Studieguide" / Study guide).
Render a SwiftUI `Picker` styled as `.segmented` below the sheet's title:
```swift
Picker("", selection: $selectedTab) {
    Text(progressManager.loc("Vocabulary", "Ordlista")).tag(0)
    Text(progressManager.loc("Study Guide", "Studieguide")).tag(1)
}
.pickerStyle(.segmented)
.padding(.horizontal, 20)
```

### 2. Study Guide Render Flow
If `selectedTab == 1`, show a vertical `ScrollView` showing:

* **Grammar Overview Section:**
  If `lesson.grammarOverview` is available, render it in a clean card:
  - Background: `Color.appSurface`
  - Stroke: `Color.primaryGold.opacity(0.3)`
  - Rounded Corners: `16`
  - Content: Styled text displaying the grammar rules.

* **Linguistic Breakdown Cards:**
  Render a list of the lesson's `VocabItem`s. Each item will be an expandable button component:
  - Tapping a word toggles its visibility in a local list of expanded IDs.
  - Expanded details show:
    - Pronunciation key (e.g. `uttal: beh-stel-ah`).
    - Specific grammar note if present (e.g., gender, plural endings).
    - If the word has a matching `verbConjugation`, display a grid containing its conjugated forms (*Infinitive*, *Present*, *Past*, *Supinum*, *Imperative*) and matching example sentences.

---

## Data Content Expansion

### 1. Lesson Data in `StreetSwedish/Data/LessonData.swift`
We will populate the new `grammarOverview` field for the first three lessons:
- **`tech_basics`**: Explanation of Swedish corporate structure, fika etiquette, the V2 word order rule in simple sentences, and workspace verb conjugations.
- **`workplace_swag`**: Explaining the contrast between informal and formal registers, Swedish workplace terminology, and action verb constructions.
- **`office_drama`**: Explanation of reflexive pronouns (*sig*, *mig*, *dig*) and expressions related to work-life balance (*flexa*, *sjukskriva sig*).

### 2. Vocab Data in `StreetSwedish/Data/VocabDataExpansion.swift` & `LessonData.swift`
Add specific `grammarNote` values for nouns and verbs to demonstrate linguistic depth (e.g., gender classification, plurals, and particle verb warnings).

---

## Verification Plan

### Manual Verification
1. Run the Swift Playgrounds application on iOS Simulator or Mac.
2. Tap a lesson node on the map (e.g., "Tech Slang Basics").
3. Verify that a segmented picker appears at the top of the detail sheet.
4. Toggle to the "Studieguide" tab and verify the grammar article renders cleanly.
5. Tap vocabulary words to expand them and check that their pronunciation, grammar notes, and verb conjugation tables display with clean margins and high-contrast styling.
