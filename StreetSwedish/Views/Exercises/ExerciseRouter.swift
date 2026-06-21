import SwiftUI

// MARK: - Exercise Router
public struct ExerciseRouter: View {
    public let exercise: Exercise
    public let answeredCorrectly: Bool?
    public let shakeTrigger: Bool
    public let onAnswerSubmitted: (String) -> Void
    
    public init(
        exercise: Exercise,
        answeredCorrectly: Bool?,
        shakeTrigger: Bool,
        onAnswerSubmitted: @escaping (String) -> Void
    ) {
        self.exercise = exercise
        self.answeredCorrectly = answeredCorrectly
        self.shakeTrigger = shakeTrigger
        self.onAnswerSubmitted = onAnswerSubmitted
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            switch exercise.type {
            case .multipleChoice:
                MultipleChoiceView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .fillBlank:
                FillBlankView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .translate:
                TranslateView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .wordOrder:
                WordOrderView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .dialoguePick:
                DialoguePickView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .conversationSim:
                ConversationSimView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .errorCorrection:
                ErrorCorrectionView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .storyQuiz:
                StoryQuizView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .sentenceBuilder:
                SentenceBuilderView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
                
            case .grammarParsing:
                GrammarParsingView(
                    exercise: exercise,
                    answeredCorrectly: answeredCorrectly,
                    shakeTrigger: shakeTrigger,
                    onAnswerSubmitted: onAnswerSubmitted
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - 1. Multiple Choice View
struct MultipleChoiceView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var selectedOption: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(exercise.prompt)
                .font(.sfRounded(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)
                .padding(.top, 8)
            
            VStack(spacing: 12) {
                ForEach(exercise.options, id: \.self) { option in
                    Button(action: {
                        if answeredCorrectly == nil {
                            selectedOption = option
                            onAnswerSubmitted(option)
                        }
                    }) {
                        HStack {
                            Text(option)
                                .font(.sfStandard(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            
                            if selectedOption == option {
                                if answeredCorrectly == true {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.appSuccess)
                                } else if answeredCorrectly == false {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.appError)
                                }
                            }
                        }
                        .padding(18)
                        .background(
                            selectedOption == option ?
                                (answeredCorrectly == true ? Color.appSuccess.opacity(0.15) :
                                 answeredCorrectly == false ? Color.appError.opacity(0.15) : Color.primaryBlue.opacity(0.15))
                                : Color.appSurface
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    selectedOption == option ?
                                        (answeredCorrectly == true ? Color.appSuccess :
                                         answeredCorrectly == false ? Color.appError : Color.primaryBlue)
                                        : Color.clear,
                                    lineWidth: 2
                                )
                        )
                        .cornerRadius(16)
                    }
                    .disabled(answeredCorrectly != nil)
                    .offset(x: (selectedOption == option && shakeTrigger) ? -10 : 0)
                    .animation(
                        (selectedOption == option && shakeTrigger) ?
                            .spring(response: 0.12, dampingFraction: 0.2).repeatCount(3, autoreverses: true) :
                            .default,
                        value: shakeTrigger
                    )
                }
            }
        }
    }
}

// MARK: - 2. Fill In The Blank View
struct FillBlankView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var selectedOption: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Fyll i tomrummet (Fill in the blank)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            // Sentence prompt with blank
            let promptText = exercise.prompt.replacingOccurrences(of: "______", with: selectedOption ?? "______")
            
            Text(promptText)
                .font(.sfRounded(size: 22, weight: .semibold))
                .foregroundColor(.textPrimary)
                .lineSpacing(6)
                .padding(.vertical, 16)
            
            // Choices
            VStack(spacing: 12) {
                ForEach(exercise.options, id: \.self) { option in
                    Button(action: {
                        if answeredCorrectly == nil {
                            selectedOption = option
                            onAnswerSubmitted(option)
                        }
                    }) {
                        Text(option)
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.textPrimary)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(
                                selectedOption == option ?
                                    (answeredCorrectly == true ? Color.appSuccess.opacity(0.2) :
                                     answeredCorrectly == false ? Color.appError.opacity(0.2) : Color.primaryBlue.opacity(0.2))
                                    : Color.appSurface
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedOption == option ?
                                            (answeredCorrectly == true ? Color.appSuccess :
                                             answeredCorrectly == false ? Color.appError : Color.primaryBlue)
                                            : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .cornerRadius(12)
                    }
                    .disabled(answeredCorrectly != nil)
                    .offset(x: (selectedOption == option && shakeTrigger) ? -10 : 0)
                    .animation(
                        (selectedOption == option && shakeTrigger) ?
                            .spring(response: 0.12, dampingFraction: 0.2).repeatCount(3, autoreverses: true) :
                            .default,
                        value: shakeTrigger
                    )
                }
            }
        }
    }
}

