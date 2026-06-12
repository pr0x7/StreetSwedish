import SwiftUI

public struct LessonView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    @StateObject private var coordinator: LessonCoordinator
    @StateObject private var speechHelper = SpeechHelper.shared
    
    @State private var introStack: [VocabItem] = []
    
    public init(lesson: Lesson) {
        _coordinator = StateObject(wrappedValue: LessonCoordinator(lesson: lesson))
    }
    
    public var body: some View {
        ZStack {
            // Background
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Lesson Progress Header
                HStack(spacing: 12) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.textMuted)
                    }
                    
                    // Progress Bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.appSurface)
                                .frame(height: 10)
                            
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.primaryBlue, Color.primaryGold],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * CGFloat(coordinator.progressFraction), height: 10)
                        }
                    }
                    .frame(height: 10)
                    
                    Text("\(Int(coordinator.progressFraction * 100))%")
                        .font(.sfRounded(size: 12, weight: .bold))
                        .foregroundColor(.textSecondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                // Act Header Indicator
                Text(coordinator.currentAct.name)
                    .font(.sfRounded(size: 13, weight: .bold))
                    .foregroundColor(.primaryGold)
                    .tracking(1.0)
                    .padding(.bottom, 16)
                
                // Main Content Area based on current Act
                ZStack {
                    switch coordinator.currentAct {
                    case .sceneSetting:
                        act1SceneSettingView()
                        
                    case .wordIntroductions:
                        act2WordIntroductionsView()
                        
                    case .recognitionDrill, .contextDrill:
                        act3And4DrillsView()
                        
                    case .miniDialogue:
                        act5DialogueView()
                        
                    case .lessonSummary:
                        act6LessonSummaryView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Bottom Feedback Banner for Exercises (Acts 3 & 4)
                if coordinator.currentAct == .recognitionDrill || coordinator.currentAct == .contextDrill {
                    exerciseFeedbackBanner()
                }
            }
            
            // Full Screen Completion Overlay
            if coordinator.showCelebration {
                celebrationOverlay()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Prepare cards for introduction
            introStack = coordinator.lesson.vocabItems
        }
    }
    
    // MARK: - Act 1: Scene Setting
    private func act1SceneSettingView() -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                // Character badge or custom icon
                Circle()
                    .fill(Color.appSurfaceElevated)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "safari.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.primaryGold)
                    )
                
                Text("KULTURELL KONTEXT")
                    .font(.sfRounded(size: 13, weight: .bold))
                    .foregroundColor(.textMuted)
                    .tracking(2.0)
                
                if let card = coordinator.lesson.culturalContextCard {
                    Text(card.bodyText)
                        .font(.sfStandard(size: 17))
                        .foregroundColor(.textPrimary)
                        .lineSpacing(6)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
            }
            .padding(24)
            .background(Color.appSurface)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.25), radius: 15, y: 5)
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    coordinator.nextStep(onComplete: finishLessonProgress)
                }
            }) {
                Text("Börja lektionen")
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
    
    // MARK: - Act 2: Word Introductions
    private func act2WordIntroductionsView() -> some View {
        ZStack {
            if introStack.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.appSuccess)
                    
                    Text("Alla ord introducerade!")
                        .font(.sfRounded(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            coordinator.nextStep(onComplete: finishLessonProgress)
                        }
                    }) {
                        Text("Gå vidare till övningar")
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.appBackground)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.primaryGold)
                            .cornerRadius(12)
                    }
                }
            } else {
                ForEach(introStack, id: \.id) { vocabItem in
                    // Render stack: only the top card is swipeable
                    if vocabItem.id == introStack.last?.id {
                        WordCard(
                            item: vocabItem,
                            onSwipeRight: {
                                withAnimation {
                                    // Got it, pop from stack
                                    _ = introStack.popLast()
                                    // In a real SRS, we initialize it to Stage 1 (Introduced)
                                    srsScheduler.recordResponse(itemID: vocabItem.id, isCorrect: true, responseQuality: 0.8)
                                    
                                    // Advance coordinator step
                                    coordinator.nextStep(onComplete: finishLessonProgress)
                                }
                            },
                            onSwipeLeft: {
                                // Review again, move card to bottom of the stack
                                withAnimation {
                                    let card = introStack.removeLast()
                                    introStack.insert(card, at: 0)
                                }
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    } else {
                        // Background card mockup (smaller, offset)
                        Color.appSurface
                            .cornerRadius(24)
                            .shadow(radius: 5)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 28)
                            .scaleEffect(0.95)
                            .opacity(0.5)
                    }
                }
            }
        }
    }
    
    // MARK: - Acts 3 & 4: Drills View
    private func act3And4DrillsView() -> some View {
        VStack {
            if let exercise = coordinator.currentExercise {
                ScrollView {
                    ExerciseRouter(
                        exercise: exercise,
                        answeredCorrectly: coordinator.answeredCorrectly,
                        shakeTrigger: coordinator.shakeTrigger,
                        onAnswerSubmitted: { answer in
                            coordinator.submitAnswer(answer: answer, scheduler: srsScheduler) {
                                // On correct answer: trigger haptic and auto advance after 0.8s
                                triggerHaptic(.success)
                                DispatchQueue.main.asyncAfter(deadline: .now() + coordinator.lesson.autoAdvanceDelay) {
                                    withAnimation {
                                        coordinator.nextStep(onComplete: finishLessonProgress)
                                    }
                                }
                            }
                            
                            if coordinator.answeredCorrectly == false {
                                triggerHaptic(.error)
                            }
                        }
                    )
                }
            }
        }
    }
    
    // Exercise Feedback Banner
    private func exerciseFeedbackBanner() -> some View {
        Group {
            if let result = coordinator.answeredCorrectly {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                        Image(systemName: result ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(result ? .appSuccess : .appError)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result ? "Grymt!" : "Oj, fel svar!")
                                .font(.sfRounded(size: 18, weight: .bold))
                                .foregroundColor(result ? .appSuccess : .appError)
                            
                            if !result, let exercise = coordinator.currentExercise {
                                Text("Rätt svar: \(exercise.correctAnswer)")
                                    .font(.sfStandard(size: 14, weight: .medium))
                                    .foregroundColor(.textPrimary)
                            }
                        }
                        Spacer()
                    }
                    
                    if !result {
                        // Friction: manual tap to continue after error
                        Button(action: {
                            withAnimation {
                                coordinator.nextStep(onComplete: finishLessonProgress)
                            }
                        }) {
                            Text("Fortsätt")
                                .font(.sfRounded(size: 16, weight: .bold))
                                .foregroundColor(.appBackground)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.primaryGold)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(20)
                .background(result ? Color.appSuccess.opacity(0.15) : Color.appError.opacity(0.15))
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    // MARK: - Act 5: Mini Dialogue
    @State private var activeDialogueBubbleIndex = 0
    
    private func act5DialogueView() -> some View {
        VStack(spacing: 20) {
            Text("Läs dialogen kran (Read along)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.0)
            
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(0...coordinator.currentStepIndex, id: \.self) { index in
                            let line = coordinator.dialogueLines[index]
                            let isUser = line.speakerID == coordinator.userSpeakerID
                            
                            HStack {
                                if isUser { Spacer() }
                                
                                VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                                    // Speaker name label
                                    Text(isUser ? "Du (You)" : line.speakerID.capitalized)
                                        .font(.sfRounded(size: 11, weight: .bold))
                                        .foregroundColor(.textSecondary)
                                    
                                    // Message Bubble
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
                                .id(index)
                                
                                if !isUser { Spacer() }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .onChange(of: coordinator.currentStepIndex) { newIndex in
                    withAnimation(.easeOut) {
                        scrollProxy.scrollTo(newIndex, anchor: .bottom)
                    }
                }
            }
            
            Button(action: {
                withAnimation {
                    coordinator.nextStep(onComplete: finishLessonProgress)
                }
            }) {
                Text(coordinator.currentStepIndex == coordinator.dialogueLines.count - 1 ? "Fortsätt" : "Nästa replik")
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
    
    // MARK: - Act 6: Lesson Summary
    private func act6LessonSummaryView() -> some View {
        VStack(spacing: 20) {
            Text("ORDLISTA FRÅN LEKTIONEN (VOCAB RECAP)")
                .font(.sfRounded(size: 13, weight: .bold))
                .foregroundColor(.textMuted)
                .tracking(1.5)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(coordinator.lesson.vocabItems) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.swedish)
                                    .font(.sfRounded(size: 18, weight: .bold))
                                    .foregroundColor(.primaryGold)
                                Text(item.english)
                                    .font(.sfStandard(size: 14))
                                    .foregroundColor(.textSecondary)
                            }
                            Spacer()
                            
                            Button(action: {
                                speechHelper.speak(item.swedish, itemID: item.id, rate: progressManager.progress.ttsRate)
                            }) {
                                Image(systemName: speechHelper.isSpeaking && speechHelper.currentlySpeakingID == item.id ? "speaker.wave.3.fill" : "speaker.wave.2")
                                    .foregroundColor(.primaryBlue)
                                    .padding(10)
                                    .background(Color.appSurfaceElevated)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(16)
                        .background(Color.appSurface)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Button(action: {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                    coordinator.nextStep(onComplete: finishLessonProgress)
                }
            }) {
                Text("Klar!")
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
    
    // MARK: - Completion & Celebration
    private func finishLessonProgress(xp: Int) {
        // Log in progress manager
        progressManager.completeLesson(
            lessonID: coordinator.lesson.id,
            moduleID: coordinator.lesson.moduleID,
            categoryID: coordinator.lesson.moduleID,
            xpEarned: xp
        )
        triggerHaptic(.celebration)
    }
    
    // Celebration Overlay View
    private func celebrationOverlay() -> some View {
        ZStack {
            // Semi-transparent dim background
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            // Confetti
            ConfettiEmitterView()
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Animated character avatar
                Circle()
                    .fill(Color.appSurfaceElevated)
                    .frame(width: 130, height: 130)
                    .overlay(
                        Text("🇸🇪")
                            .font(.system(size: 64))
                    )
                    .scaleEffect(1.0)
                    .shadow(color: Color.primaryGold.opacity(0.3), radius: 15, y: 10)
                
                VStack(spacing: 8) {
                    Text("Lektion avklarad!")
                        .font(.sfRounded(size: 28, weight: .bold))
                        .foregroundColor(.primaryGold)
                    
                    Text("Grymt jobbat! Du lär dig fort.")
                        .font(.sfStandard(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
                
                // XP Earned visualizer
                HStack(spacing: 12) {
                    Image(systemName: "bolt.fill")
                        .font(.title)
                        .foregroundColor(.primaryGold)
                    
                    Text("+\(coordinator.xpEarned) XP")
                        .font(.sfRounded(size: 34, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.appSurface)
                .cornerRadius(20)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Fortsätt till kartan")
                        .font(.sfRounded(size: 16, weight: .bold))
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primaryGold)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
    
    // MARK: - Haptic triggers
    private enum HapticType {
        case success, error, celebration
    }
    
    private func triggerHaptic(_ type: HapticType) {
        switch type {
        case .success:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .celebration:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

// MARK: - Confetti Particle System (SwiftUI implementation)
struct ConfettiEmitterView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    var contextCopy = context
                    contextCopy.translateBy(x: particle.x, y: particle.y)
                    contextCopy.rotate(by: Angle(degrees: particle.rotation))
                    
                    let shapeRect = CGRect(x: -particle.size/2, y: -particle.size/2, width: particle.size, height: particle.size)
                    
                    if particle.isCircle {
                        contextCopy.fill(Path(ellipseIn: shapeRect), with: .color(particle.color))
                    } else {
                        contextCopy.fill(Path(shapeRect), with: .color(particle.color))
                    }
                }
            }
            .onAppear {
                createConfetti()
            }
            .onChange(of: timeline.date) { _ in
                updateConfetti()
            }
        }
    }
    
    private func createConfetti() {
        let colors: [Color] = [.primaryGold, .primaryBlue, .appSuccess, .accentWork, .accentStreet, .accentSMS]
        var newParticles: [ConfettiParticle] = []
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<100 {
            newParticles.append(
                ConfettiParticle(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: -screenHeight...0),
                    vx: CGFloat.random(in: -3...3),
                    vy: CGFloat.random(in: 4...9),
                    size: CGFloat.random(in: 6...14),
                    color: colors.randomElement() ?? .primaryGold,
                    rotation: Double.random(in: 0...360),
                    vRotation: Double.random(in: -5...5),
                    isCircle: Bool.random()
                )
            )
        }
        particles = newParticles
    }
    
    private func updateConfetti() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        for i in 0..<particles.count {
            particles[i].x += particles[i].vx
            particles[i].y += particles[i].vy
            particles[i].rotation += particles[i].vRotation
            
            // Loop particles back to the top if they go off screen
            if particles[i].y > screenHeight {
                particles[i].y = -20
                particles[i].x = CGFloat.random(in: 0...screenWidth)
                particles[i].vy = CGFloat.random(in: 4...9)
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var vx: CGFloat
    var vy: CGFloat
    var size: CGFloat
    var color: Color
    var rotation: Double
    var vRotation: Double
    var isCircle: Bool
}
