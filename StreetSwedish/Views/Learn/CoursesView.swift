import SwiftUI

public struct CoursesView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    @State private var selectedCategory = "work_tech"
    @State private var showingLesson: Lesson? = nil
    @State private var showingBossLevel: BossLevel? = nil
    
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
            .navigationTitle("Lär dig (Learn)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $showingLesson) { lesson in
                LessonView(lesson: lesson)
            }
            .navigationDestination(item: $showingBossLevel) { boss in
                BossLevelView(bossLevel: boss)
            }
            .onAppear {
                startBreathingAnimation()
            }
        }
    }
    
    // MARK: - Category Tab Selector
    private func categoryHeaderSelector() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                categoryTab(id: "work_tech", name: "Jobb & Tech", icon: "laptopcomputer", color: .accentWork)
                categoryTab(id: "street", name: "Gatans Språk", icon: "figure.walk", color: .accentStreet)
                categoryTab(id: "sms", name: "SMS", icon: "bubble.left.and.bubble.right.fill", color: .accentSMS)
                categoryTab(id: "social", name: "Socialt / AW", icon: "wineglass.fill", color: .accentSocial)
                categoryTab(id: "dating", name: "Dating", icon: "heart.fill", color: .accentDating)
                categoryTab(id: "swears", name: "Svordomar", icon: "exclamationmark.bubble.fill", color: .accentSwearing)
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
                    Text("KURSMODUL")
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
                showingLesson = lesson
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
                
                Text("BOSSNIVÅ (BOSS LEVEL)")
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
            
            Text("Nya lektioner på väg!")
                .font(.sfRounded(size: 18, weight: .bold))
                .foregroundColor(.textSecondary)
            
            Text("Vi jobbar på slang för barer, svordomar och sms. Håll ut!")
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
}