// MARK: - 3. Translate View
struct TranslateView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var textInput = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Översätt meningen (Translate)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            Text(exercise.prompt)
                .font(.sfRounded(size: 20, weight: .bold))
                .foregroundColor(.textPrimary)
            
            TextField("Skriv din översättning här...", text: $textInput)
                .font(.sfStandard(size: 16))
                .padding(18)
                .background(Color.appSurface)
                .foregroundColor(.textPrimary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            answeredCorrectly == true ? Color.appSuccess :
                            answeredCorrectly == false ? Color.appError : Color.clear,
                            lineWidth: 2
                        )
                )
                .disabled(answeredCorrectly != nil)
                .offset(x: (answeredCorrectly == false && shakeTrigger) ? -10 : 0)
                .animation(
                    (answeredCorrectly == false && shakeTrigger) ?
                        .spring(response: 0.12, dampingFraction: 0.2).repeatCount(3, autoreverses: true) :
                        .default,
                    value: shakeTrigger
                )
            
            if answeredCorrectly == nil {
                Button(action: {
                    onAnswerSubmitted(textInput)
                }) {
                    Text("Kontrollera svar")
                        .font(.sfRounded(size: 16, weight: .bold))
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(textInput.isEmpty ? Color.textMuted : Color.primaryGold)
                        .cornerRadius(16)
                }
                .disabled(textInput.isEmpty)
            }
            
            if let hint = exercise.hint {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.textSecondary)
                    Text(hint)
                        .font(.sfStandard(size: 13))
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - 4. Word Order View
struct WordOrderView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var selectedWords: [String] = []
    @State private var poolWords: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ordning (Word Order)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            Text(exercise.prompt)
                .font(.sfRounded(size: 18, weight: .semibold))
                .foregroundColor(.textSecondary)
            
            // Sentence Build Area
            VStack {
                if selectedWords.isEmpty {
                    Text("Tryck på orden nedan för att bygga meningen")
                        .font(.sfStandard(size: 14))
                        .foregroundColor(.textMuted)
                        .frame(maxWidth: .infinity, minHeight: 60)
                } else {
                    FlowLayout(spacing: 8) {
                        ForEach(selectedWords, id: \.self) { word in
                            Button(action: {
                                if answeredCorrectly == nil {
                                    removeWord(word)
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
                ForEach(poolWords, id: \.self) { word in
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
            .padding(.vertical, 16)
            
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
        }
        .onAppear {
            poolWords = exercise.words.shuffled()
        }
    }
    
    private func addWord(_ word: String) {
        selectedWords.append(word)
        poolWords.removeAll { $0 == word }
    }
    
    private func removeWord(_ word: String) {
        poolWords.append(word)
        selectedWords.removeAll { $0 == word }
    }
}

// MARK: - 5. Dialogue Pick View
struct DialoguePickView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var selectedOption: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Välj passande replik (Dialogue Pick)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            // Comic/chat bubbles for prompt context
            VStack(spacing: 12) {
                // Speaker bubble
                HStack(alignment: .bottom, spacing: 10) {
                    Circle()
                        .fill(Color.accentWork)
                        .frame(width: 36, height: 36)
                        .overlay(Text("M").font(.sfRounded(size: 14, weight: .bold)).foregroundColor(.appBackground))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Maja")
                            .font(.sfRounded(size: 12, weight: .bold))
                            .foregroundColor(.textSecondary)
                        Text(exercise.prompt)
                            .font(.sfStandard(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .padding(12)
                            .background(Color.appSurfaceElevated)
                            .cornerRadius(16, corners: [.topLeft, .topRight, .bottomRight])
                    }
                    Spacer()
                }
                
                // User bubble placeholder
                HStack(alignment: .bottom, spacing: 10) {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Du (You)")
                            .font(.sfRounded(size: 12, weight: .bold))
                            .foregroundColor(.textSecondary)
                        
                        Text(selectedOption ?? "...")
                            .font(.sfStandard(size: 16, weight: .semibold))
                            .foregroundColor(selectedOption == nil ? .textMuted : .textPrimary)
                            .padding(12)
                            .background(selectedOption == nil ? Color.clear : Color.primaryBlue.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedOption == nil ? Color.textMuted.opacity(0.3) : Color.primaryBlue, lineWidth: 1)
                            )
                            .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
                    }
                    
                    Circle()
                        .fill(Color.primaryGold)
                        .frame(width: 36, height: 36)
                        .overlay(Text("DU").font(.sfRounded(size: 10, weight: .bold)).foregroundColor(.appBackground))
                }
            }
            .padding(.vertical, 10)
            
            // Choices
            VStack(spacing: 12) {
                ForEach(exercise.options, id: \.self) { option in
                    Button(action: {
                        if answeredCorrectly == nil {
                            selectedOption = option
                            onAnswerSubmitted(option)
                        }
                    }) {
                        Text(option)
                            .font(.sfStandard(size: 15, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .multilineTextAlignment(.leading)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                selectedOption == option ?
                                    (answeredCorrectly == true ? Color.appSuccess.opacity(0.2) :
                                     answeredCorrectly == false ? Color.appError.opacity(0.2) : Color.primaryBlue.opacity(0.2))
                                    : Color.appSurface
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        selectedOption == option ?
                                            (answeredCorrectly == true ? Color.appSuccess :
                                             answeredCorrectly == false ? Color.appError : Color.primaryBlue)
                                            : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .cornerRadius(16)
                    }
                    .disabled(answeredCorrectly != nil)
                    .offset(x: (selectedOption == option && shakeTrigger) ? -10 : 0)
                    .animation(
                        (selectedOption == option && shakeTrigger) ?
                            .spring(response: 0.12, dampingFraction: 0.2).repeatCount(3, autoreverses: true) :
                            .default,
                        value: shakeTrigger
                    )
                }
            }
        }
    }
}

// MARK: - 6. Conversation Sim View
struct ConversationSimView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var selectedOption: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Konversationssimulering (Conversation Sim)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            Text(exercise.prompt)
                .font(.sfRounded(size: 17, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(exercise.options, id: \.self) { option in
                    Button(action: {
                        if answeredCorrectly == nil {
                            selectedOption = option
                            onAnswerSubmitted(option)
                        }
                    }) {
                        Text(option)
                            .font(.sfStandard(size: 15, weight: .medium))
                            .foregroundColor(.textPrimary)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                selectedOption == option ?
                                    (answeredCorrectly == true ? Color.appSuccess.opacity(0.2) :
                                     answeredCorrectly == false ? Color.appError.opacity(0.2) : Color.primaryBlue.opacity(0.2))
                                    : Color.appSurface
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        selectedOption == option ?
                                            (answeredCorrectly == true ? Color.appSuccess :
                                             answeredCorrectly == false ? Color.appError : Color.primaryBlue)
                                            : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .cornerRadius(14)
                    }
                    .disabled(answeredCorrectly != nil)
                    .offset(x: (selectedOption == option && shakeTrigger) ? -10 : 0)
                    .animation(
                        (selectedOption == option && shakeTrigger) ?
                            .spring(response: 0.12, dampingFraction: 0.2).repeatCount(3, autoreverses: true) :
                            .default,
                        value: shakeTrigger
                    )
                }
            }
        }
    }
}

// MARK: - 7. Error Correction View
struct ErrorCorrectionView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var words: [String] = []
    @State private var selectedWord: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Hitta felet! Tryck på ordet som är fel (Error Correction)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            Text(exercise.prompt)
                .font(.sfRounded(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.bottom, 8)
            
            // Text tokens
            FlowLayout(spacing: 8) {
                ForEach(words, id: \.self) { word in
                    let cleanedWord = cleanWordForCheck(word)
                    
                    Button(action: {
                        if answeredCorrectly == nil {
                            selectedWord = word
                            onAnswerSubmitted(cleanedWord)
                        }
                    }) {
                        Text(word)
                            .font(.sfRounded(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                selectedWord == word ?
                                    (answeredCorrectly == true ? Color.appSuccess :
                                     answeredCorrectly == false ? Color.appError : Color.primaryBlue)
                                    : Color.appSurface
                            )
                            .cornerRadius(10)
                    }
                    .disabled(answeredCorrectly != nil)
                    .offset(x: (selectedWord == word && shakeTrigger) ? -10 : 0)
                    .animation(
                        (selectedWord == word && shakeTrigger) ?
                            .spring(response: 0.12, dampingFraction: 0.2).repeatCount(3, autoreverses: true) :
                            .default,
                        value: shakeTrigger
                    )
                }
            }
            .padding(16)
            .background(Color.appSurfaceElevated)
            .cornerRadius(16)
            
            if let hint = exercise.hint {
                Text("Tips: \(hint)")
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textSecondary)
                    .padding(.top, 4)
            }
        }
        .onAppear {
            words = exercise.prompt.components(separatedBy: " ")
        }
    }
    
    private func cleanWordForCheck(_ word: String) -> String {
        return word.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    }
}

