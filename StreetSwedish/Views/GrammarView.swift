import SwiftUI

public struct GrammarView: View {
    @EnvironmentObject var progressManager: ProgressManager
    
    @State private var selectedTopic = 0
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom segmented picker with scrollable option
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            topicTab(index: 0, title: progressManager.loc("Word Order", "Ordföljd"), icon: "text.alignleft")
                            topicTab(index: 1, title: progressManager.loc("Nouns & Plurals", "Substantiv"), icon: "tag.fill")
                            topicTab(index: 2, title: progressManager.loc("Verb Tenses", "Verb"), icon: "hourglass")
                            topicTab(index: 3, title: progressManager.loc("Adjectives", "Adjektiv"), icon: "paintpalette.fill")
                            topicTab(index: 4, title: progressManager.loc("Pronouns", "Pronomen"), icon: "person.2.fill")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .background(Color.appSurface)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            switch selectedTopic {
                            case 0:
                                wordOrderGuide()
                            case 1:
                                nounsGuide()
                            case 2:
                                verbsGuide()
                            case 3:
                                adjectivesGuide()
                            default:
                                pronounsGuide()
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle(progressManager.loc("Swedish Grammar", "Svensk Grammatik"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func topicTab(index: Int, title: String, icon: String) -> some View {
        let isSelected = selectedTopic == index
        return Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedTopic = index
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline)
                Text(title)
                    .font(.sfRounded(size: 14, weight: .bold))
            }
            .foregroundColor(isSelected ? .appBackground : .textSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? Color.primaryGold : Color.appSurfaceElevated)
            .cornerRadius(16)
        }
    }
    
    // MARK: - Topic 1: Word Order (Ordföljd) & V2 Rule Builder
    @State private var v2Words = ["jag", "köpte", "en öl", "Igår"].shuffled()
    @State private var v2Selected: [String] = []
    @State private var v2Message: String = ""
    @State private var v2IsCorrect: Bool? = nil
    
    private func wordOrderGuide() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            // SFI explanation card
            VStack(alignment: .leading, spacing: 12) {
                Text(progressManager.loc("THE V2 RULE (VERB SECOND)", "V2-REGELN (VERB PÅ ANDRA PLATS)"))
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.primaryGold)
                    .tracking(1.5)
                
