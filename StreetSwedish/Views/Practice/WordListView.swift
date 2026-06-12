import SwiftUI

public struct WordListView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @EnvironmentObject var srsScheduler: SRSScheduler
    
    @State private var searchText = ""
    @State private var selectedCategory: String = "all"
    @State private var selectedRegister: String = "all"
    @State private var selectedStage: String = "all"
    
    @State private var selectedDetailItem: VocabItem? = nil
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Filter bar
                filterSection()
                
                // Vocab List
                List {
                    let filteredItems = getFilteredVocabItems()
                    
                    if filteredItems.isEmpty {
                        Section {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 40))
                                    .foregroundColor(.textMuted)
                                Text("Inga ord hittades")
                                    .font(.sfRounded(size: 16, weight: .bold))
                                    .foregroundColor(.textSecondary)
                            }
                            .padding(.vertical, 32)
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.appSurface)
                        }
                    } else {
                        ForEach(filteredItems) { item in
                            wordRow(item)
                                .listRowBackground(Color.appSurface)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedDetailItem = item
                                }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden) // Required to show custom appBackground in List
            }
        }
        .navigationTitle("Ordlista (Dictionary)")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Sök på svenska eller engelska...")
        .sheet(item: $selectedDetailItem) { item in
            NavigationStack {
                WordDetailSheet(item: item)
            }
        }
    }
    
    // MARK: - Filter UI
    private func filterSection() -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                // Category filter menu
                Menu {
                    Button("Alla kategorier", action: { selectedCategory = "all" })
                    Button("Jobb & Tech", action: { selectedCategory = "work_tech" })
                    Button("Gatans Språk", action: { selectedCategory = "street" })
                } label: {
                    HStack {
                        Text(categoryLabelName())
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .font(.sfRounded(size: 13, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.appSurfaceElevated)
                    .cornerRadius(12)
                }
                
                // Register filter menu
                Menu {
                    Button("Alla stilnivåer", action: { selectedRegister = "all" })
                    ForEach(RegisterLevel.allCases, id: \.self) { level in
                        Button(level.displayName, action: { selectedRegister = level.rawValue })
                    }
                } label: {
                    HStack {
                        Text(registerLabelName())
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .font(.sfRounded(size: 13, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.appSurfaceElevated)
                    .cornerRadius(12)
                }
                
                // Stage filter menu
                Menu {
                    Button("Alla nivåer", action: { selectedStage = "all" })
                    ForEach(0...5, id: \.self) { stage in
                        Button("Nivå \(stage)", action: { selectedStage = String(stage) })
                    }
                } label: {
                    HStack {
                        Text(stageLabelName())
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .font(.sfRounded(size: 13, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.appSurfaceElevated)
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Divider()
                .background(Color.textMuted.opacity(0.3))
        }
        .background(Color.appSurface)
    }
    
    // MARK: - Word Row View
    private func wordRow(_ item: VocabItem) -> some View {
        let srsItem = srsScheduler.items[item.id] ?? SRSItem(itemID: item.id)
        
        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(item.swedish)
                        .font(.sfRounded(size: 17, weight: .bold))
                        .foregroundColor(.primaryGold)
                    
                    // Star symbol if favorited
                    if progressManager.progress.starredWords.contains(item.id) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.primaryGold)
                    }
                }
                
                Text(item.english)
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            // Register display label
            Text(item.registerLabel.displayName)
                .font(.sfRounded(size: 10, weight: .bold))
                .foregroundColor(.textMuted)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.appSurfaceElevated)
                .cornerRadius(6)
            
            // SRS progress circle badge
            Circle()
                .fill(srsBadgeColor(srsItem.stage))
                .frame(width: 20, height: 20)
                .overlay(
                    Text("\(srsItem.stage)")
                        .font(.sfRounded(size: 11, weight: .bold))
                        .foregroundColor(.appBackground)
                )
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // Reset Progress action
            Button(role: .destructive) {
                srsScheduler.resetProgress(itemID: item.id)
            } label: {
                Label("Nollställ", systemImage: "arrow.uturn.left")
            }
            .tint(Color.appError)
            
            // Mark as Mastered action
            Button {
                srsScheduler.markAsKnown(itemID: item.id)
            } label: {
                Label("Mästrat", systemImage: "checkmark.circle.fill")
            }
            .tint(Color.primaryGold)
        }
    }
    
    // MARK: - Filtering Logic
    private func getFilteredVocabItems() -> [VocabItem] {
        var items = LessonData.allVocabItems
        
        // Search text
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            items = items.filter {
                $0.swedish.lowercased().contains(query) ||
                $0.english.lowercased().contains(query)
            }
        }
        
        // Category Filter
        if selectedCategory != "all" {
            // Note: Arbete & Tech module ID matches "arbete_tech" which correlates to work_tech
            if selectedCategory == "work_tech" {
                items = items.filter { item in
                    // Items from the first lessons belong to work_tech
                    LessonData.allLessons.prefix(3).flatMap { $0.vocabItems }.contains(where: { $0.id == item.id })
                }
            } else {
                items = [] // Others not loaded yet
            }
        }
        
        // Register Filter
        if selectedRegister != "all" {
            items = items.filter { $0.registerLabel.rawValue == selectedRegister }
        }
        
        // Stage Filter
        if selectedStage != "all" {
            let targetStage = Int(selectedStage) ?? 0
            items = items.filter { item in
                let srsItem = srsScheduler.items[item.id] ?? SRSItem(itemID: item.id)
                return srsItem.stage == targetStage
            }
        }
        
        return items
    }
    
    // MARK: - Label Helpers
    private func categoryLabelName() -> String {
        switch selectedCategory {
        case "work_tech": return "Jobb & Tech"
        case "street": return "Gatans Språk"
        default: return "Kategori"
        }
    }
    
    private func registerLabelName() -> String {
        if selectedRegister == "all" { return "Stilnivå" }
        return RegisterLevel(rawValue: selectedRegister)?.displayName ?? "Stilnivå"
    }
    
    private func stageLabelName() -> String {
        if selectedStage == "all" { return "SRS-Nivå" }
        return "Nivå " + selectedStage
    }
    
    private func srsBadgeColor(_ stage: Int) -> Color {
        switch stage {
        case 0: return Color.textMuted
        case 1, 2: return Color.accentWork
        case 3, 4: return Color.primaryBlue
        case 5: return Color.appSuccess
        default: return Color.textMuted
        }
    }
}
