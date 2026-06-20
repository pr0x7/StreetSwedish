# Spec: Deep Dialogue & Context Immersion (Sub-project 2)

**Goal:** Refactor the Dialogue screen to support a detailed line-by-line analysis mode. Tapping any sentence displays alternative street slang/formal translations, cultural notes, and text-to-speech controls with normal and slow speed options.

## 1. Architectural Changes

We refactor the dialogue system to support rich language breakdowns without breaking compatibility with existing lesson resources.

### 1.1 Model Refactoring (`StreetSwedish/Models/LearningModels.swift`)

The `DialogueLine` model is updated to conform to `Identifiable` (using the Swedish string as its identifier, which is unique within a dialogue) and contains three new optional fields for analytical context:

```swift
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
```

### 1.2 Interactive UI Handoff (`StreetSwedish/Views/Learn/LessonView.swift`)

In the dialogue display view (`act5DialogueView`), each chat bubble becomes tap-responsive. Tapping a bubble triggers a sheet presentation by writing to a local `@State` variable:

```swift
@State private var selectedLineForAnalysis: DialogueLine? = nil
```

The bubble rendering block wraps the `VStack` in a plain-styled button:

```swift
Button(action: {
    selectedLineForAnalysis = line
}) {
    VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
        // Chat bubble UI content
    }
}
.buttonStyle(.plain)
```

At the root level of `LessonView`, the sheet modifier is attached:

```swift
.sheet(item: $selectedLineForAnalysis) { line in
    DialogueLineAnalysisSheet(line: line)
        .environmentObject(progressManager)
}
```

---

## 2. Immersive Content Population

We will populate the dialogues in `StreetSwedish/Data/LessonData.swift` with real linguistic translations and cultural context notes:

### 2.1 Lesson 1: techDialogues[0] (Planeringsmöte)
- **Line 1 (Karin)**:
  - Swedish: `"Maja, är alla feature-kort klara för nästa sprint?"`
  - English: `"Maja, are all feature cards ready for the next sprint?"`
  - Alternative Formal: `"Maja, är alla uppgiftsbeskrivningar klara för nästa planering?"`
  - Cultural Note: `"Sprint is a direct loanword from Agile software development, used universally in Swedish tech hubs. The formal translation swaps 'sprint' and 'feature-kort' for traditional terms."`
- **Line 2 (Maja)**:
  - Swedish: `"Nästan, jag sitter i möte med designern nu. Jag löser det ASAP."`
  - English: `"Almost, I'm sitting in a meeting with the designer now. I will solve it ASAP."`
  - Alternative Slang: `"Nästan, sitter i möte med designern nu. Löser det direkt."`
  - Alternative Formal: `"Nästan, jag befinner mig i ett möte med formgivaren nu. Jag ska ordna det så snart som möjligt."`
  - Cultural Note: `"ASAP is pronounced as individual letters (A-S-A-P) or 'så fort som möjligt'. 'Sitta i möte' is the standard Swedish phrase meaning to be occupied in a meeting."`
- **Line 3 (Karin)**:
  - Swedish: `"Grymt. Pinga mig på Slack när du är klar så vi kan spika listan."`
  - English: `"Great. Ping me on Slack when you are done so we can nail down the list."`
  - Alternative Slang: `"Fett. Plinga mig på Slack sen så vi spikar listan."`
  - Alternative Formal: `"Utmärkt. Kontakta mig via Slack när du är färdig så att vi kan fastställa listan."`
  - Cultural Note: `"'Grymt' literally means 'cruel' but colloquially means 'awesome/great'. 'Spika' literally means 'to nail' but in workplace context means to finalize/make a firm decision."`

### 2.2 Lesson 2: techDialogues[1] (Slack Drama)
- **Line 1 (Maja)**:
  - Swedish: `"Kan någon göra en code review på min pull request?"`
  - English: `"Can someone do a code review on my pull request?"`
  - Alternative Slang: `"Kan nån kika på min pull request?"`
  - Alternative Formal: `"Kan någon vänligen granska min kodändring?"`
  - Cultural Note: `"English terms like 'code review' and 'pull request' are fully integrated into modern Swedish developer terminology."`
- **Line 2 (Erik)**:
  - Swedish: `"Jag är på det! Men jag måste vabba i eftermiddag, så jag kollar nu."`
  - English: `"I'm on it! But I have to care for my sick child this afternoon, so I'll check now."`
  - Alternative Slang: `"Jag löser det! Måste vabba i eftermiddag, kollar nu."`
  - Alternative Formal: `"Jag tar hand om det! Men jag behöver ta hand om ett sjukt barn i eftermiddag, så jag granskar det nu."`
  - Cultural Note: `"'Vabba' is a unique Swedish verb meaning 'to stay home to care for a sick child while receiving government compensation' (VAB - vård av barn). It is a highly respected aspect of Swedish work-life balance."`
- **Line 3 (Maja)**:
  - Swedish: `"Tack Erik! Vi tar feedbacken offline sen."`
  - English: `"Thanks Erik! We will take the feedback offline later."`
  - Alternative Slang: `"Tack som fan Erik! Vi tar feedbacken offline sen."`
  - Alternative Formal: `"Tack så mycket Erik! Vi kan diskutera återkopplingen enskilt senare."`
  - Cultural Note: `"'Offline' is used as a Swenglish workspace idiom for discussing details in private rather than dragging out a public meeting."`

---

## 3. UI Design Specification

### 3.1 DialogueLineAnalysisSheet Layout (`StreetSwedish/Views/Learn/CoursesView.swift`)

The analysis view is rendered in a scrollable bottom sheet. It uses the existing theme styling tokens (`Color.appBackground`, `Color.appSurface`, `Color.primaryGold`, etc.):

- **Header block**: Displays the character speaker name and the large Swedish phrase.
- **Text-to-Speech (TTS) Control Panel**: A play button (`Image(systemName: "speaker.wave.2")`) that calls `SpeechHelper.shared.speak` dynamically. A Segmented control allows selecting speech speed:
  - **Normal**: TTS rate `0.5`
  - **Slow**: TTS rate `0.32`
- **Standard Translation**: Simple italicized English translation card.
- **Comparative Variations**: Side-by-side or stacked panels with contrasting backgrounds (`Color.appSurfaceElevated`), labeling the slang and formal Swedish equivalents.
- **Cultural Highlight Card**: A custom card with a light gold tint background (`Color.primaryGold.opacity(0.08)`) and thin gold border (`stroke(Color.primaryGold.opacity(0.3))`) showing the cultural note.

---

## 4. Verification & Testing Strategy

1. **Verify No Broken Initializations**: Ensure the app continues to compile and load despite adding properties to `DialogueLine` model.
2. **Interactive Testing**: Open a lesson's dialogue segment, tap on each dialogue line bubble, and verify the analysis sheet slides up.
3. **TTS Testing**: Tap both the "Normal" and "Slow" speech speeds and verify that speech is spoken at noticeably distinct rates.
