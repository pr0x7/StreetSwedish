# Deep Dialogue & Context Immersion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor the Dialogue screen to support a detailed line-by-line analysis mode. Tapping any sentence displays alternative street slang/formal translations, cultural notes, and text-to-speech controls with normal and slow speed options.

**Architecture:** We update `DialogueLine` in `LearningModels.swift` to support the new optional alternative translation and cultural note fields. We populate these annotations for all `techDialogues` lines in `LessonData.swift`. In `LessonView.swift`, we wrap the message bubbles in a button to trigger selection. In `CoursesView.swift`, we define the `DialogueLineAnalysisSheet` view to show the details including standard/slang/formal translations, a cultural card, and SpeechHelper.shared.speak controls with a normal/slow speed toggle.

**Tech Stack:** Swift 5.8+, SwiftUI, iOS 16+

## Global Constraints
- Do not introduce external dependencies.
- Follow the existing SwiftUI styling, color extensions (e.g., Color.appBackground, Color.appSurface, Color.primaryGold), and typography systems.
- Initializers must maintain backward-compatible default parameters.
- Verify compiling status by ensuring zero syntax errors in code.

---

### Task 1: Update Model & Prepare Feature Branch

**Files:**
- Modify: `StreetSwedish/Models/LearningModels.swift`

**Interfaces:**
- Consumes: None
- Produces: `alternativeSlang: String?`, `alternativeFormal: String?`, and `culturalNote: String?` (on `DialogueLine`)

- [ ] **Step 1: Create a feature branch**
  Run:
  ```bash
  git checkout -b feat/deep-dialogue
  ```

- [ ] **Step 2: Add optional fields to DialogueLine**
  In `StreetSwedish/Models/LearningModels.swift`, modify `DialogueLine` to conform to `Identifiable` and add `alternativeSlang`, `alternativeFormal`, and `culturalNote` fields:
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

- [ ] **Step 3: Commit changes**
  Run:
  ```bash
  git add StreetSwedish/Models/LearningModels.swift
  git commit -m "feat: add alternative translations and cultural notes to DialogueLine"
  ```

---

### Task 2: Populate Dialogue Context Data

**Files:**
- Modify: `StreetSwedish/Data/LessonData.swift`

**Interfaces:**
- Consumes: Updated model properties from Task 1

