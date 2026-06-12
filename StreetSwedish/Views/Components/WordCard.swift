import SwiftUI

public struct WordCard: View {
    public let item: VocabItem
    public let onSwipeRight: () -> Void // Got it
    public let onSwipeLeft: () -> Void  // Review again
    
    @EnvironmentObject var progressManager: ProgressManager
    @StateObject private var speechHelper = SpeechHelper.shared
    
    @State private var offset: CGSize = .zero
    @State private var showHooks = false
    
    public init(item: VocabItem, onSwipeRight: @escaping () -> Void, onSwipeLeft: @escaping () -> Void) {
        self.item = item
        self.onSwipeRight = onSwipeRight
        self.onSwipeLeft = onSwipeLeft
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let cardWidth = geometry.size.width
            
            VStack(spacing: 20) {
                // Word and Phonetics
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        // Register Badge
                        Text(item.registerLabel.displayName)
                            .font(.sfRounded(size: 11, weight: .bold))
                            .foregroundColor(.appBackground)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(registerColor(item.registerLabel))
                            .cornerRadius(8)
                    }
                    
                    Text(item.swedish)
                        .font(.sfRounded(size: 40, weight: .bold))
                        .foregroundColor(.primaryGold)
                        .multilineTextAlignment(.center)
                    
                    Text("/\(item.pronunciation)/")
                        .font(.sfRounded(size: 16, weight: .semibold))
                        .foregroundColor(.textSecondary)
                    
                    // Audio & Wave Visualizer
                    HStack(spacing: 12) {
                        Button(action: {
                            speechHelper.speak(item.swedish, itemID: item.id, rate: progressManager.progress.ttsRate)
                        }) {
                            Image(systemName: speechHelper.isSpeaking && speechHelper.currentlySpeakingID == item.id ? "speaker.wave.3.fill" : "speaker.wave.2")
                                .font(.body)
                                .foregroundColor(.primaryBlue)
                                .padding(12)
                                .background(Color.appSurfaceElevated)
                                .clipShape(Circle())
                        }
                        
                        // Animated Audio Wave
                        if speechHelper.isSpeaking && speechHelper.currentlySpeakingID == item.id {
                            AudioWaveView()
                        } else {
                            // Empty space matching wave width
                            Spacer()
                                .frame(width: 40, height: 20)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Divider()
                    .background(Color.textMuted.opacity(0.3))
                
                // Example Sentence
                if let firstExample = item.exampleSentences.first {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("EXEMPEL")
                            .font(.sfRounded(size: 11, weight: .bold))
                            .foregroundColor(.textMuted)
                            .tracking(1.0)
                        
                        Text(firstExample.swedish)
                            .font(.sfStandard(size: 18, weight: .semibold))
                            .foregroundColor(.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(firstExample.english)
                            .font(.sfStandard(size: 15))
                            .foregroundColor(.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color.appSurfaceElevated)
                    .cornerRadius(16)
                }
                
                Spacer()
                
                // Memory Hooks Accordion
                VStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            showHooks.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.primaryGold)
                            Text("Hitta mig dittan")
                                .font(.sfRounded(size: 15, weight: .bold))
                                .foregroundColor(.primaryGold)
                            Spacer()
                            Image(systemName: showHooks ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundColor(.primaryGold)
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(Color.appSurfaceElevated)
                        .cornerRadius(12)
                    }
                    
                    if showHooks {
                        VStack(alignment: .leading, spacing: 12) {
                            MiniHookRow(icon: "music.note", text: item.soundHook, color: .primaryBlue)
                            MiniHookRow(icon: "eye.fill", text: item.visualHook, color: .primaryGold)
                            MiniHookRow(icon: "globe.europe.africa.fill", text: item.cultureHook, color: .appSuccess)
                        }
                        .padding(.top, 12)
                    }
                }
                
                Spacer()
                
                // Swiping Helpers visual hint
                HStack {
                    Text("← Repetera (Review)")
                        .font(.sfRounded(size: 12, weight: .semibold))
                        .foregroundColor(.textMuted)
                    Spacer()
                    Text("Klar (Got it) →")
                        .font(.sfRounded(size: 12, weight: .semibold))
                        .foregroundColor(.appSuccess.opacity(0.8))
                }
                .padding(.horizontal, 8)
            }
            .padding(24)
            .background(Color.appSurface)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.35), radius: 20, x: 0, y: 10)
            .offset(x: offset.width, y: offset.height * 0.2) // Dampen vertical movement
            .rotationEffect(.init(degrees: Double(offset.width / cardWidth) * 15), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { gesture in
                        let swipeThreshold: CGFloat = 100
                        if gesture.translation.width > swipeThreshold {
                            // Swipe Right -> Got it
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                offset.width = cardWidth * 1.5
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onSwipeRight()
                            }
                        } else if gesture.translation.width < -swipeThreshold {
                            // Swipe Left -> Review again
                            // Exits, but we bounce back after trigger so it goes to back of stack
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                offset.width = -cardWidth * 1.5
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onSwipeLeft()
                                // Reset position for when it is shown again
                                offset = .zero
                                showHooks = false
                            }
                        } else {
                            // Reset
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                                offset = .zero
                            }
                        }
                    }
            )
            .onAppear {
                // Speak word automatically on card entry
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    speechHelper.speak(item.swedish, itemID: item.id, rate: progressManager.progress.ttsRate)
                }
            }
        }
    }
    
    private func registerColor(_ label: RegisterLevel) -> Color {
        switch label {
        case .neutral: return .textSecondary
        case .informal: return .accentStreet
        case .slang: return .accentSMS
        case .vulgar: return .accentSwearing
        case .textOnly: return .primaryBlue
        case .workplaceOK: return .accentWork
        }
    }
}

// MARK: - Mini Hook Row
struct MiniHookRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.appBackground)
                .padding(6)
                .background(color)
                .clipShape(Circle())
            
            Text(text)
                .font(.sfStandard(size: 14))
                .foregroundColor(.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Animated Audio Wave
struct AudioWaveView: View {
    @State private var anim1 = false
    @State private var anim2 = false
    @State private var anim3 = false
    
    var body: some View {
        HStack(spacing: 3) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.primaryBlue)
                .frame(width: 3, height: anim1 ? 18 : 6)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.primaryBlue)
                .frame(width: 3, height: anim2 ? 22 : 4)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.primaryBlue)
                .frame(width: 3, height: anim3 ? 15 : 7)
        }
        .frame(width: 20, height: 24)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.45).repeatForever(autoreverses: true)) {
                anim1 = true
            }
            withAnimation(.easeInOut(duration: 0.35).repeatForever(autoreverses: true).delay(0.1)) {
                anim2 = true
            }
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.2)) {
                anim3 = true
            }
        }
    }
}
