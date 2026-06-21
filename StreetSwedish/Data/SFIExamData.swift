import Foundation

public struct SFIExamData {
    
    // MARK: - Course C Exam (B1 Level)
    public static let courseCExam = SFIExam(
        id: "sfi_exam_c",
        courseLevel: "C",
        title: "SFI Kurs C Prov",
        sections: [
            SFIExamSection(
                id: "sfi_c_reading",
                title: "Läsförståelse (Reading)",
                timeLimitSeconds: 180,
                exercises: [
                    Exercise(
                        id: "sfi_c_r1",
                        type: .multipleChoice,
                        prompt: "Anna bor i Stockholm. Hon jobbar på ett café. Hon tycker om att träffa nya människor.\n\nVad jobbar Anna med?",
                        correctAnswer: "Hon jobbar på ett café",
                        options: ["Hon jobbar på ett kontor", "Hon jobbar på ett café", "Hon jobbar hemma", "Hon studerar på universitetet"]
                    ),
                    Exercise(
                        id: "sfi_c_r2",
                        type: .multipleChoice,
                        prompt: "Idag är det måndag. Erik ska handla mat efter jobbet. Han behöver mjölk, bröd och ost.\n\nNär ska Erik handla?",
                        correctAnswer: "Efter jobbet",
                        options: ["På morgonen", "På lunchen", "Efter jobbet", "På helgen"]
                    ),
                    Exercise(
                        id: "sfi_c_r3",
                        type: .multipleChoice,
                        prompt: "Bussen avgår klockan 8:15 från Centralstationen. Resan tar 45 minuter.\n\nNär kommer bussen fram?",
                        correctAnswer: "Klockan 9:00",
                        options: ["Klockan 8:45", "Klockan 9:00", "Klockan 9:15", "Klockan 8:30"]
                    ),
                    Exercise(
                        id: "sfi_c_r4",
                        type: .multipleChoice,
                        prompt: "Biblioteket är öppet måndag till fredag 10-18. På lördagar 10-14. Stängt på söndagar.\n\nKan man besöka biblioteket på söndag?",
                        correctAnswer: "Nej, det är stängt",
                        options: ["Ja, 10-18", "Ja, 10-14", "Nej, det är stängt", "Bara på förmiddagen"]
                    ),
                    Exercise(
                        id: "sfi_c_r5",
                        type: .multipleChoice,
                        prompt: "Sara har ont i halsen. Hon ringer till vårdcentralen. De säger att hon kan komma klockan 14.\n\nVarför ringer Sara?",
                        correctAnswer: "Hon är sjuk",
                        options: ["Hon vill boka semester", "Hon är sjuk", "Hon söker jobb", "Hon vill handla medicin"]
                    )
                ]
            ),
            SFIExamSection(
                id: "sfi_c_grammar",
                title: "Grammatik (Grammar)",
                timeLimitSeconds: 180,
                exercises: [
                    Exercise(
                        id: "sfi_c_g1",
                        type: .fillBlank,
                        prompt: "Jag ______ till jobbet varje dag.",
                        correctAnswer: "åker",
                        options: ["åker", "åkte", "åkt", "åka"]
                    ),
                    Exercise(
                        id: "sfi_c_g2",
                        type: .fillBlank,
                        prompt: "Det är ______ hus. (a/an)",
                        correctAnswer: "ett",
                        options: ["en", "ett", "den", "det"]
                    ),
                    Exercise(
                        id: "sfi_c_g3",
                        type: .fillBlank,
                        prompt: "Igår ______ vi på bio.",
                        correctAnswer: "var",
                        options: ["är", "var", "varit", "vara"]
                    ),
                    Exercise(
                        id: "sfi_c_g4",
                        type: .fillBlank,
                        prompt: "Hon har ______ hela dagen.",
                        correctAnswer: "jobbat",
                        options: ["jobba", "jobbade", "jobbat", "jobbar"]
                    ),
                    Exercise(
                        id: "sfi_c_g5",
                        type: .fillBlank,
                        prompt: "Barnen leker i ______ trädgården.",
                        correctAnswer: "den",
                        options: ["en", "den", "ett", "det"]
                    )
                ]
            ),
            SFIExamSection(
                id: "sfi_c_vocab",
                title: "Ordförråd (Vocabulary)",
                timeLimitSeconds: 180,
                exercises: [
                    Exercise(
                        id: "sfi_c_v1",
                        type: .translate,
                        prompt: "Translate: 'Jag behöver hjälp'",
                        correctAnswer: "I need help",
                        hint: "behöver = need, hjälp = help"
                    ),
                    Exercise(
                        id: "sfi_c_v2",
                        type: .translate,
                        prompt: "Translate: 'Var ligger närmaste busshållplats?'",
                        correctAnswer: "Where is the nearest bus stop?",
                        hint: "närmaste = nearest, busshållplats = bus stop"
                    ),
                    Exercise(
                        id: "sfi_c_v3",
                        type: .translate,
                        prompt: "Translate: 'Tack så mycket för hjälpen'",
                        correctAnswer: "Thank you so much for the help",
                        hint: "Tack = thanks, hjälpen = the help"
                    ),
                    Exercise(
                        id: "sfi_c_v4",
                        type: .translate,
                        prompt: "Translate: 'Hur mycket kostar det?'",
                        correctAnswer: "How much does it cost?",
                        hint: "kostar = costs"
                    ),
                    Exercise(
                        id: "sfi_c_v5",
                        type: .translate,
                        prompt: "Translate: 'Jag förstår inte'",
                        correctAnswer: "I do not understand",
                        hint: "förstår = understand, inte = not"
                    )
                ]
            )
        ],
        passingScore: 0.6
    )
    