// MARK: - 8. Story + Quiz View
struct StoryQuizView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var selectedOption: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Berättelse & Fråga (Story & Quiz)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            // Story block
            VStack {
                Text(exercise.prompt)
                    .font(.sfStandard(size: 16))
                    .foregroundColor(.textPrimary)
                    .lineSpacing(6)
            }
            .padding(20)
            .background(Color.appSurface)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.textMuted.opacity(0.3), lineWidth: 1)
            )
            
            // Question prompt (stored in exercise.hint or just the question suffix)
            Text("Fråga: Vilket svar är rätt?")
                .font(.sfRounded(size: 16, weight: .bold))
                .foregroundColor(.textSecondary)
            
            VStack(spacing: 12) {
                ForEach(exercise.options, id: \.self) { option in
                    Button(action: {
                        if answeredCorrectly == nil {
                            selectedOption = option
                            onAnswerSubmitted(option)
                        }
                    }) {
                        Text(option)
                            .font(.sfStandard(size: 15, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                selectedOption == option ?
                                    (answeredCorrectly == true ? Color.appSuccess.opacity(0.2) :
                                     answeredCorrectly == false ? Color.appError.opacity(0.2) : Color.primaryBlue.opacity(0.2))
                                    : Color.appSurface
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        selectedOption == option ?
                                            (answeredCorrectly == true ? Color.appSuccess :
                                             answeredCorrectly == false ? Color.appError : Color.primaryBlue)
                                            : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                            .cornerRadius(14)
                    }
                    .disabled(answeredCorrectly != nil)
                    .offset(x: (selectedOption == option && shakeTrigger) ? -10 : 0)
                    .animation(
                        (selectedOption == option && shakeTrigger) ?
                            .spring(response: 0.12, dampingFraction: 0.2).repeatCount(3, autoreverses: true) :
                            .default,
                        value: shakeTrigger
                    )
                }
            }
        }
    }
}