- [ ] **Step 1: Update techDialogues in LessonData.swift**
  In `StreetSwedish/Data/LessonData.swift`, replace the `techDialogues` array definition with fully annotated dialogue lines containing alternative slang, alternative formal, and cultural notes:
  ```swift
      // MARK: - Dialogues
      public static let techDialogues: [Dialogue] = [
          Dialogue(
              title: "Planeringsmöte (Planning Meeting)",
              lines: [
                  DialogueLine(
                      speakerID: "karin",
                      swedish: "Maja, är alla feature-kort klara för nästa sprint?",
                      english: "Maja, are all feature cards ready for the next sprint?",
                      alternativeFormal: "Maja, är alla uppgiftsbeskrivningar klara för nästa planering?",
                      culturalNote: "Sprint is a direct loanword from Agile software development, used universally in Swedish tech hubs. The formal translation swaps 'sprint' and 'feature-kort' for traditional terms."
                  ),
                  DialogueLine(
                      speakerID: "maja",
                      swedish: "Nästan, jag sitter i möte med designern nu. Jag löser det ASAP.",
                      english: "Almost, I'm sitting in a meeting with the designer now. I will solve it ASAP.",
                      alternativeSlang: "Nästan, sitter i möte med designern nu. Löser det direkt.",
                      alternativeFormal: "Nästan, jag befinner mig i ett möte med formgivaren nu. Jag ska ordna det så snart som möjligt.",
                      culturalNote: "ASAP is pronounced as individual letters (A-S-A-P) or 'så fort som möjligt'. 'Sitta i möte' is the standard Swedish phrase meaning to be occupied in a meeting."
                  ),
                  DialogueLine(
                      speakerID: "karin",
                      swedish: "Grymt. Pinga mig på Slack när du är klar så vi kan spika listan.",
                      english: "Great. Ping me on Slack when you are done so we can nail down the list.",
                      alternativeSlang: "Fett. Plinga mig på Slack sen så vi spikar listan.",
                      alternativeFormal: "Utmärkt. Kontakta mig via Slack när du är färdig så att vi kan fastställa listan.",
                      culturalNote: "'Grymt' literally means 'cruel' but colloquially means 'awesome/great'. 'Spika' literally means 'to nail' but in workplace context means to finalize/make a firm decision."
                  )
              ],
              pullQuote: "Jag löser det ASAP. (I'll solve it ASAP.)"
          ),
          Dialogue(
              title: "Slack Drama",
              lines: [
                  DialogueLine(
                      speakerID: "maja",
                      swedish: "Kan någon göra en code review på min pull request?",
                      english: "Can someone do a code review on my pull request?",
                      alternativeSlang: "Kan nån kika på min pull request?",
                      alternativeFormal: "Kan någon vänligen granska min kodändring?",
                      culturalNote: "English terms like 'code review' and 'pull request' are fully integrated into modern Swedish developer terminology."
                  ),
                  DialogueLine(
                      speakerID: "erik",
                      swedish: "Jag är på det! Men jag måste vabba i eftermiddag, så jag kollar nu.",
                      english: "I'm on it! But I have to care for my sick child this afternoon, so I'll check now.",
                      alternativeSlang: "Jag löser det! Måste vabba i eftermiddag, kollar nu.",
                      alternativeFormal: "Jag tar hand om det! Men jag behöver ta hand om ett sjukt barn i eftermiddag, så jag granskar det nu.",
                      culturalNote: "'Vabba' is a unique Swedish verb meaning 'to stay home to care for a sick child while receiving government compensation' (VAB - vård av barn). It is a highly respected aspect of Swedish work-life balance."
                  ),
                  DialogueLine(
                      speakerID: "maja",
                      swedish: "Tack Erik! Vi tar feedbacken offline sen.",
                      english: "Thanks Erik! We will take the feedback offline later.",
                      alternativeSlang: "Tack som fan Erik! Vi tar feedbacken offline sen.",
                      alternativeFormal: "Tack så mycket Erik! Vi kan diskutera återkopplingen enskilt senare.",
                      culturalNote: "'Offline' is used as a Swenglish workspace idiom for discussing details in private rather than dragging out a public meeting."
                  )
              ],
              pullQuote: "Jag är på det! (I'm on it!)"
          )
      ]
  ```

- [ ] **Step 2: Commit changes**
  Run:
  ```bash
  git add StreetSwedish/Data/LessonData.swift
  git commit -m "feat: populate alternative translations and cultural notes for tech dialogues"
  ```

---

### Task 3: Enable Bubble Tapping in LessonView

**Files:**
- Modify: `StreetSwedish/Views/Learn/LessonView.swift`

**Interfaces:**
- Consumes: Dialogue line bubble taps
- Produces: Analysis sheet state trigger

- [ ] **Step 1: Add State Variable to LessonView**
  Inside `struct LessonView: View`, search for `activeDialogueBubbleIndex` and add the state variable right below it:
  ```swift
  @State private var selectedLineForAnalysis: DialogueLine? = nil
  ```

- [ ] **Step 2: Wrap Message Bubble in a Button**
  In `LessonView.swift`, locate `act5DialogueView()`. Wrap the Message Bubble `VStack` layout inside a `Button`:
  ```swift
                                      // Message Bubble
                                      Button(action: {
                                          selectedLineForAnalysis = line
                                      }) {
                                          VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                                              Text(line.swedish)
                                                  .font(.sfStandard(size: 15, weight: .semibold))
                                                  .foregroundColor(.textPrimary)
                                              Text(line.english)
                                                  .font(.sfStandard(size: 13))
                                                  .foregroundColor(.textSecondary)
                                          }
                                          .padding(14)
                                          .background(isUser ? Color.primaryBlue.opacity(0.2) : Color.appSurface)
                                          .cornerRadius(16, corners: isUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                                          .overlay(
                                              RoundedRectangle(cornerRadius: 16)
                                                  .stroke(isUser ? Color.primaryBlue : Color.clear, lineWidth: 1.5)
                                          )
                                      }
                                      .buttonStyle(.plain)
  ```