                Text(progressManager.loc("In a Swedish declarative main clause, the finite verb must ALWAYS be the second element. If the sentence begins with something other than the subject (like a time word or location), the subject jumps after the verb. This is called INVERSION.", "I en svensk huvudsats måste det finita verbet ALLTID stå på andra plats. Om meningen börjar med något annat än subjektet (t.ex. ett tidsuttryck), hoppar subjektet in efter verbet. Detta kallas inversion."))
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textPrimary)
                    .lineSpacing(4)
                
                // Positionsschema Table
                VStack(spacing: 0) {
                    HStack {
                        headerCell(progressManager.loc("1. Fundament", "1. Fundament"))
                        headerCell(progressManager.loc("2. Verb 1", "2. Verb 1"))
                        headerCell(progressManager.loc("3. Subjekt", "3. Subjekt"))
                        headerCell(progressManager.loc("4. Object/Adv", "4. Objekt/Adv"))
                    }
                    .background(Color.appSurfaceElevated)
                    
                    HStack {
                        bodyCell("Jag", highlight: true)
                        bodyCell("dricker", highlight: false)
                        bodyCell("-", highlight: false)
                        bodyCell("en kaffe nu.")
                    }
                    HStack {
                        bodyCell("Nu", highlight: true)
                        bodyCell("dricker", highlight: false)
                        bodyCell("jag", highlight: true)
                        bodyCell("en kaffe.")
                    }
                }
                .cornerRadius(12)
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.appSurface)
            .cornerRadius(16)
            
            // Interactive V2 Builder Game
            VStack(alignment: .leading, spacing: 16) {
                Text(progressManager.loc("INTERACTIVE POSITIONSSCHEMA", "INTERAKTIVT POSITIONSSCHEMA"))
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.accentStreet)
                    .tracking(1.5)
                
                Text(progressManager.loc("Build this sentence: 'Yesterday I bought a beer'. Start with 'Igår' (Position 1) to test inversion!", "Bygg denna mening: 'Yesterday I bought a beer'. Börja med 'Igår' (Plats 1) för att testa inversion!"))
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textSecondary)
                
                // Slots
                HStack(spacing: 8) {
                    slotView(label: "1. Fundament", value: v2Selected.indices.contains(0) ? v2Selected[0] : nil)
                    slotView(label: "2. Verb 1", value: v2Selected.indices.contains(1) ? v2Selected[1] : nil)
                    slotView(label: "3. Subjekt", value: v2Selected.indices.contains(2) ? v2Selected[2] : nil)
                    slotView(label: "4. Objekt", value: v2Selected.indices.contains(3) ? v2Selected[3] : nil)
                }
                .frame(height: 70)
                
                // Words bank
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(v2Words, id: \.self) { word in
                        let isUsed = v2Selected.contains(word)
                        Button(action: {
                            if isUsed {
                                if let idx = v2Selected.firstIndex(of: word) {
                                    v2Selected.remove(at: idx)
                                }
                            } else {
                                if v2Selected.count < 4 {
                                    v2Selected.append(word)
                                }
                            }
                            v2IsCorrect = nil
                            v2Message = ""
                        }) {
                            Text(word)
                                .font(.sfRounded(size: 15, weight: .bold))
                                .foregroundColor(isUsed ? .textMuted : .appBackground)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(isUsed ? Color.appSurfaceElevated : Color.primaryGold)
                                .cornerRadius(12)
                        }
                    }
                }
                
                // Check Button
                if v2Selected.count == 4 {
                    Button(action: checkV2Sentence) {
                        Text(progressManager.loc("Check Word Order", "Kontrollera ordföljd"))
                            .font(.sfRounded(size: 15, weight: .bold))
                            .foregroundColor(.appBackground)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.accentStreet)
                            .cornerRadius(12)
                    }
                }
                
                // Result message
                if !v2Message.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: v2IsCorrect == true ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .foregroundColor(v2IsCorrect == true ? .appSuccess : .appError)
                        Text(v2Message)
                            .font(.sfStandard(size: 13))
                            .foregroundColor(v2IsCorrect == true ? .appSuccess : .appError)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(v2IsCorrect == true ? Color.appSuccess.opacity(0.1) : Color.appError.opacity(0.1))
                    .cornerRadius(10)
                }
                
                // Reset Button
                Button(action: {
                    v2Selected = []
                    v2Words = ["jag", "köpte", "en öl", "Igår"].shuffled()
                    v2IsCorrect = nil
                    v2Message = ""
                }) {
                    Text(progressManager.loc("Reset Game", "Återställ spel"))
                        .font(.sfRounded(size: 13, weight: .bold))
                        .foregroundColor(.textMuted)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(16)
            .background(Color.appSurface)
            .cornerRadius(16)
        }
    }
    
    private func checkV2Sentence() {
        if v2Selected[0] == "Igår" {
            // Inverted order: Igår köpte jag en öl
            if v2Selected[1] == "köpte" && v2Selected[2] == "jag" && v2Selected[3] == "en öl" {
                v2IsCorrect = true
                v2Message = progressManager.loc("Perfekt! 'Igår' is the foundation, 'köpte' is the verb (position 2), and the subject 'jag' moves to position 3. +10 XP!", "Perfekt! 'Igår' är fundamentet, 'köpte' är verbet (plats 2), och subjektet 'jag' hoppar till plats 3. +10 XP!")
                progressManager.addXP(10)
            } else {
                v2IsCorrect = false
                v2Message = progressManager.loc("V2 Rule Violation! Since the time element 'Igår' is at Position 1, the verb 'köpte' must go to Position 2, followed by the subject 'jag'.", "V2-fel! Eftersom tidordet 'Igår' står på plats 1, måste verbet 'köpte' stå på plats 2, följt av subjektet 'jag'.")
            }
        } else if v2Selected[0] == "jag" {
            // Standard order: jag köpte en öl Igår
            if v2Selected[1] == "köpte" && v2Selected[2] == "en öl" && v2Selected[3] == "Igår" {
                v2IsCorrect = true
                v2Message = progressManager.loc("Correct! Subject first (jag), verb second (köpte), object (en öl), and time last (Igår). +10 XP!", "Rätt! Subjekt först (jag), verb på andra plats (köpte), objekt (en öl), och tid sist (Igår). +10 XP!")
                progressManager.addXP(10)
            } else {
                v2IsCorrect = false
                v2Message = progressManager.loc("Incorrect order. Try putting the verb 'köpte' in Position 2: 'jag köpte...'", "Fel ordföljd. Försök placera verbet 'köpte' på plats 2: 'jag köpte...'")
            }
        } else {
            v2IsCorrect = false
            v2Message = progressManager.loc("Incorrect foundation. A Swedish main clause typically starts with the Subject ('jag') or a Time/Place word ('Igår').", "Fel fundament. En svensk huvudsats börjar oftast med subjektet ('jag') eller tidsuttrycket ('Igår').")
        }
    }
    
    // MARK: - Topic 2: Nouns & Plural Declensions
    @State private var pluralSelectedGroup: Int? = nil
    
    private func nounsGuide() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text(progressManager.loc("EN & ETT WORDS", "EN- & ETT-ORD"))
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.primaryGold)
                    .tracking(1.5)
                
                Text(progressManager.loc("Swedish nouns are divided into 'en' words (utrum - approx 75%) and 'ett' words (neutrum - approx 25%). There is no simple rule to guess which is which, so you must learn the article with the noun!", "Svenska substantiv delas in i en-ord (utrum - ca 75%) och ett-ord (neutrum - ca 25%). Det finns ingen enkel regel för att gissa vilket som är vilket, så du måste lära dig artikeln tillsammans med substantivet!"))
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textPrimary)
            }
            .padding(16)
            .background(Color.appSurface)
            .cornerRadius(16)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(progressManager.loc("THE 5 PLURAL DECLENSIONS (DE 5 DEKLINATIONERNA)", "DE 5 DEKLINATIONERNA (PLURALÄNDELSER)"))
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.accentSMS)
                    .tracking(1.5)
                
                Text(progressManager.loc("Tap a declension group below to reveal SFI examples:", "Klicka på en deklinationsgrupp nedan för att se SFI-exempel:"))
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textSecondary)
                
                VStack(spacing: 8) {
                    declensionRow(number: 1, ending: "-or", desc: progressManager.loc("En-words ending in -a (mostly female gender nouns)", "En-ord som slutar på -a"), example: "en flicka -> flickor, en guss -> gussar (Group 2)")
                    declensionRow(number: 2, ending: "-ar", desc: progressManager.loc("En-words ending in unstressed syllables", "En-ord som slutar på obetonad vokal/stavelse"), example: "en bil -> bilar, en kille -> killar")
                    declensionRow(number: 3, ending: "-er", desc: progressManager.loc("En-words with stress on final syllable, or loanwords", "En-ord med betoning på sista stavelsen samt lånord"), example: "en katt -> katter, en öl -> öler / öl")
                    declensionRow(number: 4, ending: "-n", desc: progressManager.loc("Ett-words ending in a vowel", "Ett-ord som slutar på vokal"), example: "ett kvitto -> kvitton, ett möte -> möten")
                    declensionRow(number: 5, ending: "No Change", desc: progressManager.loc("Ett-words ending in a consonant", "Ett-ord som slutar på konsonant"), example: "ett glas -> glas, ett ord -> ord")
                }
            }
            .padding(16)
            .background(Color.appSurface)
            .cornerRadius(16)
        }
    }
    
    private func declensionRow(number: Int, ending: String, desc: String, example: String) -> some View {
        let isOpen = pluralSelectedGroup == number
        return VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    pluralSelectedGroup = isOpen ? nil : number
                }
            }) {
                HStack {
                    Text("Grupp \(number)")
                        .font(.sfRounded(size: 14, weight: .bold))
                        .foregroundColor(.primaryGold)
                    Text(ending)
                        .font(.sfRounded(size: 16, weight: .black))
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .foregroundColor(.textMuted)
                }
            }
            
            if isOpen {
                VStack(alignment: .leading, spacing: 6) {
                    Text(desc)
                        .font(.sfStandard(size: 13))
                        .foregroundColor(.textSecondary)
                    Text("Exempel: \(example)")
                        .font(.sfRounded(size: 13, weight: .bold))
                        .foregroundColor(.accentSMS)
                }
                .padding(.top, 4)
            }
        }
        .padding(12)
        .background(Color.appSurfaceElevated)
        .cornerRadius(12)
    }
    
    // MARK: - Topic 3: Verbs & Tenses
    private func verbsGuide() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text(progressManager.loc("VERB GROUPS", "VERB-GRUPPER"))
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.primaryGold)
                    .tracking(1.5)
                
                Text(progressManager.loc("Swedish verbs are regular and fit into 4 main groups, plus strong/irregular verbs. Unlike English, verbs DO NOT conjugate based on the person (Jag dricker, Du dricker, Vi dricker is all 'dricker'!).", "Svenska verb delas in i 4 grupper. Till skillnad från engelska böjs inte verb efter person (Jag dricker, Du dricker, Vi dricker har alla samma form!)."))
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textPrimary)
                
                // Verb Tense Grid
                VStack(spacing: 8) {
                    verbTenseRow(tense: "Infinitive (Grundform)", form: "att chilla (to chill)", usage: "After auxiliary verbs (måste chilla)")
                    verbTenseRow(tense: "Present (Nutid)", form: "chillar (chills)", usage: "Ongoing or habitual actions")
                    verbTenseRow(tense: "Preteritum (Past)", form: "chillade (chilled)", usage: "Completed past actions with a specified time")
                    verbTenseRow(tense: "Supinum (Perfect)", form: "har chillat (have chilled)", usage: "Action started in past, finished or still relevant")
                }
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.appSurface)
            .cornerRadius(16)
        }
    }
    
    private func verbTenseRow(tense: String, form: String, usage: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(tense)
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.accentSocial)
                Text(form)
                    .font(.sfRounded(size: 15, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(usage)
                    .font(.sfStandard(size: 11))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
        }
        .padding(10)
        .background(Color.appSurfaceElevated)
        .cornerRadius(10)
    }
    
    // MARK: - Topic 4: Adjectives
    private func adjectivesGuide() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text(progressManager.loc("ADJECTIVE AGREEMENT", "KONGRIENSBÖJNING AV ADJEKTIV"))
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.primaryGold)
                    .tracking(1.5)
                
                Text(progressManager.loc("Adjectives must match the gender (en/ett) and number (singular/plural) of the noun they describe:", "Adjektiv måste anpassas efter substantivets genus (en/ett) och numerus (singular/plural):"))
                    .font(.sfStandard(size: 14))
                    .foregroundColor(.textSecondary)
                
                VStack(spacing: 8) {
                    adjectiveRuleRow(nounType: "En-word (Singular)", rule: "Base form", example: "en röd guss (a red girl/chick)")
                    adjectiveRuleRow(nounType: "Ett-word (Singular)", rule: "+t ending", example: "ett rött kvitto (a red receipt)")
                    adjectiveRuleRow(nounType: "Plural (En/Ett)", rule: "+a ending", example: "röda bilar / röda möten (red cars / red meetings)")
                }
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.appSurface)
            .cornerRadius(16)
        }
    }
    
    private func adjectiveRuleRow(nounType: String, rule: String, example: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(nounType)
                    .font(.sfRounded(size: 13, weight: .bold))
                    .foregroundColor(.accentDating)
                Text(rule)
                    .font(.sfRounded(size: 15, weight: .bold))
                    .foregroundColor(.textPrimary)
                Text(example)
                    .font(.sfStandard(size: 12))
                    .foregroundColor(.textSecondary)
            }
            Spacer()
        }
        .padding(10)
        .background(Color.appSurfaceElevated)
        .cornerRadius(10)
    }
    
    // MARK: - Topic 5: Pronouns
    private func pronounsGuide() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text(progressManager.loc("PERSONAL & POSSESSIVE PRONOUNS", "PERSONLIGA & POSSESSIVA PRONOMEN"))
                    .font(.sfRounded(size: 12, weight: .bold))
                    .foregroundColor(.primaryGold)
                    .tracking(1.5)
                
                // Pronouns Table
                VStack(spacing: 0) {
                    HStack {
                        headerCell("Subjekt")
                        headerCell("Objekt")
                        headerCell("Possessiv")
                    }
                    .background(Color.appSurfaceElevated)
                    
                    pronounRow("jag (I)", "mig (me)", "min / mitt / mina (my)")
                    pronounRow("du (you)", "dig (you)", "din / ditt / dina (your)")
                    pronounRow("han (he)", "honom (him)", "hans (his)")
                    pronounRow("hon (she)", "henne (her)", "hennes (her)")
                    pronounRow("vi (we)", "oss (us)", "vår / vårt / våra (our)")
                    pronounRow("de (they)", "dem (them)", "deras (their)")
                }
                .cornerRadius(12)
                .padding(.top, 8)
            }
            .padding(16)
            .background(Color.appSurface)
            .cornerRadius(16)
        }
    }
    
    private func pronounRow(_ sub: String, _ obj: String, _ poss: String) -> some View {
        HStack {
            bodyCell(sub)
            bodyCell(obj)
            bodyCell(poss)
        }
    }
    
    // MARK: - Table Helpers
    private func headerCell(_ text: String) -> some View {
        Text(text)
            .font(.sfRounded(size: 11, weight: .black))
            .foregroundColor(.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
    
    private func bodyCell(_ text: String, highlight: Bool = false) -> some View {
        Text(text)
            .font(.sfStandard(size: 12, weight: highlight ? .bold : .regular))
            .foregroundColor(highlight ? .primaryGold : .textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
}


// Custom simple Flow stack for SwiftUI
struct slotView: View {
    let label: String
    let value: String?
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.sfRounded(size: 9, weight: .bold))
                .foregroundColor(.textMuted)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.appSurfaceElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.textMuted.opacity(0.3), lineWidth: 1)
                    )
                
                if let val = value {
                    Text(val)
                        .font(.sfRounded(size: 14, weight: .black))
                        .foregroundColor(.primaryGold)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(height: 44)
        }
        .frame(maxWidth: .infinity)
    }
}