// MARK: - 9. Sentence Builder View
struct SentenceBuilderView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var selectedWords: [String] = []
    @State private var poolWords: [String] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Bygg meningen (Sentence Builder)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            Text(exercise.prompt)
                .font(.sfRounded(size: 18, weight: .bold))
                .foregroundColor(.textPrimary)
            
            // Sentence Build Area
            VStack {
                if selectedWords.isEmpty {
                    Text("Tryck på orden nedan för att bygga meningen")
                        .font(.sfStandard(size: 14))
                        .foregroundColor(.textMuted)
                        .frame(maxWidth: .infinity, minHeight: 60)
                } else {
                    FlowLayout(spacing: 8) {
                        ForEach(selectedWords, id: \.self) { word in
                            Button(action: {
                                if answeredCorrectly == nil {
                                    removeWord(word)
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
                ForEach(poolWords, id: \.self) { word in
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
            .padding(.vertical, 16)
            
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
        }
        .onAppear {
            poolWords = exercise.words.shuffled()
        }
    }
    
    private func addWord(_ word: String) {
        selectedWords.append(word)
        poolWords.removeAll { $0 == word }
    }
    
    private func removeWord(_ word: String) {
        poolWords.append(word)
        selectedWords.removeAll { $0 == word }
    }
}

// MARK: - Flow Layout Helper (Wrapping tags view)
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let width = proposal.width ?? 320
        
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > width {
                // Next line
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
        totalHeight = currentY + lineHeight
        
        return CGSize(width: width, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let width = bounds.width
        
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var lineHeight: CGFloat = 0
        
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            if currentX + size.width > bounds.minX + width {
                // Next line
                currentX = bounds.minX
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: ProposedViewSize(size))
            lineHeight = max(lineHeight, size.height)
            currentX += size.width + spacing
        }
    }
}

// MARK: - Corners Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - 10. Grammar Parsing View
struct GrammarParsingView: View {
    let exercise: Exercise
    let answeredCorrectly: Bool?
    let shakeTrigger: Bool
    let onAnswerSubmitted: (String) -> Void
    
    @State private var selectedWords: [String] = []
    @State private var poolWords: [String] = []
    
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