- [ ] **Step 3: Attach Sheet Modifier**
  At the bottom of `LessonView.swift`, locate where the root body elements close, and attach the `.sheet` modifier:
  ```swift
          .sheet(item: $selectedLineForAnalysis) { line in
              DialogueLineAnalysisSheet(line: line)
                  .environmentObject(progressManager)
          }
  ```

- [ ] **Step 4: Commit changes**
  Run:
  ```bash
  git add StreetSwedish/Views/Learn/LessonView.swift
  git commit -m "feat: trigger line-by-line analysis sheet from dialogue bubbles in LessonView"
  ```

---

### Task 4: Implement DialogueLineAnalysisSheet UI

**Files:**
- Modify: `StreetSwedish/Views/Learn/CoursesView.swift`

**Interfaces:**
- Consumes: Selected `DialogueLine` details, SpeechHelper
- Produces: Rendered bottom sheet overlay

- [ ] **Step 1: Add DialogueLineAnalysisSheet view**
  At the bottom of `StreetSwedish/Views/Learn/CoursesView.swift` (after the end of `LessonDetailSheet`), append the `DialogueLineAnalysisSheet` view struct definition:
  ```swift
  struct DialogueLineAnalysisSheet: View {
      let line: DialogueLine
      @EnvironmentObject var progressManager: ProgressManager
      @Environment(\.dismiss) var dismiss
      @StateObject private var speechHelper = SpeechHelper.shared
      @State private var speedRate: Float = 0.5 // 0.5 for Normal, 0.32 for Slow
      
      var body: some View {
          ZStack {
              Color.appBackground.ignoresSafeArea()
              
              VStack(spacing: 24) {
                  // Drag handle
                  Capsule()
                      .fill(Color.textMuted.opacity(0.3))
                      .frame(width: 40, height: 5)
                      .padding(.top, 12)
                  
                  VStack(spacing: 8) {
                      Text(line.speakerID.capitalized)
                          .font(.sfRounded(size: 24, weight: .black))
                          .foregroundColor(.textPrimary)
                      
                      Text(progressManager.loc("Sentence Analysis", "Meningsanalys"))
                          .font(.sfRounded(size: 12, weight: .bold))
                          .foregroundColor(.primaryGold)
                          .tracking(1.5)
                  }
                  
                  ScrollView(.vertical, showsIndicators: true) {
                      VStack(spacing: 20) {
                          // Swedish display card with TTS controls
                          VStack(spacing: 16) {
                              Text(line.swedish)
                                  .font(.sfRounded(size: 20, weight: .bold))
                                  .foregroundColor(.textPrimary)
                                  .multilineTextAlignment(.center)
                                  .padding(.horizontal, 8)
                              
                              HStack(spacing: 16) {
                                  Button(action: {
                                      if speechHelper.isSpeaking && speechHelper.currentlySpeakingID == line.swedish {
                                          speechHelper.stop()
                                      } else {
                                          speechHelper.speak(line.swedish, itemID: line.swedish, rate: speedRate)
                                      }
                                  }) {
                                      HStack {
                                          Image(systemName: speechHelper.isSpeaking && speechHelper.currentlySpeakingID == line.swedish ? "stop.fill" : "speaker.wave.2.fill")
                                          Text(speechHelper.isSpeaking && speechHelper.currentlySpeakingID == line.swedish ? "Stop" : "Listen")
                                      }
                                      .font(.sfRounded(size: 14, weight: .bold))
                                      .foregroundColor(.appBackground)
                                      .padding(.horizontal, 16)
                                      .padding(.vertical, 10)
                                      .background(Color.primaryGold)
                                      .cornerRadius(12)
                                  }
                                  .buttonStyle(.plain)
                                  
                                  Picker("", selection: $speedRate) {
                                      Text("Normal").tag(Float(0.5))
                                      Text("Slow").tag(Float(0.32))
                                  }
                                  .pickerStyle(.segmented)
                                  .frame(width: 140)
                              }
                          }
                          .padding(16)
                          .frame(maxWidth: .infinity)
                          .background(Color.appSurface)
                          .cornerRadius(16)
                          
                          // English Translation
                          VStack(alignment: .leading, spacing: 6) {
                              Text(progressManager.loc("TRANSLATION", "ÖVERSÄTTNING"))
                                  .font(.sfRounded(size: 11, weight: .bold))
                                  .foregroundColor(.textSecondary)
                                  .tracking(1.0)
                              
                              Text(line.english)
                                  .font(.sfStandard(size: 15))
                                  .foregroundColor(.textPrimary)
                          }
                          .frame(maxWidth: .infinity, alignment: .leading)
                          .padding(14)
                          .background(Color.appSurface)
                          .cornerRadius(12)
                          
                          // Alternate translations
                          if line.alternativeSlang != nil || line.alternativeFormal != nil {
                              VStack(alignment: .leading, spacing: 12) {
                                  Text(progressManager.loc("ALTERNATIVE VARIATIONS", "ALTERNATIV UTTRYCK"))
                                      .font(.sfRounded(size: 11, weight: .bold))
                                      .foregroundColor(.textSecondary)
                                      .tracking(1.0)
                                  
                                  if let slang = line.alternativeSlang {
                                      VStack(alignment: .leading, spacing: 4) {
                                          Text(progressManager.loc("Street Slang", "Gatuslang"))
                                              .font(.sfRounded(size: 10, weight: .black))
                                              .foregroundColor(.accentStreet)
                                          Text(slang)
                                              .font(.sfStandard(size: 14, weight: .medium))
                                              .foregroundColor(.textPrimary)
                                      }
                                      .padding(12)
                                      .frame(maxWidth: .infinity, alignment: .leading)
                                      .background(Color.appSurfaceElevated)
                                      .cornerRadius(10)
                                  }
                                  
                                  if let formal = line.alternativeFormal {
                                      VStack(alignment: .leading, spacing: 4) {
                                          Text(progressManager.loc("Formal / Workplace", "Formellt / Arbetsplats"))
                                              .font(.sfRounded(size: 10, weight: .black))
                                              .foregroundColor(.accentWork)
                                          Text(formal)
                                              .font(.sfStandard(size: 14, weight: .medium))
                                              .foregroundColor(.textPrimary)
                                      }
                                      .padding(12)
                                      .frame(maxWidth: .infinity, alignment: .leading)
                                      .background(Color.appSurfaceElevated)
                                      .cornerRadius(10)
                                  }
                              }
                          }
                          
                          // Cultural Note Card
                          if let culture = line.culturalNote {
                              VStack(alignment: .leading, spacing: 8) {
                                  Text(progressManager.loc("CULTURAL & CONTEXT NOTE", "KULTURELL & KONTEXTUELL INFO"))
                                      .font(.sfRounded(size: 11, weight: .bold))
                                      .foregroundColor(.primaryGold)
                                      .tracking(1.5)
                                  
                                  Text(culture)
                                      .font(.sfStandard(size: 14))
                                      .foregroundColor(.textPrimary)
                                      .lineSpacing(4)
                              }
                              .padding(16)
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .background(Color.primaryGold.opacity(0.08))
                              .cornerRadius(16)
                              .overlay(
                                  RoundedRectangle(cornerRadius: 16)
                                      .stroke(Color.primaryGold.opacity(0.3), lineWidth: 1.5)
                              )
                          }
                      }
                      .padding(.horizontal, 20)
                  }
                  
                  Button(action: {
                      dismiss()
                  }) {
                      Text(progressManager.loc("Close", "Stäng"))
                          .font(.sfRounded(size: 16, weight: .bold))
                          .foregroundColor(.appBackground)
                          .frame(maxWidth: .infinity)
                          .frame(height: 52)
                          .background(Color.primaryGold)
                          .cornerRadius(16)
                  }
                  .padding(.horizontal, 20)
                  .padding(.bottom, 24)
              }
          }
      }
  }
  ```

- [ ] **Step 2: Commit changes**
  Run:
  ```bash
  git add StreetSwedish/Views/Learn/CoursesView.swift
  git commit -m "feat: implement DialogueLineAnalysisSheet UI for sentence analysis"
  ```