    // MARK: - Course D Exam (B2 Level)
    public static let courseDExam = SFIExam(
        id: "sfi_exam_d",
        courseLevel: "D",
        title: "SFI Kurs D Prov",
        sections: [
            SFIExamSection(
                id: "sfi_d_reading",
                title: "Läsförståelse (Reading)",
                timeLimitSeconds: 240,
                exercises: [
                    Exercise(
                        id: "sfi_d_r1",
                        type: .multipleChoice,
                        prompt: "Arbetsförmedlingen erbjuder stöd till arbetssökande genom individuella handlingsplaner, praktikplatser och utbildningar. Syftet är att hjälpa människor att hitta ett arbete som matchar deras kompetens.\n\nVad är huvudsyftet med Arbetsförmedlingens stöd?",
                        correctAnswer: "Att matcha arbetssökande med rätt arbete",
                        options: ["Att ge alla samma jobb", "Att matcha arbetssökande med rätt arbete", "Att erbjuda gratis utbildning", "Att betala ut a-kassa"]
                    ),
                    Exercise(
                        id: "sfi_d_r2",
                        type: .multipleChoice,
                        prompt: "Enligt kollektivavtalet har anställda rätt till minst 25 semesterdagar per år. Semesterlön betalas ut under ledigheten och beräknas utifrån den ordinarie lönen.\n\nHur många semesterdagar har man minst rätt till?",
                        correctAnswer: "25 dagar",
                        options: ["20 dagar", "25 dagar", "30 dagar", "15 dagar"]
                    ),
                    Exercise(
                        id: "sfi_d_r3",
                        type: .multipleChoice,
                        prompt: "Diskriminering i arbetslivet innebär att någon behandlas sämre på grund av kön, ålder, etnisk tillhörighet eller funktionsnedsättning. Diskrimineringsombudsmannen (DO) tar emot anmälningar.\n\nVad gör DO?",
                        correctAnswer: "Tar emot anmälningar om diskriminering",
                        options: ["Anställer nya medarbetare", "Tar emot anmälningar om diskriminering", "Skriver nya lagar", "Betalar ut skadestånd"]
                    ),
                    Exercise(
                        id: "sfi_d_r4",
                        type: .multipleChoice,
                        prompt: "Fackföreningar förhandlar om löner och arbetsvillkor å medlemmarnas vägnar. I Sverige är ungefär 70% av alla arbetstagare fackligt anslutna.\n\nVad förhandlar fackföreningar om?",
                        correctAnswer: "Löner och arbetsvillkor",
                        options: ["Semesterresor", "Löner och arbetsvillkor", "Bostadspriser", "Skattenivåer"]
                    ),
                    Exercise(
                        id: "sfi_d_r5",
                        type: .multipleChoice,
                        prompt: "En provanställning kan vara högst sex månader. Under provanställningen kan både arbetsgivaren och den anställde avsluta anställningen utan särskilda skäl.\n\nHur länge kan en provanställning vara?",
                        correctAnswer: "Högst sex månader",
                        options: ["Tre månader", "Högst sex månader", "Ett år", "Två månader"]
                    )
                ]
            ),
            SFIExamSection(
                id: "sfi_d_grammar",
                title: "Grammatik & Ordföljd (Grammar & Word Order)",
                timeLimitSeconds: 240,
                exercises: [
                    Exercise(
                        id: "sfi_d_g1",
                        type: .wordOrder,
                        prompt: "Build: 'Tomorrow I will start my new job'",
                        correctAnswer: "Imorgon börjar jag mitt nya jobb",
                        words: ["jag", "börjar", "mitt", "nya", "jobb", "Imorgon"]
                    ),
                    Exercise(
                        id: "sfi_d_g2",
                        type: .fillBlank,
                        prompt: "Om jag ______ tid, skulle jag studera mer.",
                        correctAnswer: "hade",
                        options: ["har", "hade", "haft", "ha"]
                    ),
                    Exercise(
                        id: "sfi_d_g3",
                        type: .fillBlank,
                        prompt: "Det var en ______ bok som jag läste förra veckan.",
                        correctAnswer: "intressant",
                        options: ["intressant", "intressanta", "intressante", "intressants"]
                    ),
                    Exercise(
                        id: "sfi_d_g4",
                        type: .wordOrder,
                        prompt: "Build: 'At the meeting we discussed the budget'",
                        correctAnswer: "På mötet diskuterade vi budgeten",
                        words: ["vi", "diskuterade", "budgeten", "På mötet"]
                    ),
                    Exercise(
                        id: "sfi_d_g5",
                        type: .fillBlank,
                        prompt: "Hon berättade att hon ______ bott i Sverige i fem år.",
                        correctAnswer: "hade",
                        options: ["har", "hade", "har haft", "haft"]
                    )
                ]
            ),
            SFIExamSection(
                id: "sfi_d_vocab",
                title: "Ordförråd & Översättning (Vocabulary & Translation)",
                timeLimitSeconds: 240,
                exercises: [
                    Exercise(
                        id: "sfi_d_v1",
                        type: .translate,
                        prompt: "Translate: 'Jag vill ansöka om uppehållstillstånd'",
                        correctAnswer: "I want to apply for a residence permit",
                        hint: "ansöka = apply, uppehållstillstånd = residence permit"
                    ),
                    Exercise(
                        id: "sfi_d_v2",
                        type: .translate,
                        prompt: "Translate: 'Kan du förklara vad kollektivavtal innebär?'",
                        correctAnswer: "Can you explain what a collective agreement means?",
                        hint: "förklara = explain, kollektivavtal = collective agreement"
                    ),
                    Exercise(
                        id: "sfi_d_v3",
                        type: .translate,
                        prompt: "Translate: 'Arbetsgivaren erbjöd mig fast anställning'",
                        correctAnswer: "The employer offered me permanent employment",
                        hint: "arbetsgivaren = employer, fast anställning = permanent employment"
                    ),
                    Exercise(
                        id: "sfi_d_v4",
                        type: .translate,
                        prompt: "Translate: 'Facket förhandlar om bättre arbetsvillkor'",
                        correctAnswer: "The union negotiates for better working conditions",
                        hint: "facket = the union, arbetsvillkor = working conditions"
                    ),
                    Exercise(
                        id: "sfi_d_v5",
                        type: .translate,
                        prompt: "Translate: 'Skattedeklarationen ska lämnas in senast den 2 maj'",
                        correctAnswer: "The tax declaration must be submitted by May 2nd at the latest",
                        hint: "skattedeklarationen = tax declaration, lämnas in = submitted"
                    )
                ]
            )
        ],
        passingScore: 0.7
    )
    
    public static let allExams: [SFIExam] = [courseCExam, courseDExam]
}
