import SwiftUI

public struct WordDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    public let item: VocabItem
    
    // Observed Speech State
    @StateObject private var speechHelper = SpeechHelper.shared
    
    public init(item: VocabItem) {
        self.item = item
    }
    
    public var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header Area
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.swedish)
                                .font(.sfRounded(size: 40, weight: .bold))
                                .foregroundColor(.primaryGold)
                            
                            Text("/\(item.pronunciation)/")
                                .font(.sfRounded(size: 18, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Action buttons
                        HStack(spacing: 16) {
                            // Star / Favorite button
                            Button(action: {
                                progressManager.toggleStar(wordID: item.id)
                            }) {
                                Image(systemName: progressManager.progress.starredWords.contains(item.id) ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundColor(.primaryGold)
                                    .padding(12)
                                    .background(Color.appSurfaceElevated)
                                    .clipShape(Circle())
                            }
                            
                            // Audio play button
                            Button(action: {
                                speechHelper.speak(item.swedish, itemID: item.id, rate: progressManager.progress.ttsRate)
                            }) {
                                Image(systemName: speechHelper.isSpeaking && speechHelper.currentlySpeakingID == item.id ? "speaker.wave.3.fill" : "speaker.wave.2")
                                    .font(.title2)
                                    .foregroundColor(.primaryBlue)
                                    .padding(12)
                                    .background(Color.appSurfaceElevated)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.top, 16)
                    
                    // Register Badge & warning
                    HStack(spacing: 8) {
                        Text(item.registerLabel.displayName)
                            .font(.sfRounded(size: 13, weight: .semibold))
                            .foregroundColor(.appBackground)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(registerColor(item.registerLabel))
                            .cornerRadius(12)
                        
                        if let warning = item.usageWarning {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.appWarning)
                                Text(warning)
                                    .font(.sfStandard(size: 13, weight: .medium))
                                    .foregroundColor(.appWarning)
                            }
                        }
                    }
                    
                    Divider()
                        .background(Color.textMuted.opacity(0.3))
                    
                    // SRS Status Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("DINA FRAMSTEG")
                            .font(.sfRounded(size: 13, weight: .bold))
                            .foregroundColor(.textMuted)
                            .tracking(1.5)
                        
                        let srsItem = srsScheduler.items[item.id] ?? SRSItem(itemID: item.id)
                        
                        HStack(spacing: 16) {
                            // Progress bar
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(srsStageName(srsItem.stage))
                                        .font(.sfRounded(size: 16, weight: .semibold))
                                        .foregroundColor(.textPrimary)
                                    Spacer()
                                    Text("Nivå \(srsItem.stage)/5")
                                        .font(.sfRounded(size: 14, weight: .medium))
                                        .foregroundColor(.textSecondary)
                                }
                                
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .fill(Color.appSurfaceElevated)
                                            .frame(height: 10)
                                        
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color.primaryBlue, Color.appSuccess],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geo.size.width * CGFloat(Double(srsItem.stage) / 5.0), height: 10)
                                    }
                                }
                                .frame(height: 10)
                            }
                            
                            // "Mark as known" toggle if not mastered
                            if srsItem.stage < 5 {
                                Button(action: {
                                    srsScheduler.markAsKnown(itemID: item.id)
                                }) {
                                    Text("Känner till")
                                        .font(.sfRounded(size: 13, weight: .bold))
                                        .foregroundColor(.appBackground)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.primaryGold)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.appSurface)
                        .cornerRadius(16)
                    }
                    
                    // Memory Hooks Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("MINNESKROKAR (MEMORY HOOKS)")
                            .font(.sfRounded(size: 13, weight: .bold))
                            .foregroundColor(.textMuted)
                            .tracking(1.5)
                        
                        // Sound Hook
                        HookRow(title: "Ljudkrok (Sound Hook)", icon: "music.note", text: item.soundHook, color: .primaryBlue)
                        
                        // Visual Hook
                        HookRow(title: "Bildkrok (Visual Hook)", icon: "eye.fill", text: item.visualHook, color: .primaryGold)
                        
                        // Culture Hook
                        HookRow(title: "Kulturkrok (Culture Hook)", icon: "globe.europe.africa.fill", text: item.cultureHook, color: .appSuccess)
                    }
                    
                    Divider()
                        .background(Color.textMuted.opacity(0.3))
                    
                    // Example Sentences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("EXEMPELMENINGAR")
                            .font(.sfRounded(size: 13, weight: .bold))
                            .foregroundColor(.textMuted)
                            .tracking(1.5)
                        
                        ForEach(item.exampleSentences) { sentence in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .top, spacing: 10) {
                                    Button(action: {
                                        speechHelper.speak(sentence.swedish, itemID: sentence.swedish, rate: progressManager.progress.ttsRate)
                                    }) {
                                        Image(systemName: speechHelper.isSpeaking && speechHelper.currentlySpeakingID == sentence.swedish ? "speaker.wave.3.fill" : "speaker.wave.2")
                                            .font(.body)
                                            .foregroundColor(.primaryBlue)
                                            .padding(8)
                                            .background(Color.appSurfaceElevated)
                                            .clipShape(Circle())
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(sentence.swedish)
                                            .font(.sfStandard(size: 17, weight: .semibold))
                                            .foregroundColor(.textPrimary)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Text(sentence.english)
                                            .font(.sfStandard(size: 15))
                                            .foregroundColor(.textSecondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        if let note = sentence.contextNote {
                                            Text(note)
                                                .font(.sfStandard(size: 13, weight: .medium))
                                                .foregroundColor(.textMuted)
                                                .padding(.top, 2)
                                        }
                                    }
                                }
                            }
                            .padding(16)
                            .background(Color.appSurface)
                            .cornerRadius(16)
                        }
                    }
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Klar") {
                    dismiss()
                }
                .font(.sfRounded(size: 16, weight: .bold))
                .foregroundColor(.primaryGold)
            }
        }
    }
    
    // Helper to get register background color
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
    
    private func srsStageName(_ stage: Int) -> String {
        switch stage {
        case 0: return "Osett (Unseen)"
        case 1: return "Introducerat (Introduced)"
        case 2: return "Igenkänning (Recognition)"
        case 3: return "Återkallande (Recall)"
        case 4: return "Användning (Usage)"
        case 5: return "Mästrat (Mastered)"
        default: return "Osett"
        }
    }
}

// MARK: - Hook Row component
struct HookRow: View {
    let title: String
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.appBackground)
                .font(.subheadline)
                .padding(10)
                .background(color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.sfRounded(size: 14, weight: .bold))
                    .foregroundColor(color)
                Text(text)
                    .font(.sfStandard(size: 15))
                    .foregroundColor(.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appSurface)
        .cornerRadius(16)
    }
}
