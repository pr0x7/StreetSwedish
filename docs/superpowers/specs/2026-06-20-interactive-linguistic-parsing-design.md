# Sub-project 3: Interactive Linguistic Parsing Exercises — Design Specification

## Overview
A new interactive exercise type focused on Swedish grammar rules (V2 word order rule, word endings, inversions). When submitting an answer, the app provides a detailed grammatical breakdown explaining why the answer is structured that way.

## Architecture
We add a new `grammaticalBreakdown` field to the `Exercise` model so that exercises can optionally carry a post-submission explanation. We create a `GrammarBreakdownSheet` view that shows the explanation with color-coded word role tags. We add a new exercise type `grammarParsing` to `ExerciseType` and implement a `GrammarParsingView` in ExerciseRouter. Finally, we populate grammar parsing exercises in `LessonData.swift`.

## Design Decisions

### 1. Model Extension
- Add `grammaticalBreakdown: String?` to `Exercise` struct (default nil, backward compatible)
- Add `grammarRule: String?` to `Exercise` (e.g., "V2 Rule", "En/Ett", "Inversion") for display labeling
- Add `.grammarParsing` case to `ExerciseType`

### 2. Grammar Parsing Exercise View (`GrammarParsingView`)
This is a word-order-style exercise (user drags/taps words into position), but after submitting:
- A "Grammar Breakdown" card slides in below
- Shows the sentence with each word tagged by grammatical role (Subject, Verb, Object, Adverb, etc.)
- Displays the applied grammar rule (e.g., "V2 Rule — verb must be in second position")
- Shows a brief explanation of why the sentence is ordered that way

### 3. Grammar Breakdown Sheet
A reusable bottom sheet `GrammarBreakdownSheet` that displays:
- The assembled sentence with color-coded word roles
- The grammar rule name and explanation
- A "Got it" dismiss button

### 4. Exercise Data
Add 6 grammar parsing exercises across 2 lessons covering:
- V2 word order with inversion
- En/Ett noun gender rules
- Present tense verb endings

## Constraints
- No external dependencies
- Follow existing color/typography systems
- Backward-compatible model changes
- All exercises must work within the existing `LessonCoordinator` flow
