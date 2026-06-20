# Sub-project 4: SFI Course C/D Curriculum & Exams — Design Specification

## Overview
Map the existing app modules to SFI (Swedish For Immigrants) Course C and D competency levels. Create a dedicated SFI Exam view accessible from the SFI Hub that tests grammar, reading comprehension, and vocabulary with timed sections and score tracking.

## Architecture
We extend the existing SFI Hub (`SFIHubView.swift`) with new navigation cards for Course C Exam and Course D Exam. We add an `SFIExamView` that presents timed, multi-section exam exercises. Exam data lives in a new `SFIExamData.swift` file. Results are tracked through existing `ProgressManager`.

## Design Decisions

### 1. SFI Exam Model
- New `SFIExamSection` struct: `id, title, timeLimit (seconds), exercises: [Exercise]`
- New `SFIExam` struct: `id, courseLevel (C or D), title, sections: [SFIExamSection], passingScore: Double`
- These use the existing `Exercise` model for individual questions

### 2. SFI Exam View (`SFIExamView`)
A full-screen exam experience:
- Shows current section name and timer countdown
- Uses existing exercise views (multiple choice, fill blank, translate) via `ExerciseRouter`
- Progress bar across top showing section/total progress
- Auto-advances when timer runs out for a section
- Results screen at end with score per section and overall pass/fail

### 3. SFI Hub Updates
- Add two new cards to `SFIHubView`: "Course C Exam" and "Course D Exam"
- Each links to `SFIExamView` with the appropriate exam data
- Show badge if previously passed

### 4. Exam Data Content
**Course C Exam** (B1 level — everyday Swedish):
- Section 1: Reading Comprehension (5 multiple choice, 3 min)
- Section 2: Grammar (5 fill-in-the-blank, 3 min)
- Section 3: Vocabulary (5 translate, 3 min)

**Course D Exam** (B2 level — workplace/academic Swedish):
- Section 1: Reading Comprehension (5 multiple choice, 4 min)
- Section 2: Grammar & Word Order (5 exercises incl. word order, 4 min)
- Section 3: Vocabulary & Translation (5 translate, 4 min)

### 5. Progress Tracking
- Store exam results in ProgressManager: `sfiExamScores: [String: Double]` mapping exam ID to best score
- Display pass/fail badge on SFI Hub cards

## Constraints
- No external dependencies
- Follow existing color/typography systems
- Reuse existing Exercise/ExerciseRouter infrastructure
- Backward-compatible model changes
- Timer UI should match app's premium aesthetic
