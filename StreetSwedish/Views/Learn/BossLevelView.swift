import SwiftUI
import Combine

public struct BossLevelView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    public let bossLevel: BossLevel
    
    // Boss State Machine
    @State private var currentRoundIndex = 0
    @State private var currentItemIndex = 0
    @State private var score = 0
    @State private var totalQuestions = 0
    
    @State private var isIntroPlaying = true
    @State private var isFinished = false
    @State private var selectedAnswer: String? = nil
    @State private var isCorrect: Bool? = nil
    @State private var textInput = ""
    @State private var tokenBuildWords: [String] = []
    
    // Speed Recognition Timer
    @State private var timeLeft: Double = 3.0
    @State private var timerSubscription: Timer.TimerPublisher = Timer.publish(every: 0.1, on: .main, in: .common)
    @State private var timerConnected: Cancellable? = nil
    
    // Scrambled builder state for Round 2 & 3
    @State private var selectedWords: [String] = []
    @State private var poolWords: [String] = []
    
    // Haptics
    @StateObject private var speechHelper = SpeechHelper.shared
    
    public init(bossLevel: BossLevel) {
        self.bossLevel = bossLevel
    }
    
    public var body: some View {
        ZStack {
            // Dark Boss themed background
            Color.appBackground
                .ignoresSafeArea()
            
            // Subtle geometric floating background shapes
            Canvas { context, size in
                context.fill(Path(ellipseIn: CGRect(x: -50, y: -50, width: 250, height: 250)), with: .color(Color.primaryGold.opacity(0.02)))
                context.fill(Path(CGRect(x: size.width - 150, y: size.height - 300, width: 200, height: 200)), with: .color(Color.primaryBlue.opacity(0.02)))
            }
            .ignoresSafeArea()
            
            if isIntroPlaying {
                introView()
            } else if isFinished {
                resultsView()
            } else {
                gameplayView()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            totalQuestions = bossLevel.rounds.reduce(0) { $0 + $1.itemCount }
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - 1. Intro View
    private func introView() -> some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.primaryGold)
                    .shadow(color: .primaryGold.opacity(0.3), radius: 20)
                
                Text("BOSSNIVÅ")
                    .font(.sfRounded(size: 36, weight: .black))
                    .foregroundColor(.textPrimary)
                    .tracking(2.0)
                
                Text("Testa dina kunskaper på hela Arbete & Tech modulen. Inga tips, inga livlinor. Bara din hjärna.")
                    .font(.sfStandard(size: 16))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(32)
            .background(Color.appSurface)
            .cornerRadius(28)
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeIn(duration: 0.3)) {
                    isIntroPlaying = false
                    startRound(0)
                }
            }) {
                Text("Starta utmaningen")
                    .font(.sfRounded(size: 16, weight: .bold))
                    .foregroundColor(.appBackground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primaryGold)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - 2. Gameplay View
    private func gameplayView() -> some View {
        let currentRound = bossLevel.rounds[currentRoundIndex]
        
        return VStack(spacing: 0) {
            // Header stats
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.textMuted)
                        .font(.title3)
                }
                
                Spacer()
                
                Text("RUNDA \(currentRound.number)/\(bossLevel.rounds.count)")
                    .font(.sfRounded(size: 14, weight: .black))
                    .foregroundColor(.primaryGold)
                    .tracking(1.0)
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.sfRounded(size: 14, weight: .bold))
                    .foregroundColor(.textSecondary)
            }
            .padding(20)
            
            // Round type name banner
            Text(roundName(currentRound.type))
                .font(.sfRounded(size: 12, weight: .bold))
                .foregroundColor(.appBackground)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.primaryBlue)
                .cornerRadius(8)
                .padding(.bottom, 24)
            
            // Timer for Round 1
            if currentRound.type == .speedRecognition {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.appSurface)
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(timeLeft < 1.0 ? Color.appError : Color.primaryGold)
                            .frame(width: geo.size.width * CGFloat(timeLeft / 3.0), height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            
            // Main quiz content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    renderQuestionContent(roundType: currentRound.type)
                }
                .padding(20)
            }
            
            // Bottom Check button (for manual entry rounds)
            if currentRound.type == .sentenceReconstruction || currentRound.type == .translationSprint {
                if isCorrect == nil {
                    Button(action: {
                        checkManualAnswer(roundType: currentRound.type)
                    }) {
                        Text("Kontrollera")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isInputEmpty(roundType: currentRound.type) ? Color.textMuted : Color.primaryGold)
                            .cornerRadius(16)
                    }
                    .disabled(isInputEmpty(roundType: currentRound.type))
                    .padding(20)
                }
            }
            
            // Next question feedback banner
            if let result = isCorrect {
                VStack(spacing: 14) {
                    HStack {
                        Image(systemName: result ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(result ? .appSuccess : .appError)
                        Text(result ? "Rätt!" : "Fel!")
                            .font(.sfRounded(size: 18, weight: .bold))
                            .foregroundColor(result ? .appSuccess : .appError)
                        Spacer()
                    }
                    
                    Button(action: {
                        advanceQuestion()
                    }) {
                        Text("Nästa")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.primaryGold)
                            .cornerRadius(12)
                    }
                }
                .padding(20)
                .background(result ? Color.appSuccess.opacity(0.15) : Color.appError.opacity(0.15))
                .cornerRadius(24, corners: [.topLeft, .topRight])
            }
        }
        .onReceive(timerSubscription) { _ in
            if currentRound.type == .speedRecognition && isCorrect == nil {
                if timeLeft > 0.1 {
                    timeLeft -= 0.1
                } else {
                    timeLeft = 0
                    // Time out is incorrect
                    isCorrect = false
                    stopTimer()
                    triggerHaptic(.error)
                }
            }
        }
    }
    
    // MARK: - Render Question Contents
    @ViewBuilder
    private func renderQuestionContent(roundType: BossRoundType) -> some View {
        let word = getVocabForCurrentIndex()
        
        switch roundType {
        case .speedRecognition:
            VStack(spacing: 24) {
                Text(word.swedish)
                    .font(.sfRounded(size: 36, weight: .bold))
                    .foregroundColor(.primaryGold)
                    .padding(.vertical, 12)
                
                VStack(spacing: 12) {
                    let options = getSpeedOptions(correctWord: word)
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selectSpeedAnswer(option: option, correctOption: word.english)
                        }) {
                            Text(option)
                                .font(.sfStandard(size: 15, weight: .semibold))
                                .foregroundColor(.textPrimary)
                                .padding(16)
                                .frame(maxWidth: .infinity)
                                .background(Color.appSurface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(selectedAnswer == option ? (isCorrect == true ? Color.appSuccess : Color.appError) : Color.clear, lineWidth: 2)
                                )
                                .cornerRadius(14)
                        }
                        .disabled(isCorrect != nil)
                    }
                }
            }
            
        case .sentenceReconstruction:
            // Scrambled builder
            VStack(alignment: .leading, spacing: 20) {
                Text("Bygg meningen:")
                    .font(.sfRounded(size: 14, weight: .bold))
                    .foregroundColor(.textMuted)
                
                Text(getScrambledPrompt())
                    .font(.sfRounded(size: 18, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                // Build area
                VStack {
                    if selectedWords.isEmpty {
                        Text("Tryck på orden nedan...")
                            .foregroundColor(.textMuted)
                            .frame(maxWidth: .infinity, minHeight: 60)
                    } else {
                        FlowLayout(spacing: 8) {
                            ForEach(selectedWords, id: \.self) { w in
                                Button(action: {
                                    if isCorrect == nil {
                                        poolWords.append(w)
                                        selectedWords.removeAll { $0 == w }
                                    }
                                }) {
                                    Text(w)
                                        .font(.sfRounded(size: 14, weight: .bold))
                                        .foregroundColor(.textPrimary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.primaryBlue)
                                        .cornerRadius(10)
                                }
                                .disabled(isCorrect != nil)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
                .background(Color.appSurface)
                .cornerRadius(16)
                
                // Word Pool
                FlowLayout(spacing: 8) {
                    ForEach(poolWords, id: \.self) { w in
                        Button(action: {
                            if isCorrect == nil {
                                selectedWords.append(w)
                                poolWords.removeAll { $0 == w }
                            }
                        }) {
                            Text(w)
                                .font(.sfRounded(size: 14, weight: .bold))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.appSurfaceElevated)
                                .cornerRadius(10)
                        }
                        .disabled(isCorrect != nil)
                    }
                }
                .padding(.top, 12)
            }
            
        case .scenario:
            // Dialogue scenario pick
            VStack(alignment: .leading, spacing: 20) {
                Text("Maja:")
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.accentWork)
                
                Text("Hinner du kolla min code review innan du drar hem?")
                    .font(.sfStandard(size: 16, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .padding(16)
                    .background(Color.appSurface)
                    .cornerRadius(16)
                
                Text("Välj bästa svar:")
                    .font(.sfRounded(size: 14, weight: .bold))
                    .foregroundColor(.textMuted)
                
                VStack(spacing: 12) {
                    let choices = ["Ja, jag är på det! Länka på Slack.", "Nej, jag hatar koden.", "Jag skiter i dig."]
                    ForEach(choices, id: \.self) { option in
                        Button(action: {
                            selectedAnswer = option
                            isCorrect = option == choices[0]
                            if isCorrect == true {
                                score += 1
                                triggerHaptic(.success)
                            } else {
                                triggerHaptic(.error)
                            }
                        }) {
                            Text(option)
                                .font(.sfStandard(size: 15, weight: .semibold))
                                .foregroundColor(.textPrimary)
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.appSurface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(selectedAnswer == option ? (isCorrect == true ? Color.appSuccess : Color.appError) : Color.clear, lineWidth: 2)
                                )
                                .cornerRadius(14)
                        }
                        .disabled(isCorrect != nil)
                    }
                }
            }
            
        case .errorHunter:
            // Error hunting in sentences
            VStack(alignment: .leading, spacing: 20) {
                Text("Hitta ordet som är fel i meningen:")
                    .font(.sfRounded(size: 16, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                let sentence = "Vi måste sajna kunden ASAP klockan nio fredagsmyset"
                let words = sentence.components(separatedBy: " ")
                
                FlowLayout(spacing: 8) {
                    ForEach(words, id: \.self) { w in
                        Button(action: {
                            selectedAnswer = w
                            isCorrect = w == "fredagsmyset"
                            if isCorrect == true {
                                score += 1
                                triggerHaptic(.success)
                            } else {
                                triggerHaptic(.error)
                            }
                        }) {
                            Text(w)
                                .font(.sfRounded(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selectedAnswer == w ? (isCorrect == true ? Color.appSuccess : Color.appError) : Color.appSurface)
                                .cornerRadius(10)
                        }
                        .disabled(isCorrect != nil)
                    }
                }
                .padding(16)
                .background(Color.appSurfaceElevated)
                .cornerRadius(16)
            }
            
        case .translationSprint:
            // Translate EN to SV
            VStack(alignment: .leading, spacing: 20) {
                Text("Översätt till svenska:")
                    .font(.sfRounded(size: 15, weight: .bold))
                    .foregroundColor(.textMuted)
                
                Text(getTranslationPrompt())
                    .font(.sfRounded(size: 22, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                TextField("Skriv här...", text: $textInput)
                    .font(.sfStandard(size: 16))
                    .padding(18)
                    .background(Color.appSurface)
                    .foregroundColor(.textPrimary)
                    .cornerRadius(16)
                    .disabled(isCorrect != nil)
            }
        }
    }
    
    // MARK: - 3. Results View
    private func resultsView() -> some View {
        let pct = Double(score) / Double(totalQuestions)
        let isGold = pct >= bossLevel.passThreshold
        let isBronze = pct >= bossLevel.partialThreshold && pct < bossLevel.passThreshold
        
        return VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: isGold ? "crown.fill" : isBronze ? "medal.fill" : "xmark.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(isGold ? .primaryGold : isBronze ? .accentStreet : .appError)
                
                Text(isGold ? "Guld!" : isBronze ? "Brons" : "Misslyckades")
                    .font(.sfRounded(size: 32, weight: .black))
                    .foregroundColor(isGold ? .primaryGold : isBronze ? .accentStreet : .appError)
                
                Text("Du fick \(score) av \(totalQuestions) rätt (\(Int(pct * 100))%)")
                    .font(.sfRounded(size: 18, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                if isGold {
                    Text("Grymt! Du har klarat modulen och låst upp Elitfraser.")
                        .font(.sfStandard(size: 15))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                } else if isBronze {
                    Text("Inte illa, men du behöver 80% för Guld. Försök igen eller plugga mer i ordboken.")
                        .font(.sfStandard(size: 15))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                } else {
                    Text("Du klarade inte gränsen. De svåraste orden har lagts till i din repetition.")
                        .font(.sfStandard(size: 15))
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
            }
            .padding(32)
            .background(Color.appSurface)
            .cornerRadius(28)
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                // Save boss level outcome
                let status: BossStatus = isGold ? .gold : isBronze ? .bronze : .unlocked
                let xp = isGold ? 150 : isBronze ? 80 : 20
                progressManager.completeBossLevel(moduleID: bossLevel.moduleID, status: status, xpEarned: xp)
                dismiss()
            }) {
                Text("Klar")
                    .font(.sfRounded(size: 16, weight: .bold))
                    .foregroundColor(.appBackground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primaryGold)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }
    
    // MARK: - Game Loop Helpers
    private func startRound(_ index: Int) {
        currentRoundIndex = index
        currentItemIndex = 0
        setupQuestion()
    }
    
    private func setupQuestion() {
        isCorrect = nil
        selectedAnswer = nil
        textInput = ""
        
        let round = bossLevel.rounds[currentRoundIndex]
        
        if round.type == .speedRecognition {
            timeLeft = 3.0
            startTimer()
        } else if round.type == .sentenceReconstruction {
            let sentence = getScrambledPrompt()
            poolWords = sentence.components(separatedBy: " ").shuffled()
            selectedWords = []
        }
    }
    
    private func advanceQuestion() {
        let round = bossLevel.rounds[currentRoundIndex]
        
        if currentItemIndex < round.itemCount - 1 {
            // Next item in current round
            currentItemIndex += 1
            setupQuestion()
        } else if currentRoundIndex < bossLevel.rounds.count - 1 {
            // Next round
            currentRoundIndex += 1
            currentItemIndex = 0
            setupQuestion()
        } else {
            // Finished!
            isFinished = true
            stopTimer()
        }
    }
    
    // MARK: - Data builders
    private func getVocabForCurrentIndex() -> VocabItem {
        let vocabIndex = (currentRoundIndex * 5 + currentItemIndex) % LessonData.allVocabItems.count
        return LessonData.allVocabItems[vocabIndex]
    }
    
    private func getSpeedOptions(correctWord: VocabItem) -> [String] {
        var options = [correctWord.english]
        let otherVocab = LessonData.allVocabItems.filter { $0.id != correctWord.id }
        for _ in 0..<3 {
            if let randomWord = otherVocab.randomElement() {
                options.append(randomWord.english)
            }
        }
        return options.shuffled()
    }
    
    private func getScrambledPrompt() -> String {
        let sentences = [
            "Vi tar det på vår standup",
            "Jag är på det klockan nio",
            "Pinga mig på Slack kran",
            "Sluta gnälla på koden nu",
            "Ska du med på AW ikväll"
        ]
        return sentences[currentItemIndex % sentences.count]
    }
    
    private func getTranslationPrompt() -> String {
        let prompts = [
            "I have to stay home with a sick child",
            "Coffee and cake break with colleagues",
            "To take it offline",
            "Friday cozy wind down",
            "To ignore that bug"
        ]
        return prompts[currentItemIndex % prompts.count]
    }
    
    private func getTranslationCorrectAnswer() -> String {
        let answers = [
            "jag måste vabba",
            "fika",
            "ta det offline",
            "fredagsmys",
            "skita i"
        ]
        return answers[currentItemIndex % answers.count]
    }
    
    // MARK: - Validation
    private func selectSpeedAnswer(option: String, correctOption: String) {
        stopTimer()
        selectedAnswer = option
        isCorrect = option == correctOption
        if isCorrect == true {
            score += 1
            triggerHaptic(.success)
        } else {
            triggerHaptic(.error)
        }
    }
    
    private func checkManualAnswer(roundType: BossRoundType) {
        if roundType == .sentenceReconstruction {
            let fullSentence = selectedWords.joined(separator: " ")
            let correct = getScrambledPrompt()
            isCorrect = fullSentence.lowercased() == correct.lowercased()
        } else if roundType == .translationSprint {
            let correct = getTranslationCorrectAnswer()
            isCorrect = textInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().contains(correct.lowercased())
        }
        
        if isCorrect == true {
            score += 1
            triggerHaptic(.success)
        } else {
            triggerHaptic(.error)
        }
    }
    
    private func isInputEmpty(roundType: BossRoundType) -> Bool {
        if roundType == .sentenceReconstruction {
            return selectedWords.isEmpty
        } else if roundType == .translationSprint {
            return textInput.isEmpty
        }
        return false
    }
    
    private func roundName(_ type: BossRoundType) -> String {
        switch type {
        case .speedRecognition: return "SNABBTÄNKARE (SPEED RECOGNITION)"
        case .sentenceReconstruction: return "ORDNING (RECONSTRUCTION)"
        case .scenario: return "SCENARIOT (SCENARIO)"
        case .errorHunter: return "FELJÄGARE (ERROR HUNTER)"
        case .translationSprint: return "ÖVERSÄTTNING (TRANSLATION)"
        }
    }
    
    // MARK: - Timer
    private func startTimer() {
        timerSubscription = Timer.publish(every: 0.1, on: .main, in: .common)
        timerConnected = timerSubscription.connect()
    }
    
    private func stopTimer() {
        timerConnected?.cancel()
        timerConnected = nil
    }
    
    // MARK: - Haptic triggers
    private enum HapticType {
        case success, error
    }
    
    private func triggerHaptic(_ type: HapticType) {
        switch type {
        case .success:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}
