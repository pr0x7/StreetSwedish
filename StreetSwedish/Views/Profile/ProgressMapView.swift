import SwiftUI

public struct ProgressMapView: View {
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    // Grid configuration
    private let columns = [
        GridItem(.adaptive(minimum: 44, maximum: 54), spacing: 10)
    ]
    
    @State private var selectedItem: VocabItem? = nil
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("FRAMSTEGSKARTA (PROGRESS MAP)")
                            .font(.sfRounded(size: 11, weight: .bold))
                            .foregroundColor(.primaryGold)
                            .tracking(2.0)
                        
                        Text("Ditt ord-bibliotek")
                            .font(.sfRounded(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Varje ruta representerar ett ord. Färgen visar hur väl du minns det.")
                            .font(.sfStandard(size: 14))
                            .foregroundColor(.textSecondary)
                    }
                    
                    // Legend
                    legendSection()
                    
                    // Word Grid
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(LessonData.allVocabItems) { item in
                            let srsItem = srsScheduler.items[item.id] ?? SRSItem(itemID: item.id)
                            
                            Button(action: {
                                selectedItem = item
                            }) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(stageColor(srsItem.stage))
                                    .frame(height: 48)
                                    .overlay(
                                        Text(String(item.swedish.prefix(2)).capitalized)
                                            .font(.sfRounded(size: 12, weight: .bold))
                                            .foregroundColor(.appBackground)
                                    )
                                    .shadow(color: stageColor(srsItem.stage).opacity(0.3), radius: 4, y: 2)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.appSurface)
                    .cornerRadius(20)
                    
                    Spacer()
                }
                .padding(20)
            }
            
            // Popover/Tooltip overlay when an item is tapped
            if let item = selectedItem {
                tooltipOverlay(for: item)
            }
        }
        .navigationTitle("Framstegskarta")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Legend Section
    private func legendSection() -> some View {
        HStack(spacing: 8) {
            legendItem(stage: 0, label: "Osett")
            legendItem(stage: 1, label: "Intro")
            legendItem(stage: 2, label: "Igenkänn")
            legendItem(stage: 3, label: "Minns")
            legendItem(stage: 4, label: "Använd")
            legendItem(stage: 5, label: "Mästrat")
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.appSurface)
        .cornerRadius(12)
    }
    
    private func legendItem(stage: Int, label: String) -> some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 4)
                .fill(stageColor(stage))
                .frame(width: 20, height: 20)
            
            Text(label)
                .font(.sfSystem(size: 9))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Tooltip overlay
    private func tooltipOverlay(for item: VocabItem) -> some View {
        let srsItem = srsScheduler.items[item.id] ?? SRSItem(itemID: item.id)
        
        return ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    selectedItem = nil
                }
            
            VStack(spacing: 16) {
                HStack {
                    Text(item.swedish)
                        .font(.sfRounded(size: 22, weight: .bold))
                        .foregroundColor(.primaryGold)
                    Spacer()
                    
                    Text("Nivå \(srsItem.stage)")
                        .font(.sfRounded(size: 12, weight: .bold))
                        .foregroundColor(.appBackground)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(stageColor(srsItem.stage))
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("ENGELSKA")
                        .font(.sfRounded(size: 10, weight: .bold))
                        .foregroundColor(.textMuted)
                    Text(item.english)
                        .font(.sfStandard(size: 15, weight: .semibold))
                        .foregroundColor(.textPrimary)
                    
                    Text("NÄSTA REPETITION")
                        .font(.sfRounded(size: 10, weight: .bold))
                        .foregroundColor(.textMuted)
                        .padding(.top, 4)
                    
                    Text(srsItem.stage == 5 ? "Aldrig (Mästrat)" : (srsItem.stage == 0 ? "Ej schemalagt" : formatDueDate(srsItem.nextReviewDate)))
                        .font(.sfStandard(size: 14))
                        .foregroundColor(.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    selectedItem = nil
                }) {
                    Text("Stäng")
                        .font(.sfRounded(size: 14, weight: .bold))
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.primaryGold)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .background(Color.appSurfaceElevated)
            .cornerRadius(24)
            .frame(width: 280)
            .shadow(radius: 20)
        }
    }
    
    // MARK: - Color Map
    private func stageColor(_ stage: Int) -> Color {
        switch stage {
        case 0: return Color.textMuted.opacity(0.4)
        case 1: return Color.accentWork.opacity(0.7)
        case 2: return Color.primaryBlue.opacity(0.6)
        case 3: return Color.accentSMS.opacity(0.8)
        case 4: return Color.accentDating.opacity(0.8)
        case 5: return Color.appSuccess
        default: return Color.textMuted
        }
    }
    
    private func formatDueDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - System Font Extension for Legend
extension Font {
    public static func sfSystem(size: CGFloat) -> Font {
        return Font.system(size: size)
    }
}
