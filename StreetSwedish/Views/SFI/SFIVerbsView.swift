import SwiftUI

public struct SFIVerbsView: View {
    @EnvironmentObject var progressManager: ProgressManager
    @State private var searchText = ""
    @State private var selectedGroup = "all"
    @State private var expandedVerbID: String? = nil
    
    public init() {}
    
    private var filteredVerbs: [SwedishVerb] {
        var verbs = VerbData.allVerbs
        if selectedGroup != "all" {
            verbs = verbs.filter { $0.group == selectedGroup }
        }
        if !searchText.isEmpty {
            let q = searchText.lowercased()
            verbs = verbs.filter {
                $0.infinitive.lowercased().contains(q) ||
                $0.english.lowercased().contains(q) ||
                $0.present.lowercased().contains(q) ||
                $0.past.lowercased().contains(q)
            }
        }
        return verbs
    }
    
    private let groups = ["all", "Irregular", "Group 1", "Group 2a", "Group 2b", "Group 3"]
    
    public var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Group filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(groups, id: \.self) { grp in
                            let isSelected = selectedGroup == grp
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                    selectedGroup = grp
                                }
                            }) {
                                Text(grp == "all" ? progressManager.loc("All", "Alla") : grp)
                                    .font(.sfRounded(size: 13, weight: .bold))
                                    .foregroundColor(isSelected ? .appBackground : .textSecondary)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(isSelected ? Color.primaryGold : Color.appSurfaceElevated)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                .background(Color.appSurface)
                
                // Count
                HStack {
                    Text("\(filteredVerbs.count) " + progressManager.loc("verbs", "verb"))
                        .font(.sfRounded(size: 12, weight: .bold))
                        .foregroundColor(.textMuted)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                
                // Verb List
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(filteredVerbs) { verb in
                            verbCard(verb)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle(progressManager.loc("Verbs", "Verb"))
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: progressManager.loc("Search verbs...", "Sök verb..."))
    }
    
    private func verbCard(_ verb: SwedishVerb) -> some View {
        let isExpanded = expandedVerbID == verb.id
        
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                expandedVerbID = isExpanded ? nil : verb.id
            }
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Header row
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(verb.infinitive)
                            .font(.sfRounded(size: 18, weight: .bold))
                            .foregroundColor(.primaryGold)
                        Text(verb.english)
                            .font(.sfStandard(size: 13))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(verb.group)
                        .font(.sfRounded(size: 10, weight: .bold))
                        .foregroundColor(.textMuted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.appSurfaceElevated)
                        .cornerRadius(6)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textMuted)
                }
                .padding(16)
                
                if isExpanded {
                    VStack(spacing: 0) {
                        Divider().background(Color.textMuted.opacity(0.2))
                        
                        // Conjugation table
                        VStack(spacing: 8) {
                            conjugationRow("Infinitiv", "att " + verb.infinitive)
                            conjugationRow("Presens", verb.present)
                            conjugationRow("Preteritum", verb.past)
                            conjugationRow("Supinum", "har " + verb.supinum)
                            conjugationRow("Imperativ", verb.imperative)
                        }
                        .padding(16)
                        
                        Divider().background(Color.textMuted.opacity(0.2))
                        
                        // Examples
                        VStack(alignment: .leading, spacing: 8) {
                            Text(progressManager.loc("EXAMPLES", "EXEMPEL"))
                                .font(.sfRounded(size: 10, weight: .bold))
                                .foregroundColor(.textMuted)
                                .tracking(1.0)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                verbExampleRow(label: progressManager.loc("Present", "Presens"), swedish: verb.exPresent, english: verb.exPresentEn)
                                verbExampleRow(label: progressManager.loc("Past", "Preteritum"), swedish: verb.exPast, english: verb.exPastEn)
                                if verb.exSupinum != "—" && !verb.exSupinum.isEmpty {
                                    verbExampleRow(label: progressManager.loc("Perfect", "Supinum"), swedish: verb.exSupinum, english: verb.exSupinumEn)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .background(Color.appSurface)
            .cornerRadius(16)
        }
    }
    
    private func conjugationRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.sfRounded(size: 12, weight: .bold))
                .foregroundColor(.accentSocial)
                .frame(width: 90, alignment: .leading)
            Text(value)
                .font(.sfRounded(size: 15, weight: .bold))
                .foregroundColor(.textPrimary)
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.appSurfaceElevated)
        .cornerRadius(8)
    }
    
    private func verbExampleRow(label: String, swedish: String, english: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.sfRounded(size: 11, weight: .bold))
                .foregroundColor(.textMuted)
                .frame(width: 80, alignment: .leading)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(swedish)
                    .font(.sfStandard(size: 14, weight: .semibold))
                    .foregroundColor(.textPrimary)
                Text(english)
                    .font(.sfStandard(size: 12))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
        }
        .padding(8)
        .background(Color.appSurfaceElevated.opacity(0.5))
        .cornerRadius(8)
    }
}
