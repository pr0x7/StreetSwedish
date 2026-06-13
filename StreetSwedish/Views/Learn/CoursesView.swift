import SwiftUI

public struct CoursesView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    @State private var selectedCategory = "work_tech"
    @State private var showingLesson: Lesson? = nil
    @State private var showingBossLevel: BossLevel? = nil
    @State private var selectedLessonForDetails: Lesson? = nil
    
    // Breathing scale state for active node
    @State private var breathScale: CGFloat = 1.0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category Headers Tab
                    categoryHeaderSelector()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 24) {
                            
                            // Introduction Header of Module
                            moduleHeaderCard()
                            
                            // Vertical Lesson Node Tree
                            VStack(spacing: 36) {
                                let module = LessonData.allModules.first { $0.categoryID == selectedCategory }
                                
                                if let mod = module {
                                    // Render lessons
                                    let lessons = LessonData.allLessons.filter { $0.moduleID == mod.id }
                                    
                                    ForEach(Array(lessons.enumerated()), id: \.element.id) { index, lesson in
                                        let status = getLessonStatus(lesson)
                                        let horizontalOffset = getNodeHorizontalOffset(index)
                                        
                                        lessonNode(lesson: lesson, status: status)
                                            .offset(x: horizontalOffset)
                                    }
                                    
                                    // Boss Level Node
                                    if let bossLevel = LessonData.allBossLevels.first(where: { $0.moduleID == mod.id }) {
                                        let bossStatus = getBossLevelStatus(mod.id)
                                        bossNode(bossLevel: bossLevel, status: bossStatus)
                                            .offset(x: 0)
                                            .padding(.top, 16)
                                    }
                                } else {
                                    comingSoonNode()
                                }
                            }
                            .padding(.vertical, 32)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle(progressManager.loc("Learn", "Lär dig"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: Binding(
                get: { showingLesson != nil },
                set: { if !$0 { showingLesson = nil } }
            )) {
                if let lesson = showingLesson {
                    LessonView(lesson: lesson)
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { showingBossLevel != nil },
                set: { if !$0 { showingBossLevel = nil } }
            )) {
                if let boss = showingBossLevel {
                    BossLevelView(bossLevel: boss)
                }
            }
            .sheet(item: $selectedLessonForDetails) { lesson in
                let status = getLessonStatus(lesson)
                LessonDetailSheet(
                    lesson: lesson,
                    status: status,
                    onStart: { selected in
                        showingLesson = selected
                    },
                    onResetAndStart: { selected in
                        progressManager.progress.lessonResumeActs?[selected.id] = nil
                        progressManager.progress.lessonResumeStepIndices?[selected.id] = nil
                        progressManager.save()
                        showingLesson = selected
                    }
                )
                .environmentObject(progressManager)
            }
            .onAppear {
                startBreathingAnimation()
                let nextLesson = getNextLessonToStudy()
                if let module = LessonData.getModule(byID: nextLesson.moduleID) {
                    selectedCategory = module.categoryID
                }
            }
        }
    }
    
    // MARK: - Category Tab Selector
    private func categoryHeaderSelector() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                categoryTab(id: "work_tech", name: progressManager.loc("Work & Tech", "Jobb & Tech"), icon: "laptopcomputer", color: .accentWork)
                categoryTab(id: "street", name: progressManager.loc("Street Slang", "Gatans Språk"), icon: "figure.walk", color: .accentStreet)
                categoryTab(id: "sms", name: progressManager.loc("Text Slang", "SMS"), icon: "bubble.left.and.bubble.right.fill", color: .accentSMS)
                categoryTab(id: "social", name: progressManager.loc("Social / AW", "Socialt / AW"), icon: "wineglass.fill", color: .accentSocial)
                categoryTab(id: "dating", name: progressManager.loc("Dating", "Dating"), icon: "heart.fill", color: .accentDating)
                categoryTab(id: "swears", name: progressManager.loc("Swears", "Svordomar"), icon: "exclamationmark.bubble.fill", color: .accentSwearing)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(Color.appSurface)
    }
    
    private func categoryTab(id: String, name: String, icon: String, color: Color) -> some View {
        let isSelected = selectedCategory == id
        
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedCategory = id
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline)
                Text(name)
                    .font(.sfRounded(size: 14, weight: .bold))
            }
            .foregroundColor(isSelected ? .appBackground : .textSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? color : Color.appSurfaceElevated)
            .cornerRadius(16)
        }
    }
    
    // MARK: - Module Header Card
    private func moduleHeaderCard() -> some View {
        let module = LessonData.allModules.first { $0.categoryID == selectedCategory }
        
        return Group {
            if let mod = module {
                VStack(alignment: .leading, spacing: 8) {
                    Text(progressManager.loc("COURSE MODULE", "KURSMODUL"))
                        .font(.sfRounded(size: 11, weight: .bold))
                        .foregroundColor(.primaryGold)
                        .tracking(2.0)
                    
                    Text(mod.title)
                        .font(.sfRounded(size: 22, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Text(mod.subtitle)
                        .font(.sfStandard(size: 14))
                        .foregroundColor(.textSecondary)
                    
                    // Progress percentage
                    let percent = progressManager.progress.categoryProgressMap[mod.id] ?? 0.0
                    HStack {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.appSurfaceElevated)
                                    .frame(height: 8)
                                
                                Capsule()
                                    .fill(accentColorForCategory(selectedCategory))
                                    .frame(width: geo.size.width * CGFloat(percent), height: 8)
                            }
                        }
                        .frame(height: 8)
                        
                        Text("\(Int(percent * 100))%")
                            .font(.sfRounded(size: 12, weight: .bold))
                            .foregroundColor(.textPrimary)
                    }
                    .padding(.top, 8)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appSurface)
                .cornerRadius(20)
            }
        }
    }
    
    // MARK: - Lesson Node Button
    private enum NodeStatus {
        case locked, active, completed
    }
    
    private func lessonNode(lesson: Lesson, status: NodeStatus) -> some View {
        Button(action: {
            if status != .locked {
                selectedLessonForDetails = lesson
            }
        }) {
            VStack(spacing: 8) {
                // Circle Node
                ZStack {
                    Circle()
                        .fill(nodeBackgroundColor(status))
                        .frame(width: 76, height: 76)
                        .shadow(color: nodeShadowColor(status), radius: status == .active ? 15 : 5, y: 5)
                        .scaleEffect(status == .active ? breathScale : 1.0)
                    
                    // Icon overlay
                    Group {
                        switch status {
                        case .locked:
                            Image(systemName: "lock.fill")
                                .font(.title3)
                                .foregroundColor(.textMuted)
                        case .active:
                            Image(systemName: "play.fill")
                                .font(.title)
                                .foregroundColor(.appBackground)
                        case .completed:
                            Image(systemName: "checkmark")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Floating Resume badge if has in-progress state
                    if progressManager.progress.lessonResumeActs?[lesson.id] != nil {
                        Text(progressManager.loc("RESUME", "FORTSÄTT"))
                            .font(.sfRounded(size: 8, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.accentStreet)
                            .cornerRadius(6)
                            .offset(y: -44)
                    }
                }
                
                // Title
                Text(lesson.title)
                    .font(.sfRounded(size: 13, weight: .bold))
                    .foregroundColor(status == .locked ? .textMuted : .textPrimary)
                    .multilineTextAlignment(.center)
                    .frame(width: 120)
            }
        }
        .disabled(status == .locked)
    }
    
    // MARK: - Boss Node Button
    private func bossNode(bossLevel: BossLevel, status: NodeStatus) -> some View {
        Button(action: {
            if status != .locked {
                showingBossLevel = bossLevel
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(status == .locked ? Color.appSurfaceElevated : Color.primaryGold)
                        .frame(width: 90, height: 90)
                        .shadow(color: status != .locked ? Color.primaryGold.opacity(0.4) : Color.clear, radius: 15)
                    
                    Image(systemName: "crown.fill")
                        .font(.system(size: 38))
                        .foregroundColor(status == .locked ? .textMuted : .appBackground)
                }
                
                Text(progressManager.loc("BOSS LEVEL", "BOSSNIVÅ"))
                    .font(.sfRounded(size: 12, weight: .black))
                    .foregroundColor(status == .locked ? .textMuted : .primaryGold)
                    .tracking(1.0)
            }
        }
        .disabled(status == .locked)
    }
    
    // MARK: - Coming Soon Node
    private func comingSoonNode() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "tray.and.arrow.down")
                .font(.system(size: 44))
                .foregroundColor(.textMuted)
            
            Text(progressManager.loc("New lessons on the way!", "Nya lektioner på väg!"))
                .font(.sfRounded(size: 18, weight: .bold))
                .foregroundColor(.textSecondary)
            
            Text(progressManager.loc("We are working on slang for bars, swearing, and text messaging. Stay tuned!", "Vi jobbar på slang för barer, svordomar och sms. Håll ut!"))
                .font(.sfStandard(size: 14))
                .foregroundColor(.textMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .padding(.vertical, 48)
    }
    
    // MARK: - Helpers
    private func getLessonStatus(_ lesson: Lesson) -> NodeStatus {
        if progressManager.progress.completedLessonIDs.contains(lesson.id) {
            return .completed
        }
        
        // Find index of this lesson in current module
        guard let module = LessonData.getModule(byID: lesson.moduleID) else { return .locked }
        let moduleLessons = LessonData.allLessons.filter { $0.moduleID == module.id }
        
        guard let index = moduleLessons.firstIndex(where: { $0.id == lesson.id }) else { return .locked }
        
        if index == 0 {
            return .active // First lesson is active if not completed
        }
        
        // Active if previous lesson is completed
        let prevLesson = moduleLessons[index - 1]
        if progressManager.progress.completedLessonIDs.contains(prevLesson.id) {
            return .active
        }
        
        return .locked
    }
    
    private func getBossLevelStatus(_ moduleID: String) -> NodeStatus {
        let moduleProgress = progressManager.progress.moduleProgressMap[moduleID]
        if moduleProgress?.bossStatus == .unlocked || moduleProgress?.bossStatus == .bronze || moduleProgress?.bossStatus == .gold {
            return .active
        } else if moduleProgress?.bossStatus == .gold {
            return .completed
        }
        return .locked
    }
    
    private func getNodeHorizontalOffset(_ index: Int) -> CGFloat {
        // Alternates: 0 -> 0, 1 -> -50, 2 -> 50, 3 -> -30, 4 -> 30, etc.
        let pattern = [0, -45, 45, -30, 30]
        return CGFloat(pattern[index % pattern.count])
    }
    
    private func nodeBackgroundColor(_ status: NodeStatus) -> Color {
        switch status {
        case .locked: return Color.appSurfaceElevated
        case .active: return accentColorForCategory(selectedCategory)
        case .completed: return Color.appSuccess
        }
    }
    
    private func nodeShadowColor(_ status: NodeStatus) -> Color {
        switch status {
        case .locked: return Color.clear
        case .active: return accentColorForCategory(selectedCategory).opacity(0.5)
        case .completed: return Color.appSuccess.opacity(0.3)
        }
    }
    
    private func accentColorForCategory(_ category: String) -> Color {
        switch category {
        case "work_tech": return .accentWork
        case "street": return .accentStreet
        case "sms": return .accentSMS
        case "social": return .accentSocial
        case "dating": return .accentDating
        case "swears": return .accentSwearing
        default: return .primaryBlue
        }
    }
    
    // Breathing Animation Loop
    private func startBreathingAnimation() {
        withAnimation(
            .easeInOut(duration: 1.8)
            .repeatForever(autoreverses: true)
        ) {
            breathScale = 1.05
        }
    }
    
    private func getNextLessonToStudy() -> Lesson {
        for lesson in LessonData.allLessons {
            if !progressManager.progress.completedLessonIDs.contains(lesson.id) {
                return lesson
            }
        }
        return LessonData.allLessons[0]
    }
}

// MARK: - Lesson Detail sheet (Bottom sheet)
struct LessonDetailSheet: View {
    let lesson: Lesson
    let status: CoursesView.NodeStatus
    @EnvironmentObject var progressManager: ProgressManager
    @Environment(\.dismiss) var dismiss
    var onStart: (Lesson) -> Void
    var onResetAndStart: (Lesson) -> Void
    
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
                    Text(lesson.title)
                        .font(.sfRounded(size: 24, weight: .black))
                        .foregroundColor(.textPrimary)
                    
                    Text(progressManager.loc("Lesson Details", "Lektionsdetaljer"))
                        .font(.sfRounded(size: 12, weight: .bold))
                        .foregroundColor(.primaryGold)
                        .tracking(1.5)
                }
                
                // Words list
                VStack(alignment: .leading, spacing: 12) {
                    Text(progressManager.loc("VOCABULARY TO LEARN", "ORD DU LÄR DIG"))
                        .font(.sfRounded(size: 11, weight: .bold))
                        .foregroundColor(.textSecondary)
                        .tracking(1.0)
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 8) {
                            ForEach(lesson.vocabItems, id: \.id) { item in
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
                                    
                                    // Sub-badge for register
                                    Text(item.registerLabel.rawValue.capitalized)
                                        .font(.sfRounded(size: 10, weight: .bold))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.appSurfaceElevated)
                                        .foregroundColor(.textMuted)
                                        .cornerRadius(8)
                                }
                                .padding(12)
                                .background(Color.appSurface)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .padding(.horizontal, 20)
                
                // Resume info / Status
                let hasResumeState = progressManager.progress.lessonResumeActs?[lesson.id] != nil
                
                VStack(spacing: 12) {
                    if hasResumeState {
                        Text(progressManager.loc("You have saved progress on this lesson.", "Du har sparade framsteg i denna lektion."))
                            .font(.sfStandard(size: 13))
                            .foregroundColor(.accentStreet)
                        
                        Button(action: {
                            dismiss()
                            onStart(lesson)
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                Text(progressManager.loc("Resume Lesson", "Fortsätt lektion"))
                            }
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.accentStreet)
                            .cornerRadius(16)
                        }
                        
                        Button(action: {
                            dismiss()
                            onResetAndStart(lesson)
                        }) {
                            Text(progressManager.loc("Restart from Beginning", "Starta om från början"))
                                .font(.sfRounded(size: 14, weight: .bold))
                                .foregroundColor(.textMuted)
                        }
                    } else {
                        Button(action: {
                            dismiss()
                            onStart(lesson)
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text(progressManager.loc("Start Lesson", "Starta lektion"))
                            }
                            .font(.sfRounded(size: 16, weight: .bold))
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.primaryGold)
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
    }
}
