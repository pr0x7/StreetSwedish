import Foundation

public struct LessonData {
    
    // MARK: - Characters
    public static let maja = Character(
        id: "maja",
        name: "Maja",
        age: 32,
        bio: "Maja is a fast-paced senior software developer at a Stockholm fintech startup. She speaks fluent office-slang, lives on espresso, and loves taking things 'offline'.",
        dialectNote: "Stockholmska (clean, slightly singsong, urban pitch accent)",
        avatarAssetName: "maja_avatar",
        moduleIDs: ["arbete_tech"]
    )
    
    public static let erik = Character(
        id: "erik",
        name: "Erik",
        age: 26,
        bio: "Erik is a bartender working in Södermalm. He knows all the latest street slang, is incredibly relaxed, and loves planning the next After Work (AW).",
        dialectNote: "Södermalm slang (relaxed vowels, quick rhythm)",
        avatarAssetName: "erik_avatar",
        moduleIDs: ["socialt_bar"]
    )
    
    public static let linh = Character(
        id: "linh",
        name: "Linh",
        age: 20,
        bio: "Linh is a college student who lives on TikTok and texting. She writes almost exclusively in slang and abbreviations.",
        dialectNote: "Modern multiethnic youth register (shortened words, rapid staccato)",
        avatarAssetName: "linh_avatar",
        moduleIDs: ["sms_social", "gatanssprak", "dating"]
    )
    
    public static let karin = Character(
        id: "karin",
        name: "Karin",
        age: 45,
        bio: "Karin is a startup founder and angel investor. She wears smart casual blazers and speaks a polished yet highly pragmatic corporate Swedish.",
        dialectNote: "Rikssvenska (standard Swedish, clear articulation, professional)",
        avatarAssetName: "karin_avatar",
        moduleIDs: ["arbete_tech"]
    )
    
    public static let allCharacters: [Character] = [maja, erik, linh, karin]
    
    // MARK: - Categories & Modules
    public static let allModules: [Module] = [
        Module(
            id: "arbete_tech",
            categoryID: "work_tech",
            title: "Arbete & Tech",
            subtitle: "Workplace Survival & Software Swag",
            lessonIDs: ["tech_basics", "workplace_swag", "office_drama"],
            bossLevelID: "boss_arbete_tech",
            elitePhraseIDs: ["elite_tech_1", "elite_tech_2"],
            unlockRequirement: nil,
            wordCount: 24
        ),
        Module(
            id: "gatanssprak",
            categoryID: "street",
            title: "Gatans Språk",
            subtitle: "Street Slang & Suburb Vibe",
            lessonIDs: ["street_basics", "street_attitude", "street_lifestyle"],
            bossLevelID: "boss_gatanssprak",
            elitePhraseIDs: ["elite_street_1"],
            unlockRequirement: nil,
            wordCount: 13
        ),
        Module(
            id: "sms_social",
            categoryID: "sms",
            title: "SMS-Slang",
            subtitle: "Fast texts and abbreviations",
            lessonIDs: ["sms_basics", "sms_reactions", "sms_plans"],
            bossLevelID: "boss_sms_social",
            elitePhraseIDs: ["elite_sms_1"],
            unlockRequirement: nil,
            wordCount: 11
        ),
        Module(
            id: "socialt_bar",
            categoryID: "social",
            title: "Socialt & AW",
            subtitle: "Bar talk and hanging out",
            lessonIDs: ["social_drinking", "social_vibe", "social_food"],
            bossLevelID: "boss_socialt_bar",
            elitePhraseIDs: ["elite_social_1"],
            unlockRequirement: nil,
            wordCount: 9
        ),
        Module(
            id: "dating",
            categoryID: "dating",
            title: "Dejting & Kärlek",
            subtitle: "Romance and flirting slang",
            lessonIDs: ["dating_crush", "dating_drama", "dating_future"],
            bossLevelID: "boss_dating",
            elitePhraseIDs: ["elite_dating_1"],
            unlockRequirement: nil,
            wordCount: 8
        ),
        Module(
            id: "svordomar",
            categoryID: "swears",
            title: "Svordomar",
            subtitle: "Swedish swearing and curse words",
            lessonIDs: ["swears_mild", "swears_spicy", "swears_insults"],
            bossLevelID: "boss_svordomar",
            elitePhraseIDs: ["elite_swears_1"],
            unlockRequirement: nil,
            wordCount: 6
        ),
        Module(
            id: "bestallning",
            categoryID: "ordering",
            title: "Beställning",
            subtitle: "Ordering food, shopping & paying",
            lessonIDs: ["ordering_restaurant", "ordering_shopping", "ordering_delivery"],
            bossLevelID: "boss_bestallning",
            elitePhraseIDs: [],
            unlockRequirement: nil,
            wordCount: 20
        ),
        Module(
            id: "vardagen",
            categoryID: "everyday",
            title: "Vardagen",
            subtitle: "Numbers, days, food, directions & essentials",
            lessonIDs: ["everyday_numbers", "everyday_food", "everyday_getting_around", "everyday_people"],
            bossLevelID: "boss_vardagen",
            elitePhraseIDs: [],
            unlockRequirement: nil,
            wordCount: 80
        )
    ]
    
    // MARK: - Vocab Items
    
    // --- LESSON 1 VOCAB ---
    public static let standup = VocabItem(
        id: "vocab_standup",
        swedish: "standup",
        english: "morning standup meeting",
        pronunciation: "stænd-app",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vi tar det på vår standup klockan nio.",
                english: "We will take that in our standup at nine.",
                contextNote: "Used exactly like the agile term in English.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sounds exactly like 'standup' comedy, but instead of laughing, you stand in a circle talking about blockers.",
        visualHook: "Imagine your entire dev team standing up on chairs trying to tell jokes to a quiet boss.",
        cultureHook: "In Swedish flat-hierarchy tech offices, the standup is holy. Everyone is equal and reports directly to the team, not just the manager.",
        registerLabel: .workplaceOK,
        relatedItemIDs: ["vocab_sprint"]
    )
    
    public static let sprint = VocabItem(
        id: "vocab_sprint",
        swedish: "sprint",
        english: "development sprint",
        pronunciation: "sprint",
        exampleSentences: [
            ExampleSentence(
                swedish: "Är de här feature-korten med i vår nästa sprint?",
                english: "Are these feature cards included in our next sprint?",
                contextNote: "Refers to a 1-to-4 week work cycle in agile.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sounds like a running 'sprint' - and you will indeed be running to finish your tasks before the deadline.",
        visualHook: "Picture software engineers in business suits running a 100m sprint while typing frantically on laptops.",
        cultureHook: "Agile methodologies are everywhere in Sweden. Sprints dictate the rhythm of work, fika breaks, and planning.",
        registerLabel: .workplaceOK,
        relatedItemIDs: ["vocab_standup"]
    )
    
    public static let pinga = VocabItem(
        id: "vocab_pinga",
        swedish: "pinga",
        english: "to ping / message someone",
        pronunciation: "ping-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Pinga mig på Slack när du har kollat koden.",
                english: "Ping me on Slack when you've reviewed the code.",
                contextNote: "Action verb for sending a quick chat message.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sounds like a sonar 'ping' from a submarine.",
        visualHook: "Imagine hitting a giant ping-pong ball across the office directly into your colleague's forehead to get their attention.",
        cultureHook: "Swedes value written directness but avoid calling people out of the blue. Pinga is the polite way to ask 'are you free?'.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let vabba = VocabItem(
        id: "vocab_vabba",
        swedish: "vabba",
        english: "to stay home to care for a sick child",
        pronunciation: "vab-bah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag måste vabba idag, lillkillen har feber.",
                english: "I have to stay home with a sick child today, the little guy has a fever.",
                contextNote: "Acronym from VAB (Vård av barn), but conjugated as a standard verb.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sounds like a baby babbling 'vab-ba'.",
        visualHook: "Picture yourself wearing a business suit while feeding cough syrup to a toddler dressed as a giant Swedish meatball.",
        cultureHook: "A sacred Swedish institution. Parents get government-subsidized pay to stay home with sick kids. Never questioned at work.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let sajna = VocabItem(
        id: "vocab_sajna",
        swedish: "sajna",
        english: "to sign a contract / close a deal",
        pronunciation: "sajn-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vi lyckades sajna kunden igår kväll!",
                english: "We managed to sign the client yesterday evening!",
                contextNote: "Anglicism of 'to sign', very common in startup hubs.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'sign' with a Swedish verb ending '-a'.",
        visualHook: "Imagine a giant golden pen signing a contract, but it's held by a moose wearing trendy designer glasses.",
        cultureHook: "While standard Swedish is 'skriva under', startup culture loves 'sajna' because it sounds faster and more energetic.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let prio = VocabItem(
        id: "vocab_prio",
        swedish: "prio",
        english: "priority",
        pronunciation: "pree-oh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Att fixa buggen i kassan är vår högsta prio.",
                english: "Fixing the bug in checkout is our highest priority.",
                contextNote: "Short for prioritet.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sounds like 'Trio' (three people), but you only have ONE top priority.",
        visualHook: "Picture a massive red siren flashing 'PRIO' over a single line of buggy code.",
        cultureHook: "In Swedish consensus culture, setting 'prio' helps avoid confrontation by letting the data decide what is important.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let sittaIMote = VocabItem(
        id: "vocab_sitta_i_mote",
        swedish: "sitta i möte",
        english: "to be stuck/sitting in a meeting",
        pronunciation: "sitt-ah ee möh-teh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Maja kan inte prata nu, hon sitter i möte.",
                english: "Maja can't talk right now, she is in a meeting.",
                contextNote: "Standard phrase for explaining unavailability.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sitta sounds like 'sit'. Möte sounds like 'moat' around a castle.",
        visualHook: "Imagine being literally stuck sitting on a chair inside a wet moat around a castle, unable to escape a meeting.",
        cultureHook: "Swedes love meetings. 'Möteskultur' is real—decisions are reached by talking things through together.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let taDetOffline = VocabItem(
        id: "vocab_ta_det_offline",
        swedish: "ta det offline",
        english: "to discuss later outside the current meeting",
        pronunciation: "tah deh off-lajn",
        exampleSentences: [
            ExampleSentence(
                swedish: "Bra punkt, låt oss ta det offline så vi hinner klart.",
                english: "Good point, let's take it offline so we can finish on time.",
                contextNote: "Used to keep meetings on track.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sounds exactly like the English phrase 'take it offline' with Swedish grammar syntax.",
        visualHook: "Imagine taking a physical computer wire, unplugging it, and throwing it out the window into a snowy forest.",
        cultureHook: "A polite Swedish way of saying: 'You are off-topic, stop talking about this in front of everyone.'",
        registerLabel: .workplaceOK,
        relatedItemIDs: ["vocab_sitta_i_mote"]
    )
    
    // --- LESSON 2 VOCAB ---
    public static let paDet = VocabItem(
        id: "vocab_pa_det",
        swedish: "på det",
        english: "on it / handling it",
        pronunciation: "poh deh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Hinner du fixa databasen? - Ja, jag är på det!",
                english: "Do you have time to fix the database? - Yes, I'm on it!",
                contextNote: "Extremely common confirmation expression.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "På sounds like 'paw'. Imagine a dog putting its paw on a laptop, saying 'I'm on it!'",
        visualHook: "A golden retriever with glasses typing on a keyboard under a sign that says 'PÅ DET'.",
        cultureHook: "Demonstrates independence and initiative—highly valued traits in flat-structured Swedish workplaces.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let kingsMo = VocabItem(
        id: "vocab_kings_mo",
        swedish: "kings mö",
        english: "a legendary / super productive meeting",
        pronunciation: "kings möh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vilket kings mö vi hade, allt blev spikat!",
                english: "What a legendary meeting we had, everything got nailed down!",
                contextNote: "Super informal, slangy Swedish corporate speak. 'Mö' is short for 'möte'.",
                registerLabel: .slang
            )
        ],
        soundHook: "Kings (like English royalty) and Mö (sounds like 'muck' without the ck).",
        visualHook: "Imagine a meeting room where everyone is wearing paper crowns and drinking champagne because they finished early.",
        cultureHook: "Usually used with irony or high startup enthusiasm. Swedes generally hate boring meetings, so a good one is celebrated.",
        registerLabel: .slang,
        relatedItemIDs: ["vocab_sitta_i_mote"]
    )
    
    public static let codeReview = VocabItem(
        id: "vocab_code_review",
        swedish: "code review",
        english: "code review",
        pronunciation: "kohd ree-view",
        exampleSentences: [
            ExampleSentence(
                swedish: "Kan du göra en code review på min pull request?",
                english: "Can you do a code review on my pull request?",
                contextNote: "Agile tech jargon used in English form.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sounds exactly like English 'code review'.",
        visualHook: "Imagine an inspector with a magnifying glass staring at lines of binary code that are wearing tiny sunglasses.",
        cultureHook: "In Swedish tech teams, peer review is essential to maintain collective responsibility and prevent single points of failure.",
        registerLabel: .workplaceOK,
        relatedItemIDs: []
    )
    
    public static let fredagsmys = VocabItem(
        id: "vocab_fredagsmys",
        swedish: "fredagsmys",
        english: "Friday cozy wind-down time",
        pronunciation: "freh-dahgs-mees",
        exampleSentences: [
            ExampleSentence(
                swedish: "Nu tar vi helg och drar igång fredagsmyset!",
                english: "Now we start the weekend and get the Friday cozy-time going!",
                contextNote: "A national tradition of relaxing on Friday evening.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Fredag means Friday. Mys sounds like 'meese' (like moose, but cozy).",
        visualHook: "Picture yourself wrapped in a giant wool blanket on a couch, surrounded by tacos and chips.",
        cultureHook: "A cultural cornerstone. Traditionally involves couch sitting, eating tacos, snacks, and watching TV. In offices, it means Friday afternoon snacks.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let ASAP = VocabItem(
        id: "vocab_asap",
        swedish: "ASAP",
        english: "as soon as possible",
        pronunciation: "ah-sapp",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vi måste deploya den här patchen ASAP.",
                english: "We need to deploy this patch ASAP.",
                contextNote: "Often spoken phonetically as a single word 'asapp'.",
                registerLabel: .workplaceOK
            )
        ],
        soundHook: "Sounds like 'sap' (tree juice) with an 'A' in front.",
        visualHook: "Imagine running as fast as possible to escape a giant sticky wave of maple sap.",
        cultureHook: "Though English, Swedes say 'asapp' out loud in tech offices to indicate urgency without sounding too demanding.",
        registerLabel: .workplaceOK,
        relatedItemIDs: []
    )
    
    public static let kriga = VocabItem(
        id: "vocab_kriga",
        swedish: "kriga",
        english: "to grind / fight through a task",
        pronunciation: "kreeg-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Bara tio timmar kvar till release, nu krigar vi!",
                english: "Only ten hours left until release, let's grind it out!",
                contextNote: "Literally 'to wage war', but colloquially means working hard.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'creek' with an 'a' at the end. 'Kreeg-ah'.",
        visualHook: "Imagine yourself charging at a giant buggy server room while holding a sword made of a glowing Swedish flag.",
        cultureHook: "Used to build camaraderie during late-night coding sessions or crunch time. It frames hard work as a shared battle.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let spika = VocabItem(
        id: "vocab_spika",
        swedish: "spika",
        english: "to finalize / nail down a decision",
        pronunciation: "speek-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Då spikar vi den här designen till sprinten.",
                english: "Then we nail down this design for the sprint.",
                contextNote: "Literally 'to nail', figuratively to finalize a plan.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Sounds like 'speak-a'. When you speak-a, you nail the deal.",
        visualHook: "Imagine a giant wooden hammer nailing a software screen mockup to a whiteboard.",
        cultureHook: "Derives from academic publishing where PhD theses are literally 'nailed' to a wooden board once finalized.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let hojdare = VocabItem(
        id: "vocab_hojdare",
        swedish: "höjdare",
        english: "a higher-up / big boss",
        pronunciation: "hoy-dah-reh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Det kommer några höjdare från ledningen på besök idag.",
                english: "Some higher-ups from management are visiting today.",
                contextNote: "Literally 'high-one', informal term for corporate leaders.",
                registerLabel: .informal
            )
        ],
        soundHook: "Höj sounds like 'hoy' (as in 'ahoy'). Dare sounds like 'dare'. Ahoy, dare is a boss!",
        visualHook: "Imagine a corporate manager standing on top of a giant ladder in the middle of a modern office wearing a cape.",
        cultureHook: "Swedes generally dislike hierarchies, so calling someone a 'höjdare' is slightly informal/casual, reducing their authority.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    // --- LESSON 3 VOCAB ---
    public static let fika = VocabItem(
        id: "vocab_fika",
        swedish: "fika",
        english: "coffee and pastry break with coworkers",
        pronunciation: "feek-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Ska vi gå och fika nu? Bulle på kontoret!",
                english: "Shall we go get coffee and cake now? Cinnamon buns in the office!",
                contextNote: "Can be both a noun and a verb.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Sounds like 'fee-ka' (like picking a fee).",
        visualHook: "Imagine a giant coffee cup filled with cinnamon buns floating down the hallway, leading you away from your computer.",
        cultureHook: "Non-negotiable. It's a social institution to sit down, disconnect from work, and chat with colleagues. Not just a coffee to-go.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let gnalla = VocabItem(
        id: "vocab_gnalla",
        swedish: "gnälla",
        english: "to whine or complain",
        pronunciation: "g-nell-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Sluta gnälla på koden och skriv en test istället.",
                english: "Stop whining about the code and write a test instead.",
                contextNote: "Verb for complaining in a slightly annoying way.",
                registerLabel: .neutral
            )
        ],
        soundHook: "G-näll sounds like 'nell' (as in the bell). G-nell-ah.",
        visualHook: "Imagine a computer mouse that squeaks 'gnäll gnäll' every time it highlights a syntax error.",
        cultureHook: "Swedes value lagom (moderation) and consensus, so excessive 'gnäll' is looked down upon. Action is preferred.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let skitaI = VocabItem(
        id: "vocab_skita_i",
        swedish: "skita i",
        english: "to ignore / not care about something",
        pronunciation: "sheet-ah ee",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vi skiter i den buggen så länge, den är inte prio.",
                english: "We'll ignore that bug for now, it's not a priority.",
                contextNote: "Slightly vulgar-lite but widely used colloquially.",
                registerLabel: .slang
            )
        ],
        soundHook: "Skita sounds like 'sheet-ah' (meaning 'to poop').",
        visualHook: "Imagine a programmer literally throwing old papers over their shoulder with a poop emoji drawn on them.",
        cultureHook: "Highly expressive. It shows active decision-making to discard or disregard something useless.",
        registerLabel: .slang,
        usageWarning: "Informal. Do not use in formal presentations to clients, but fine among developers.",
        relatedItemIDs: ["vocab_prio"]
    )
    
    public static let losa = VocabItem(
        id: "vocab_losa",
        swedish: "lösa",
        english: "to solve / handle / fix it",
        pronunciation: "löh-sah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Oroa dig inte, jag löser det under dagen.",
                english: "Don't worry, I'll solve/handle it during the day.",
                contextNote: "Versatile verb meaning to resolve a problem.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Lösa sounds like 'loser'. But when you lösa something, you are actually a winner!",
        visualHook: "Imagine a giant key unlocking a Rubik's cube with a single turn.",
        cultureHook: "Reflects the Swedish value of self-reliance and practicality ('lösningsorienterad').",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let sjukskrivaSig = VocabItem(
        id: "vocab_sjukskriva_sig",
        swedish: "sjukskriva sig",
        english: "to call in sick",
        pronunciation: "shook-skree-vah sig",
        exampleSentences: [
            ExampleSentence(
                swedish: "Erik har sjukskrivit sig idag, han har halsont.",
                english: "Erik called in sick today, he has a sore throat.",
                contextNote: "Reflexive verb phrase.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Sjuk sounds like 'shook'. Imagine being so sick you are physically shook.",
        visualHook: "A sick doctor trying to write a prescription for themselves while wrapped in a massive blanket.",
        cultureHook: "In Sweden, taking care of one's health is highly respected. Sick leave is structured and paid from day two (with some rules).",
        registerLabel: .neutral,
        relatedItemIDs: ["vocab_vabba"]
    )
    
    public static let flexa = VocabItem(
        id: "vocab_flexa",
        swedish: "flexa",
        english: "to work flexible hours",
        pronunciation: "flex-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag flexar ut klockan tre för att hämta barnen.",
                english: "I am flexing out at three to pick up the kids.",
                contextNote: "Verb meaning to use flexible working hour policies.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Sounds like 'flexing' muscles. You are flexing your hours!",
        visualHook: "A programmer doing gym flex poses in front of a giant office clock that is melting like a Dali painting.",
        cultureHook: "Work-life balance is core to Swedish office life. Flexitime is standard, letting employees adapt their hours.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let overtid = VocabItem(
        id: "vocab_overtid",
        swedish: "övertid",
        english: "overtime",
        pronunciation: "uh-ver-teed",
        exampleSentences: [
            ExampleSentence(
                swedish: "Det blev mycket övertid den här veckan innan release.",
                english: "There was a lot of overtime this week before release.",
                contextNote: "Noun representing extra hours worked.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Över sounds like 'over'. Tid sounds like 'teed' (similar to time). Overtime!",
        visualHook: "Imagine a clock whose hands are spinning so fast they fly off and fly around the office.",
        cultureHook: "Working overtime is generally discouraged in Sweden. It is seen as a sign of poor planning rather than dedication.",
        registerLabel: .neutral,
        relatedItemIDs: ["vocab_flexa"]
    )
    
    public static let AW = VocabItem(
        id: "vocab_aw",
        swedish: "AW",
        english: "After Work drinks with colleagues",
        pronunciation: "ah-double-ve",
        exampleSentences: [
            ExampleSentence(
                swedish: "Ska du med på AW på Söder efter fem?",
                english: "Are you joining the After Work in Söder after five?",
                contextNote: "Spoken as 'AW' (Letters A and W in Swedish: ah-ve).",
                registerLabel: .informal
            )
        ],
        soundHook: "Pronounced 'Ah-ve'. Sounds like a sigh of relief ('ahhh') when work is finished.",
        visualHook: "Imagine office chairs rolling down the street and heading straight into a pub.",
        cultureHook: "A huge part of Swedish corporate culture. Colleagues gather directly after work on Fridays (or Thursdays) for beers/food.",
        registerLabel: .informal,
        relatedItemIDs: ["vocab_fika"]
    )
    
    // --- STREET LESSON VOCAB ---
    public static let bre = VocabItem(
        id: "vocab_bre",
        swedish: "bre",
        english: "brother / bro",
        pronunciation: "breh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vad gör du bre?",
                english: "What are you doing bro?",
                contextNote: "Extremely common street greeting.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'bread' without the 'd'.",
        visualHook: "Two pieces of bread greeting each other on the street.",
        cultureHook: "Originally from Balkan languages, popular among Swedish youth.",
        registerLabel: .slang,
        relatedItemIDs: []
    )
    
    public static let beckna = VocabItem(
        id: "vocab_beckna",
        swedish: "beckna",
        english: "to sell / hustle",
        pronunciation: "beck-nah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Han becknar grejer i orten.",
                english: "He is selling things in the suburb.",
                contextNote: "Suburban street hustle slang.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'beckon' (calling someone over).",
        visualHook: "Someone beckoning you into an alley to sell you socks.",
        cultureHook: "Heavy street/suburban usage for informal trading.",
        registerLabel: .slang,
        relatedItemIDs: []
    )
    
    public static let aina = VocabItem(
        id: "vocab_aina",
        swedish: "aina",
        english: "police",
        pronunciation: "eye-nah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Aina kommer, spring!",
                english: "The police are coming, run!",
                contextNote: "Suburban youth slang for police.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'I know' - police know everything.",
        visualHook: "A police car with giant eyes on the roof.",
        cultureHook: "Turkish origin, heavily used in Sweden's multiethnic suburbs.",
        registerLabel: .slang,
        relatedItemIDs: []
    )
    
    public static let guss = VocabItem(
        id: "vocab_guss",
        swedish: "guss",
        english: "girl / chick",
        pronunciation: "guss",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vem är den där gussen?",
                english: "Who is that girl?",
                contextNote: "Colloquial term for a young woman.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'gust' of wind.",
        visualHook: "A girl standing in a gust of wind.",
        cultureHook: "Turkish origin, very common suburban term.",
        registerLabel: .slang,
        relatedItemIDs: []
    )
    
    public static let keff = VocabItem(
        id: "vocab_keff",
        swedish: "keff",
        english: "bad / lame",
        pronunciation: "keff",
        exampleSentences: [
            ExampleSentence(
                swedish: "Den där filmen var helt keff.",
                english: "That movie was completely bad.",
                contextNote: "Describes something low quality or bad.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like a bad 'chef'.",
        visualHook: "A chef serving a burnt shoe.",
        cultureHook: "From Arabic meaning quality/mood, inverted in Sweden to mean bad.",
        registerLabel: .slang,
        relatedItemIDs: []
    )
    
    public static let tugg = VocabItem(
        id: "vocab_tugg",
        swedish: "tugg",
        english: "chat / hanging out",
        pronunciation: "tugg",
        exampleSentences: [
            ExampleSentence(
                swedish: "Kom, vi kör lite tugg.",
                english: "Come, let's chat a bit.",
                contextNote: "Literal meaning 'chewing', means chatting/hanging out.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'tug'.",
        visualHook: "Tug-of-war using a phone.",
        cultureHook: "Refers to the concept of chewing the fat / shooting the breeze.",
        registerLabel: .slang,
        relatedItemIDs: []
    )
    
    // --- SMS LESSON VOCAB ---
    public static let dd = VocabItem(
        id: "vocab_dd",
        swedish: "dd",
        english: "you then",
        pronunciation: "deh-deh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag e trött, dd?",
                english: "I'm tired, you?",
                contextNote: "SMS shorthand for 'du då?'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "Double D.",
        visualHook: "Two letters D talking to each other.",
        cultureHook: "Extremely common in texting.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )
    
    public static let vdg = VocabItem(
        id: "vocab_vdg",
        swedish: "vdg",
        english: "what are you doing",
        pronunciation: "veh-deh-geh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Tja vdg ikväll?",
                english: "Hey, what are you doing tonight?",
                contextNote: "SMS shorthand for 'vad gör du?'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "V-D-G letters.",
        visualHook: "Magnifying glass looking at someone texting.",
        cultureHook: "Texting shorthand for everyday check-in.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )
    
    public static let iaf = VocabItem(
        id: "vocab_iaf",
        swedish: "iaf",
        english: "in any case / anyway",
        pronunciation: "ee-ah-eff",
        exampleSentences: [
            ExampleSentence(
                swedish: "Det regnar, men vi ses iaf.",
                english: "It's raining, but we'll meet anyway.",
                contextNote: "SMS shorthand for 'i alla fall'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "I-A-F letters.",
        visualHook: "Signpost pointing in all directions.",
        cultureHook: "Saves characters in text messages.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )
    
    public static let ksk = VocabItem(
        id: "vocab_ksk",
        swedish: "ksk",
        english: "maybe",
        pronunciation: "kå-ess-kå",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag kommer ksk imorgon.",
                english: "I'm coming maybe tomorrow.",
                contextNote: "SMS shorthand for 'kanske'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "Sound of whispering 'k-s-k'.",
        visualHook: "Question mark balancing on a tightrope.",
        cultureHook: "Shortens standard word 'kanske'.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )
    
    public static let oxa = VocabItem(
        id: "vocab_oxa",
        swedish: "oxå",
        english: "also / too",
        pronunciation: "ock-saw",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag vill oxå ha fika.",
                english: "I also want coffee break.",
                contextNote: "Shorthand using 'x' for 'också'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "Sounds like 'ox' and 'saw'.",
        visualHook: "An ox sawing wood.",
        cultureHook: "Colloquial texting shortcut.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )
    
    // --- SOCIAL / AW LESSON VOCAB ---
    public static let bira = VocabItem(
        id: "vocab_bira",
        swedish: "bira",
        english: "beer",
        pronunciation: "beer-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Ska vi ta en bira efter jobbet?",
                english: "Shall we grab a beer after work?",
                contextNote: "Common slang for beer.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'beer' with an 'a'.",
        visualHook: "A beer waving at you.",
        cultureHook: "Very common in social settings.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let skal = VocabItem(
        id: "vocab_skal",
        swedish: "skål",
        english: "cheers",
        pronunciation: "skawl",
        exampleSentences: [
            ExampleSentence(
                swedish: "Skål för helgen!",
                english: "Cheers to the weekend!",
                contextNote: "Toasting expression.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Sounds like 'school'.",
        visualHook: "Skull wearing a party hat.",
        cultureHook: "Make eye contact when saying skål!",
        registerLabel: .neutral,
        relatedItemIDs: []
    )
    
    public static let kroka = VocabItem(
        id: "vocab_kroka",
        swedish: "kröka",
        english: "to drink / party",
        pronunciation: "kruh-kah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vi ska kröka på fredag.",
                english: "We are going to drink heavily on Friday.",
                contextNote: "Slang verb for drinking alcohol.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'croak'.",
        visualHook: "A frog holding a drink.",
        cultureHook: "Youth slang for partying.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let chilla = VocabItem(
        id: "vocab_chilla",
        swedish: "chilla",
        english: "to chill / relax",
        pronunciation: "chill-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag vill bara chilla hemma.",
                english: "I just want to chill at home.",
                contextNote: "Verb meaning to relax.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like English 'chill'.",
        visualHook: "Ice cube on a hammock.",
        cultureHook: "Widely used in modern Swedish.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let taggad = VocabItem(
        id: "vocab_taggad",
        swedish: "taggad",
        english: "hyped / pumped",
        pronunciation: "tag-ahd",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag är så taggad på konserten!",
                english: "I am so hyped for the concert!",
                contextNote: "Adjective meaning excited/alert.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'tagged'.",
        visualHook: "Excited price tag.",
        cultureHook: "Derived from 'tagg' (spike/thorn).",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    // --- DATING LESSON VOCAB ---
    public static let ragg = VocabItem(
        id: "vocab_ragg",
        swedish: "ragg",
        english: "pickup / flirt",
        pronunciation: "ragg",
        exampleSentences: [
            ExampleSentence(
                swedish: "Han hittade ett ragg på klubben.",
                english: "He found a pickup/flirt at the club.",
                contextNote: "Noun/verb for picking someone up.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'rag'.",
        visualHook: "Car covered in rags trying to look cool.",
        cultureHook: "Dating scene terminology.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let haffa = VocabItem(
        id: "vocab_haffa",
        swedish: "haffa",
        english: "to hook up / catch",
        pronunciation: "haff-ah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag ska försöka haffa henne ikväll.",
                english: "I will try to hook up with her tonight.",
                contextNote: "Slang for getting/hooking up.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'half a'.",
        visualHook: "Hand catching a flying heart.",
        cultureHook: "Modern youth slang.",
        registerLabel: .slang,
        relatedItemIDs: []
    )
    
    public static let strula = VocabItem(
        id: "vocab_strula",
        swedish: "strula",
        english: "to make out / mess around",
        pronunciation: "strew-lah",
        exampleSentences: [
            ExampleSentence(
                swedish: "De strulade hela natten.",
                english: "They made out all night.",
                contextNote: "Verb meaning to kiss/make out.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'strudel'.",
        visualHook: "Two strudels hugging.",
        cultureHook: "Common teen/young adult term.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    public static let dumpa = VocabItem(
        id: "vocab_dumpa",
        swedish: "dumpa",
        english: "to dump",
        pronunciation: "dum-pah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Hon dumpade sin kille.",
                english: "She dumped her boyfriend.",
                contextNote: "To end a relationship.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'dump'.",
        visualHook: "Dump truck dumping hearts.",
        cultureHook: "Informal breakup word.",
        registerLabel: .informal,
        relatedItemIDs: []
    )
    
    // --- SWEARS LESSON VOCAB ---
    public static let fan = VocabItem(
        id: "vocab_fan",
        swedish: "fan",
        english: "damn / devil",
        pronunciation: "fahn",
        exampleSentences: [
            ExampleSentence(
                swedish: "Fan, jag tappade nycklarna!",
                english: "Damn, I dropped my keys!",
                contextNote: "Most common Swedish curse word.",
                registerLabel: .vulgar
            )
        ],
        soundHook: "Sounds like 'fan'.",
        visualHook: "Fan blowing devil horns.",
        cultureHook: "Widely used for frustration.",
        registerLabel: .vulgar,
        relatedItemIDs: []
    )
    
    public static let javlar = VocabItem(
        id: "vocab_javlar",
        swedish: "jävlar",
        english: "damn / devils",
        pronunciation: "yev-lar",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jävlar, vad kallt det är!",
                english: "Damn, how cold it is!",
                contextNote: "Plural of devil, used for emphasis.",
                registerLabel: .vulgar
            )
        ],
        soundHook: "Sounds like 'yeller'.",
        visualHook: "Tiny devils screaming.",
        cultureHook: "Strong emphasis/swear.",
        registerLabel: .vulgar,
        relatedItemIDs: []
    )
    
    public static let helvete = VocabItem(
        id: "vocab_helvete",
        swedish: "helvete",
        english: "hell",
        pronunciation: "hel-veh-teh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Dra åt helvete!",
                english: "Go to hell!",
                contextNote: "Strong curse word.",
                registerLabel: .vulgar
            )
        ],
        soundHook: "Sounds like 'hell-wait'.",
        visualHook: "Waiting room in hell.",
        cultureHook: "Strong curse word.",
        registerLabel: .vulgar,
        relatedItemIDs: []
    )
    
    // --- ADDITIONAL STREET LESSON VOCAB ---
    public static let para = VocabItem(
        id: "vocab_para",
        swedish: "para",
        english: "money",
        pronunciation: "pah-rah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag har inga para kvar.",
                english: "I have no money left.",
                contextNote: "Turkish origin slang for money.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'para' in parachute.",
        visualHook: "Money falling down with tiny parachutes.",
        cultureHook: "Very common in Swedish rap lyrics and youth conversations.",
        registerLabel: .slang,
        relatedItemIDs: []
    )

    public static let shurda = VocabItem(
        id: "vocab_shurda",
        swedish: "shurda",
        english: "guy / dude",
        pronunciation: "shoor-dah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vem är den där shurdan?",
                english: "Who is that guy?",
                contextNote: "Slang term for a man or boy.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'sure, duh!'.",
        visualHook: "A guy shrugs and says 'sure, duh!'.",
        cultureHook: "Suburban youth register.",
        registerLabel: .slang,
        relatedItemIDs: []
    )

    public static let ortens = VocabItem(
        id: "vocab_ortens",
        swedish: "ortens",
        english: "of the hood / local style",
        pronunciation: "or-tens",
        exampleSentences: [
            ExampleSentence(
                swedish: "Han äter bara ortens kebab.",
                english: "He only eats local hood-style kebab.",
                contextNote: "From 'orten' (the suburb), used as an adjective.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'or tense' (tense situation).",
        visualHook: "A nervous kebab skewer sweating.",
        cultureHook: "Represents suburban culture and identity.",
        registerLabel: .slang,
        relatedItemIDs: []
    )

    public static let lax = VocabItem(
        id: "vocab_lax",
        swedish: "lax",
        english: "thousand crowns (1000 kr)",
        pronunciation: "lax",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jackan kostade fem lax.",
                english: "The jacket cost five thousand crowns.",
                contextNote: "Literal meaning 'salmon', slang for 1000 SEK.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds exactly like 'lax' (loose) or 'salmon' (lax in Swedish).",
        visualHook: "A salmon swimming upstream with 1000-SEK bills.",
        cultureHook: "Traditional Swedish slang that is still widely used today.",
        registerLabel: .informal,
        relatedItemIDs: []
    )

    public static let kanin = VocabItem(
        id: "vocab_kanin",
        swedish: "kanin",
        english: "million crowns (1,000,000 kr)",
        pronunciation: "kah-neen",
        exampleSentences: [
            ExampleSentence(
                swedish: "Han tjänade en kanin på affären.",
                english: "He earned a million from the deal.",
                contextNote: "Literal meaning 'rabbit', slang for 1,000,000 SEK.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'cane in'.",
        visualHook: "A rabbit wearing a gold crown holding a million SEK.",
        cultureHook: "Suburban financial slang, often used in hip hop.",
        registerLabel: .slang,
        relatedItemIDs: []
    )

    public static let jalla = VocabItem(
        id: "vocab_jalla",
        swedish: "jalla",
        english: "hurry up / come on",
        pronunciation: "yal-lah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jalla, vi kommer för sent!",
                english: "Hurry up, we will be late!",
                contextNote: "Arabic origin, meaning hurry up.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'y'all'.",
        visualHook: "A running snail with a jetpack.",
        cultureHook: "Extremely well-known slang used even by non-slang speakers.",
        registerLabel: .slang,
        relatedItemIDs: []
    )

    public static let abo = VocabItem(
        id: "vocab_abo",
        swedish: "abo",
        english: "wow / whoa",
        pronunciation: "ah-boh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Abo, kolla på hans bil!",
                english: "Wow, look at his car!",
                contextNote: "Expression of surprise or shock.",
                registerLabel: .slang
            )
        ],
        soundHook: "Sounds like 'elbow'.",
        visualHook: "An elbow flying into the air with surprise.",
        cultureHook: "Suburban slang exclamation.",
        registerLabel: .slang,
        relatedItemIDs: []
    )

    // --- ADDITIONAL SMS LESSON VOCAB ---
    public static let cs = VocabItem(
        id: "vocab_cs",
        swedish: "cs",
        english: "see you / see each other",
        pronunciation: "seh-ess",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vi cs vid sju.",
                english: "We'll see each other at seven.",
                contextNote: "SMS shorthand for 'ses'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "Sounds like 'C-S' (Counter-Strike).",
        visualHook: "Two letters waving goodbye.",
        cultureHook: "Texting abbreviation.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )

    public static let vgd = VocabItem(
        id: "vocab_vgd",
        swedish: "vgd",
        english: "what are you doing",
        pronunciation: "veh-yeh-deh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Tja, vgd?",
                english: "Hey, what are you doing?",
                contextNote: "Shorthand for 'vad gör du?'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "V-G-D letters.",
        visualHook: "A lazy dog texting from a couch.",
        cultureHook: "Very common check-in text.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )

    public static let idg = VocabItem(
        id: "vocab_idg",
        swedish: "idg",
        english: "today",
        pronunciation: "ee-deh-yeh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Kan vi ses idg?",
                english: "Can we meet today?",
                contextNote: "SMS shorthand for 'idag'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "I-D-G letters.",
        visualHook: "A calendar page with a big star on today.",
        cultureHook: "Texting convenience.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )

    public static let imr = VocabItem(
        id: "vocab_imr",
        swedish: "imr",
        english: "tomorrow",
        pronunciation: "ee-em-arr",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vi tar det imr.",
                english: "We will take it tomorrow.",
                contextNote: "SMS shorthand for 'imorgon'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "I-M-R letters.",
        visualHook: "Sun rising behind a clock.",
        cultureHook: "Used for scheduling quickly.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )

    public static let dsm = VocabItem(
        id: "vocab_dsm",
        swedish: "dsm",
        english: "likewise / same to you",
        pronunciation: "deh-ess-em",
        exampleSentences: [
            ExampleSentence(
                swedish: "Ha en bra helg! - Tack, dsm!",
                english: "Have a great weekend! - Thanks, likewise!",
                contextNote: "SMS shorthand for 'detsamma'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "D-S-M letters.",
        visualHook: "Two mirrors reflecting each other.",
        cultureHook: "Standard polite response in texting.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )

    public static let ftg = VocabItem(
        id: "vocab_ftg",
        swedish: "ftg",
        english: "company / corporate business",
        pronunciation: "eff-teh-yeh",
        exampleSentences: [
            ExampleSentence(
                swedish: "Han jobbar på ett stort ftg.",
                english: "He works at a big company.",
                contextNote: "Shorthand for 'företag'.",
                registerLabel: .textOnly
            )
        ],
        soundHook: "F-T-G letters.",
        visualHook: "A tall glass building with a suit inside.",
        cultureHook: "Office/business shorthand in text.",
        registerLabel: .textOnly,
        relatedItemIDs: []
    )

    // --- ADDITIONAL SOCIAL / AW LESSON VOCAB ---
    public static let krubb = VocabItem(
        id: "vocab_krubb",
        swedish: "krubb",
        english: "food / grub",
        pronunciation: "kroob",
        exampleSentences: [
            ExampleSentence(
                swedish: "Nu är det dags för lite krubb.",
                english: "Now it's time for some food.",
                contextNote: "Slang for food, equivalent to 'grub'.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'crab'.",
        visualHook: "A crab eating a giant hamburger.",
        cultureHook: "Casual, relaxed word for food.",
        registerLabel: .informal,
        relatedItemIDs: []
    )

    public static let fyllekak = VocabItem(
        id: "vocab_fyllekak",
        swedish: "fyllekäk",
        english: "drunk food",
        pronunciation: "fyl-leh-shehk",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vi drar till Max för lite fyllekäk.",
                english: "We are heading to Max (burger chain) for some drunk food.",
                contextNote: "Compound word: 'fylla' (drunkenness) + 'käk' (food).",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'fill-a-cake'.",
        visualHook: "A happy person holding a burger and a kebab at 3 AM.",
        cultureHook: "A core rite of passage after a Swedish night out.",
        registerLabel: .informal,
        relatedItemIDs: []
    )

    public static let kaka = VocabItem(
        id: "vocab_kaka",
        swedish: "käka",
        english: "to eat / grab food",
        pronunciation: "sheh-kah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vill du käka nåt innan bio?",
                english: "Do you want to grab food before the movie?",
                contextNote: "Very common casual verb for eating.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'shaking' without the 'ing'.",
        visualHook: "A mouth chewing on pizza.",
        cultureHook: "Used far more than 'äta' in colloquial conversations.",
        registerLabel: .informal,
        relatedItemIDs: []
    )

    public static let sugen = VocabItem(
        id: "vocab_sugen",
        swedish: "sugen",
        english: "craving / in the mood for",
        pronunciation: "sew-yen",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag är sjukt sugen på pizza.",
                english: "I am super craving pizza.",
                contextNote: "Adjective describing hunger/craving.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'sewing' machine.",
        visualHook: "A needle sewing a slice of pepperoni.",
        cultureHook: "Essential Swedish word for expressing desire for food or activity.",
        registerLabel: .informal,
        relatedItemIDs: []
    )

    // --- ADDITIONAL DATING LESSON VOCAB ---
    public static let ex = VocabItem(
        id: "vocab_ex",
        swedish: "ex",
        english: "ex-partner",
        pronunciation: "ex",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag sprang in i mitt ex idag.",
                english: "I ran into my ex today.",
                contextNote: "Short for ex-partner.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Sounds exactly like English 'ex'.",
        visualHook: "A giant red X standing between a couple.",
        cultureHook: "Universally understood.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )

    public static let sambo = VocabItem(
        id: "vocab_sambo",
        swedish: "sambo",
        english: "cohabitating partner",
        pronunciation: "sam-bo",
        exampleSentences: [
            ExampleSentence(
                swedish: "Jag och min sambo har köpt lägenhet.",
                english: "Me and my cohabitating partner bought an apartment.",
                contextNote: "Legal and social term for living together without marriage.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Sounds like 'samba'.",
        visualHook: "A couple dancing samba in their new living room.",
        cultureHook: "Extremely common in Sweden, often preferred over marriage.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )

    public static let singel = VocabItem(
        id: "vocab_singel",
        swedish: "singel",
        english: "single",
        pronunciation: "sing-el",
        exampleSentences: [
            ExampleSentence(
                swedish: "Är du singel eller i ett förhållande?",
                english: "Are you single or in a relationship?",
                contextNote: "Relationship status.",
                registerLabel: .neutral
            )
        ],
        soundHook: "Sounds exactly like English 'single'.",
        visualHook: "A single solo musical note playing on stage.",
        cultureHook: "Standard relationship term.",
        registerLabel: .neutral,
        relatedItemIDs: []
    )

    public static let ghosta = VocabItem(
        id: "vocab_ghosta",
        swedish: "ghosta",
        english: "to ghost (suddenly stop replying)",
        pronunciation: "goh-stah",
        exampleSentences: [
            ExampleSentence(
                swedish: "Han ghostade mig efter första dejten.",
                english: "He ghosted me after the first date.",
                contextNote: "Swedified English dating verb.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'ghost'.",
        visualHook: "A friendly ghost holding a phone with no replies.",
        cultureHook: "Modern digital dating culture.",
        registerLabel: .informal,
        relatedItemIDs: []
    )

    // --- ADDITIONAL SWEARS LESSON VOCAB ---
    public static let skit = VocabItem(
        id: "vocab_skit",
        swedish: "skit",
        english: "crap / shit",
        pronunciation: "sheet",
        exampleSentences: [
            ExampleSentence(
                swedish: "Vilket skitväder!",
                english: "What crappy weather!",
                contextNote: "Very common mild swear and prefix meaning 'very'.",
                registerLabel: .informal
            )
        ],
        soundHook: "Sounds like 'sheet' of paper.",
        visualHook: "A wet sheet of paper in the rain.",
        cultureHook: "Can be vulgar or just informal depending on tone and context.",
        registerLabel: .informal,
        relatedItemIDs: []
    )

    public static let skitstovel = VocabItem(
        id: "vocab_skitstovel",
        swedish: "skitstövel",
        english: "asshole / jerk",
        pronunciation: "sheet-stuhv-el",
        exampleSentences: [
            ExampleSentence(
                swedish: "Han är en riktig skitstövel.",
                english: "He is a real asshole.",
                contextNote: "Literal translation: 'shit-boot'.",
                registerLabel: .vulgar
            )
        ],
        soundHook: "Sounds like 'sheet' + 'stove'.",
        visualHook: "A boot made of mud walking on a stove.",
        cultureHook: "Old-school but highly effective insult.",
        registerLabel: .vulgar,
        relatedItemIDs: []
    )

    public static let satan = VocabItem(
        id: "vocab_satan",
        swedish: "satan",
        english: "damn / satan",
        pronunciation: "sah-tahn",
        exampleSentences: [
            ExampleSentence(
                swedish: "Satan också, jag glömde plånboken!",
                english: "Damn it, I forgot my wallet!",
                contextNote: "Religious-based swear word.",
                registerLabel: .vulgar
            )
        ],
        soundHook: "Sounds like 'satan'.",
        visualHook: "A pitchfork on fire.",
        cultureHook: "Middle-intensity swear word.",
        registerLabel: .vulgar,
        relatedItemIDs: []
    )

    public static let allVocabItems: [VocabItem] = [
        standup, sprint, pinga, vabba, sajna, prio, sittaIMote, taDetOffline,
        paDet, kingsMo, codeReview, fredagsmys, ASAP, kriga, spika, hojdare,
        fika, gnalla, skitaI, losa, sjukskrivaSig, flexa, overtid, AW,
        bre, beckna, aina, guss, keff, tugg,
        para, shurda, ortens, lax, kanin, jalla, abo,
        dd, vdg, iaf, ksk, oxa,
        cs, vgd, idg, imr, dsm, ftg,
        bira, skal, kroka, chilla, taggad,
        krubb, fyllekak, kaka, sugen,
        ragg, haffa, strula, dumpa,
        ex, sambo, singel, ghosta,
        fan, javlar, helvete,
        skit, skitstovel, satan
    ] + expansionVocab
    
    // MARK: - Dialogues
    public static let techDialogues: [Dialogue] = [
        Dialogue(
            title: "Planeringsmöte (Planning Meeting)",
            lines: [
                DialogueLine(
                    speakerID: "karin",
                    swedish: "Maja, är alla feature-kort klara för nästa sprint?",
                    english: "Maja, are all feature cards ready for the next sprint?",
                    alternativeFormal: "Maja, är alla uppgiftsbeskrivningar klara för nästa planering?",
                    culturalNote: "Sprint is a direct loanword from Agile software development, used universally in Swedish tech hubs. The formal translation swaps 'sprint' and 'feature-kort' for traditional terms."
                ),
                DialogueLine(
                    speakerID: "maja",
                    swedish: "Nästan, jag sitter i möte med designern nu. Jag löser det ASAP.",
                    english: "Almost, I'm sitting in a meeting with the designer now. I will solve it ASAP.",
                    alternativeSlang: "Nästan, sitter i möte med designern nu. Löser det direkt.",
                    alternativeFormal: "Nästan, jag befinner mig i ett möte med formgivaren nu. Jag ska ordna det så snart som möjligt.",
                    culturalNote: "ASAP is pronounced as individual letters (A-S-A-P) or 'så fort som möjligt'. 'Sitta i möte' is the standard Swedish phrase meaning to be occupied in a meeting."
                ),
                DialogueLine(
                    speakerID: "karin",
                    swedish: "Grymt. Pinga mig på Slack när du är klar så vi kan spika listan.",
                    english: "Great. Ping me on Slack when you are done so we can nail down the list.",
                    alternativeSlang: "Fett. Plinga mig på Slack sen så vi spikar listan.",
                    alternativeFormal: "Utmärkt. Kontakta mig via Slack när du är färdig så att vi kan fastställa listan.",
                    culturalNote: "'Grymt' literally means 'cruel' but colloquially means 'awesome/great'. 'Spika' literally means 'to nail' but in workplace context means to finalize/make a firm decision."
                )
            ],
            pullQuote: "Jag löser det ASAP. (I'll solve it ASAP.)"
        ),
        Dialogue(
            title: "Slack Drama",
            lines: [
                DialogueLine(
                    speakerID: "maja",
                    swedish: "Kan någon göra en code review på min pull request?",
                    english: "Can someone do a code review on my pull request?",
                    alternativeSlang: "Kan nån kika på min pull request?",
                    alternativeFormal: "Kan någon vänligen granska min kodändring?",
                    culturalNote: "English terms like 'code review' and 'pull request' are fully integrated into modern Swedish developer terminology."
                ),
                DialogueLine(
                    speakerID: "erik",
                    swedish: "Jag är på det! Men jag måste vabba i eftermiddag, så jag kollar nu.",
                    english: "I'm on it! But I have to care for my sick child this afternoon, so I'll check now.",
                    alternativeSlang: "Jag löser det! Måste vabba i eftermiddag, kollar nu.",
                    alternativeFormal: "Jag tar hand om det! Men jag behöver ta hand om ett sjukt barn i eftermiddag, så jag granskar det nu.",
                    culturalNote: "'Vabba' is a unique Swedish verb meaning 'to stay home to care for a sick child while receiving government compensation' (VAB - vård av barn). It is a highly respected aspect of Swedish work-life balance."
                ),
                DialogueLine(
                    speakerID: "maja",
                    swedish: "Tack Erik! Vi tar feedbacken offline sen.",
                    english: "Thanks Erik! We will take the feedback offline later.",
                    alternativeSlang: "Tack som fan Erik! Vi tar feedbacken offline sen.",
                    alternativeFormal: "Tack så mycket Erik! Vi kan diskutera återkopplingen enskilt senare.",
                    culturalNote: "'Offline' is used as a Swenglish workspace idiom for discussing details in private rather than dragging out a public meeting."
                )
            ],
            pullQuote: "Jag är på det! (I'm on it!)"
        )
    ]
    
    // MARK: - Lesson Exercises
    
    // Lesson 1 Exercises
    public static let lesson1Exercises = [
        Exercise(
            id: "ex_l1_1",
            type: .multipleChoice,
            prompt: "What does the word 'vabba' mean?",
            correctAnswer: "Stay home to care for a sick child",
            options: ["Stay home to work on code", "Go for a long coffee break", "Stay home to care for a sick child", "Attend a morning standup meeting"]
        ),
        Exercise(
            id: "ex_l1_2",
            type: .fillBlank,
            prompt: "Pinga mig på ______ när koden är klar.",
            correctAnswer: "Slack",
            options: ["Fika", "Slack", "Möte", "Vabba"]
        ),
        Exercise(
            id: "ex_l1_3",
            type: .wordOrder,
            prompt: "Assemble: 'We will take that in our standup'",
            correctAnswer: "Vi tar det på vår standup",
            words: ["på", "Vi", "vår", "standup", "det", "tar"]
        ),
        Exercise(
            id: "ex_l1_4",
            type: .translate,
            prompt: "Translate: 'Jag måste vabba idag'",
            correctAnswer: "I have to stay home with a sick child today",
            hint: "Vabba = Vård av barn (care of child)"
        ),
        Exercise(
            id: "ex_l1_5",
            type: .dialoguePick,
            prompt: "Maja asks: 'Hinner du kolla min kod?' -> What is Erik's best response?",
            correctAnswer: "Jag är på det! Pinga mig på Slack.",
            options: ["Jag skiter i det.", "Jag är på det! Pinga mig på Slack.", "Jag måste sjukskriva mig."]
        ),
        // Conversation Sim: Maja & User
        Exercise(
            id: "ex_l1_6",
            type: .conversationSim,
            prompt: "Complete the chat line with Maja. She says: 'Kan vi ta diskussionen på vår standup?'",
            correctAnswer: "Ja, låt oss ta det offline om det behövs.",
            options: ["Nej, jag ska vabba hela året.", "Ja, låt oss ta det offline om det behövs.", "Jag hatar fika."]
        )
    ]
    
    // Lesson 2 Exercises
    public static let lesson2Exercises = [
        Exercise(
            id: "ex_l2_1",
            type: .multipleChoice,
            prompt: "What is the meaning of 'spika'?",
            correctAnswer: "Finalize / nail down a decision",
            options: ["Write a lines of code", "Finalize / nail down a decision", "Call in sick", "Go out for drinks"]
        ),
        Exercise(
            id: "ex_l2_2",
            type: .fillBlank,
            prompt: "Vilket ______ mö vi hade idag, allt blev spikat!",
            correctAnswer: "kings",
            options: ["gnälla", "flexa", "kings", "sjukt"]
        ),
        Exercise(
            id: "ex_l2_3",
            type: .wordOrder,
            prompt: "Assemble: 'I am on it'",
            correctAnswer: "Jag är på det",
            words: ["är", "det", "Jag", "på"]
        ),
        Exercise(
            id: "ex_l2_4",
            type: .errorCorrection,
            prompt: "Find the mistake: 'Nu tar vi helg och drar igång fredagsmyset ASAP klockan nio'",
            correctAnswer: "ASAP",
            hint: "Usually fredagsmys is relaxed and cozy, not rushed 'ASAP'."
        )
    ]
    
    // Lesson 3 Exercises
    public static let lesson3Exercises = [
        Exercise(
            id: "ex_l3_1",
            type: .multipleChoice,
            prompt: "What does 'AW' stand for in Sweden?",
            correctAnswer: "After Work drinks",
            options: ["Always Working", "After Work drinks", "Awesome Weekend", "Agile Workshop"]
        ),
        Exercise(
            id: "ex_l3_2",
            type: .fillBlank,
            prompt: "Ska du med på ______ på fredag?",
            correctAnswer: "AW",
            options: ["sprint", "AW", "vabba", "gnälla"]
        ),
        Exercise(
            id: "ex_l3_3",
            type: .wordOrder,
            prompt: "Assemble: 'Stop whining about the code'",
            correctAnswer: "Sluta gnälla på koden",
            words: ["koden", "Sluta", "på", "gnälla"]
        ),
        Exercise(
            id: "ex_l3_4",
            type: .sentenceBuilder,
            prompt: "Build: 'I will ignore that bug'",
            correctAnswer: "Jag skiter i den buggen",
            words: ["i", "Jag", "buggen", "skiter", "den"]
        )
    ]
    
    // MARK: - Lessons Mapping
    public static let allLessons: [Lesson] = [
        Lesson(
            id: "tech_basics",
            moduleID: "arbete_tech",
            title: "Tech Slang Basics",
            estimatedMinutes: 15,
            vocabItems: [standup, sprint, pinga, vabba, sajna, prio, sittaIMote, taDetOffline],
            culturalContextCard: CulturalContextCard(
                bodyText: "Welcome to Swedish startup life! In Sweden, hierarchies are flat. You call your CEO by their first name, and decision-making requires consensus. If you want to raise a point, do it at the standup. If it drags on, a colleague will politely suggest to 'ta det offline'.",
                illustrationName: "flat_hierarchy_illustration"
            ),
            dialogues: [techDialogues[0]],
            exercises: lesson1Exercises,
            characterIDs: ["karin", "maja"],
            grammarOverview: """
            VÄLKOMMEN TILL TECH-BASICS!
            
            Grammar Focus: The V2 Word Order Rule
            In Swedish, the verb must always be the second element in a declarative sentence. If you start a sentence with a time or place adverbial, the subject and verb invert:
            - Normal: "Vi tar (verb) det på vår standup klockan nio."
            - Inverted: "Klockan nio tar (verb) vi (subject) det på vår standup."
            
            Cultural Vibe: Konsensus & Fika
            Corporate Sweden values equality and flat hierarchies. If a meeting drags on, use the verb 'ta det offline' to politely defer details.
            """
        ),
        Lesson(
            id: "workplace_swag",
            moduleID: "arbete_tech",
            title: "Workplace Survival & Swag",
            estimatedMinutes: 15,
            vocabItems: [paDet, kingsMo, codeReview, fredagsmys, ASAP, kriga, spika, hojdare],
            culturalContextCard: CulturalContextCard(
                bodyText: "Agile rituals dictate everything in Stockholm tech hubs. But after a hard sprint of 'krigande' (grinding), Swedish workers pivot to the sacred 'fredagsmys' (Friday cozy time). Even high-up management ('höjdare') participate in making the team feel comfortable.",
                illustrationName: "cozy_office_illustration"
            ),
            dialogues: [techDialogues[1]],
            exercises: lesson2Exercises,
            characterIDs: ["maja", "erik"]
        ),
        Lesson(
            id: "office_drama",
            moduleID: "arbete_tech",
            title: "Office Dramas & Socializing",
            estimatedMinutes: 15,
            vocabItems: [fika, gnalla, skitaI, losa, sjukskrivaSig, flexa, overtid, AW],
            culturalContextCard: CulturalContextCard(
                bodyText: "Two words rule the social calendar: 'fika' (morning/afternoon coffee and cake) and 'AW' (After Work drinks). If someone is feeling down, they can 'flexa' or 'sjukskriva sig' without judgment. It is all about balance. Work hard, but never complain ('gnälla') without offering to 'lösa' the issue.",
                illustrationName: "fika_aw_illustration"
            ),
            dialogues: [],
            exercises: lesson3Exercises,
            characterIDs: ["maja", "erik", "karin"]
        ),
        
        // --- STREET MODULE LESSONS ---
        Lesson(
            id: "street_basics",
            moduleID: "gatanssprak",
            title: "Gatans Grundläggande",
            estimatedMinutes: 10,
            vocabItems: [bre, beckna, aina],
            culturalContextCard: CulturalContextCard(
                bodyText: "Street Swedish (Miljonsvenska) originated in the multicultural suburbs of Stockholm, Gothenburg, and Malmö. It mixes Swedish with Arabic, Turkish, and Balkan words.",
                illustrationName: "street_suburb_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_st1_1",
                    type: .multipleChoice,
                    prompt: "What does 'bre' mean?",
                    correctAnswer: "brother / bro",
                    options: ["bread", "brother / bro", "police", "money"]
                ),
                Exercise(
                    id: "ex_st1_2",
                    type: .fillBlank,
                    prompt: "Akta dig, ______ kommer!",
                    correctAnswer: "aina",
                    options: ["bre", "guss", "aina", "tugg"]
                )
            ],
            characterIDs: ["erik"]
        ),
        Lesson(
            id: "street_attitude",
            moduleID: "gatanssprak",
            title: "Attityd & Vibe",
            estimatedMinutes: 10,
            vocabItems: [guss, keff, tugg],
            culturalContextCard: CulturalContextCard(
                bodyText: "Having a cool attitude and hanging out with friends ('tugga') is central to street culture. Saying something is 'keff' expresses strong disappointment.",
                illustrationName: "attitude_vibe_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_st2_1",
                    type: .multipleChoice,
                    prompt: "What does 'keff' mean?",
                    correctAnswer: "bad / lame",
                    options: ["good", "bad / lame", "police", "food"]
                )
            ],
            characterIDs: ["linh"]
        ),
        
        // --- SMS MODULE LESSONS ---
        Lesson(
            id: "sms_basics",
            moduleID: "sms_social",
            title: "SMS Shorthand",
            estimatedMinutes: 8,
            vocabItems: [dd, vdg],
            culturalContextCard: CulturalContextCard(
                bodyText: "Swedes love to shorten words in texts. Shorthands like 'dd' and 'vdg' are used constantly in casual chats.",
                illustrationName: "sms_chat_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_sms1_1",
                    type: .multipleChoice,
                    prompt: "What does 'vdg' mean?",
                    correctAnswer: "what are you doing",
                    options: ["where are you", "what are you doing", "who is that", "maybe"]
                )
            ],
            characterIDs: ["maja"]
        ),
        Lesson(
            id: "sms_reactions",
            moduleID: "sms_social",
            title: "Fast Reactions",
            estimatedMinutes: 8,
            vocabItems: [iaf, ksk, oxa],
            culturalContextCard: CulturalContextCard(
                bodyText: "Abbreviations like 'iaf' and 'ksk' help Swedes type fast when giving quick confirmations or expressing uncertainty.",
                illustrationName: "sms_reactions_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_sms2_1",
                    type: .multipleChoice,
                    prompt: "What does 'ksk' mean?",
                    correctAnswer: "maybe",
                    options: ["kissekatt", "maybe", "anyway", "also"]
                )
            ],
            characterIDs: ["erik"]
        ),
        
        // --- SOCIAL MODULE LESSONS ---
        Lesson(
            id: "social_drinking",
            moduleID: "socialt_bar",
            title: "Toasting & Beers",
            estimatedMinutes: 10,
            vocabItems: [bira, skal, kroka],
            culturalContextCard: CulturalContextCard(
                bodyText: "Going out for a 'bira' is a staple of Swedish social life, especially during After Work (AW) sessions.",
                illustrationName: "bar_toasting_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_soc1_1",
                    type: .multipleChoice,
                    prompt: "What is a 'bira'?",
                    correctAnswer: "beer",
                    options: ["wine", "beer", "soda", "coffee"]
                )
            ],
            characterIDs: ["erik"]
        ),
        Lesson(
            id: "social_vibe",
            moduleID: "socialt_bar",
            title: "Good Vibes",
            estimatedMinutes: 10,
            vocabItems: [chilla, taggad],
            culturalContextCard: CulturalContextCard(
                bodyText: "Swedes value a relaxed mood. Saying you want to 'chilla' is very common, as is being 'taggad' for an event.",
                illustrationName: "social_vibe_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_soc2_1",
                    type: .multipleChoice,
                    prompt: "What does 'taggad' mean?",
                    correctAnswer: "hyped / pumped",
                    options: ["tired", "hyped / pumped", "angry", "drunk"]
                )
            ],
            characterIDs: ["linh"]
        ),
        
        // --- DATING MODULE LESSONS ---
        Lesson(
            id: "dating_crush",
            moduleID: "dating",
            title: "Flirting & Crushes",
            estimatedMinutes: 12,
            vocabItems: [ragg, haffa],
            culturalContextCard: CulturalContextCard(
                bodyText: "Dating culture in Sweden is quite casual. 'Haffa' is street slang for catching/hooking up with someone you like.",
                illustrationName: "dating_crush_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_dat1_1",
                    type: .multipleChoice,
                    prompt: "What does 'haffa' mean?",
                    correctAnswer: "to catch / hook up with",
                    options: ["to run", "to catch / hook up with", "to reject", "to dump"]
                )
            ],
            characterIDs: ["maja"]
        ),
        Lesson(
            id: "dating_drama",
            moduleID: "dating",
            title: "Relationship Drama",
            estimatedMinutes: 12,
            vocabItems: [strula, dumpa],
            culturalContextCard: CulturalContextCard(
                bodyText: "Swedish relationships sometimes go through 'strul' (complications). Breaking up is colloquially called being 'dumpad'.",
                illustrationName: "relationship_drama_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_dat2_1",
                    type: .multipleChoice,
                    prompt: "What does 'dumpa' mean?",
                    correctAnswer: "to dump",
                    options: ["to marry", "to kiss", "to dump", "to hug"]
                )
            ],
            characterIDs: ["linh"]
        ),
        
        // --- SWEARS MODULE LESSONS ---
        Lesson(
            id: "swears_mild",
            moduleID: "svordomar",
            title: "Common Swears",
            estimatedMinutes: 10,
            vocabItems: [fan, javlar],
            culturalContextCard: CulturalContextCard(
                bodyText: "Swedish curse words are often religious in origin (devils, hell) rather than anatomical. They are used frequently for emphasis.",
                illustrationName: "mild_swears_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_sw1_1",
                    type: .multipleChoice,
                    prompt: "Which is the most common Swedish swear?",
                    correctAnswer: "fan",
                    options: ["fika", "fan", "sprint", "bre"]
                )
            ],
            characterIDs: ["erik"]
        ),
        Lesson(
            id: "swears_spicy",
            moduleID: "svordomar",
            title: "Expressing Frustration",
            estimatedMinutes: 10,
            vocabItems: [helvete],
            culturalContextCard: CulturalContextCard(
                bodyText: "Saying 'helvete' (hell) is a stronger way to express anger or frustration when things go wrong.",
                illustrationName: "spicy_swears_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_sw2_1",
                    type: .multipleChoice,
                    prompt: "What does 'helvete' mean?",
                    correctAnswer: "hell",
                    options: ["heaven", "hell", "crap", "bro"]
                )
            ],
            characterIDs: ["karin"]
        ),
        
        // --- NEW LESSONS ---
        Lesson(
            id: "street_lifestyle",
            moduleID: "gatanssprak",
            title: "Suburban Lifestyle",
            estimatedMinutes: 12,
            vocabItems: [para, shurda, ortens, lax, kanin, jalla, abo],
            culturalContextCard: CulturalContextCard(
                bodyText: "Suburban youth culture centers around hanging out in the local square, sharing stories, eating 'ortens' food, and hustling. Slang terms like 'para' (money), 'shurda' (guy), and 'jalla' (hurry up) are ubiquitous.",
                illustrationName: "street_lifestyle_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_st3_1",
                    type: .multipleChoice,
                    prompt: "What is 'para'?",
                    correctAnswer: "money",
                    options: ["money", "friend", "police", "food"]
                ),
                Exercise(
                    id: "ex_st3_2",
                    type: .multipleChoice,
                    prompt: "What is a 'shurda'?",
                    correctAnswer: "guy / dude",
                    options: ["girl", "police", "guy / dude", "house"]
                ),
                Exercise(
                    id: "ex_st3_3",
                    type: .multipleChoice,
                    prompt: "What does 'jalla' mean?",
                    correctAnswer: "hurry up / come on",
                    options: ["stop", "hurry up / come on", "sleep", "eat"]
                )
            ],
            characterIDs: ["linh", "erik"]
        ),
        Lesson(
            id: "sms_plans",
            moduleID: "sms_social",
            title: "Making Plans",
            estimatedMinutes: 10,
            vocabItems: [cs, vgd, idg, imr, dsm, ftg],
            culturalContextCard: CulturalContextCard(
                bodyText: "Making quick plans via text is all about efficiency. Using short codes like 'cs' (see you) and 'idg' (today) is standard etiquette.",
                illustrationName: "sms_plans_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_sms3_1",
                    type: .multipleChoice,
                    prompt: "What does 'cs' mean in a text?",
                    correctAnswer: "see you / see each other",
                    options: ["computer science", "see you / see each other", "call soon", "please"]
                ),
                Exercise(
                    id: "ex_sms3_2",
                    type: .multipleChoice,
                    prompt: "What does 'imr' stand for?",
                    correctAnswer: "tomorrow",
                    options: ["today", "tomorrow", "now", "never"]
                ),
                Exercise(
                    id: "ex_sms3_3",
                    type: .multipleChoice,
                    prompt: "What does 'dsm' mean?",
                    correctAnswer: "likewise / same to you",
                    options: ["don't see me", "likewise / same to you", "maybe", "no thanks"]
                )
            ],
            characterIDs: ["maja", "linh"]
        ),
        Lesson(
            id: "social_food",
            moduleID: "socialt_bar",
            title: "Late Night Cravings",
            estimatedMinutes: 10,
            vocabItems: [krubb, fyllekak, kaka, sugen],
            culturalContextCard: CulturalContextCard(
                bodyText: "Food is a massive part of Swedish socializing. Whether you crave a coffee break ('fika') or need some greasy 'fyllekäk' (drunk food) after a night out, these terms are vital.",
                illustrationName: "social_food_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_soc3_1",
                    type: .multipleChoice,
                    prompt: "What is 'krubb'?",
                    correctAnswer: "food / grub",
                    options: ["drink", "food / grub", "money", "sleep"]
                ),
                Exercise(
                    id: "ex_soc3_2",
                    type: .multipleChoice,
                    prompt: "What does 'fyllekäk' mean?",
                    correctAnswer: "drunk food",
                    options: ["breakfast", "drunk food", "desert", "lunch"]
                ),
                Exercise(
                    id: "ex_soc3_3",
                    type: .multipleChoice,
                    prompt: "What does 'sugen' mean?",
                    correctAnswer: "craving / in the mood for",
                    options: ["full", "craving / in the mood for", "angry", "tired"]
                )
            ],
            characterIDs: ["erik", "maja"]
        ),
        Lesson(
            id: "dating_future",
            moduleID: "dating",
            title: "Future & Commitments",
            estimatedMinutes: 12,
            vocabItems: [ex, sambo, singel, ghosta],
            culturalContextCard: CulturalContextCard(
                bodyText: "Swedes are famous for relationship cohabitation. The word 'sambo' is a legally defined relationship status for couples living together.",
                illustrationName: "dating_future_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_dat3_1",
                    type: .multipleChoice,
                    prompt: "What is a 'sambo'?",
                    correctAnswer: "cohabitating partner",
                    options: ["friend", "cohabitating partner", "ex", "boss"]
                ),
                Exercise(
                    id: "ex_dat3_2",
                    type: .multipleChoice,
                    prompt: "What is 'ghosta'?",
                    correctAnswer: "to ghost (suddenly stop replying)",
                    options: ["to call", "to ghost (suddenly stop replying)", "to hug", "to match"]
                )
            ],
            characterIDs: ["linh", "maja"]
        ),
        Lesson(
            id: "swears_insults",
            moduleID: "svordomar",
            title: "Expressing Frustration & Insults",
            estimatedMinutes: 10,
            vocabItems: [skit, skitstovel, satan],
            culturalContextCard: CulturalContextCard(
                bodyText: "Swedish insults can range from classic terms like 'skitstövel' (asshole) to religious swearing. Use them with care!",
                illustrationName: "swears_insults_illustration"
            ),
            dialogues: [],
            exercises: [
                Exercise(
                    id: "ex_sw3_1",
                    type: .multipleChoice,
                    prompt: "What does 'skitstövel' literally translate to?",
                    correctAnswer: "shit-boot",
                    options: ["shit-shoe", "shit-boot", "mud-box", "asshole"]
                ),
                Exercise(
                    id: "ex_sw3_2",
                    type: .multipleChoice,
                    prompt: "What does 'skit' mean?",
                    correctAnswer: "crap / shit",
                    options: ["good", "crap / shit", "fun", "crazy"]
                )
            ],
            characterIDs: ["erik", "karin"]
        ),
        
        // --- ORDERING MODULE LESSONS ---
        Lesson(id: "ordering_restaurant", moduleID: "bestallning", title: "At the Restaurant", estimatedMinutes: 12,
               vocabItems: [v_bestalla2, v_notan, v_meny, v_tamed, v_atahar, v_bord, v_servitor],
               culturalContextCard: CulturalContextCard(bodyText: "In Sweden, tipping is not expected but appreciated. You ask for 'notan' when ready to pay. 'Swisha' is the most common payment method.", illustrationName: "restaurant_illustration"),
               dialogues: [], exercises: [
                Exercise(id: "ex_ord1_1", type: .multipleChoice, prompt: "How do you ask for the bill?", correctAnswer: "Kan jag få notan?", options: ["Kan jag få notan?", "Var är menyn?", "Jag vill beställa.", "Tack så mycket."]),
                Exercise(id: "ex_ord1_2", type: .multipleChoice, prompt: "What does 'ta med' mean?", correctAnswer: "takeaway", options: ["eat here", "takeaway", "pay", "order"])
               ], characterIDs: ["maja"]),
        Lesson(id: "ordering_shopping", moduleID: "bestallning", title: "At the Store", estimatedMinutes: 10,
               vocabItems: [v_kassa, v_pase, v_rea, v_prova, v_storlek, v_billigt, v_dyrt],
               culturalContextCard: CulturalContextCard(bodyText: "Swedish stores charge for bags (påsar). Sales are called 'rea' and happen especially after Christmas and in summer.", illustrationName: "shopping_illustration"),
               dialogues: [], exercises: [
                Exercise(id: "ex_ord2_1", type: .multipleChoice, prompt: "What is 'rea'?", correctAnswer: "sale/discount", options: ["receipt", "sale/discount", "bag", "size"]),
                Exercise(id: "ex_ord2_2", type: .multipleChoice, prompt: "What does 'dyrt' mean?", correctAnswer: "expensive", options: ["cheap", "expensive", "free", "new"])
               ], characterIDs: ["erik"]),
        Lesson(id: "ordering_delivery", moduleID: "bestallning", title: "Services & Delivery", estimatedMinutes: 10,
               vocabItems: [v_kvitto, v_kort, v_kontant, v_swish, v_leverans, v_dricks],
               culturalContextCard: CulturalContextCard(bodyText: "Swish is Sweden's mobile payment app used by nearly everyone. Cash is increasingly rare — many shops are 'kontantfritt' (cashless).", illustrationName: "delivery_illustration"),
               dialogues: [], exercises: [
                Exercise(id: "ex_ord3_1", type: .multipleChoice, prompt: "What is 'swisha'?", correctAnswer: "to pay via mobile app", options: ["to call", "to pay via mobile app", "to text", "to order"]),
                Exercise(id: "ex_ord3_2", type: .multipleChoice, prompt: "What does 'kontant' mean?", correctAnswer: "cash", options: ["card", "cash", "free", "receipt"])
               ], characterIDs: ["maja"]),

        // --- EVERYDAY MODULE LESSONS ---
        Lesson(id: "everyday_numbers", moduleID: "vardagen", title: "Numbers & Time", estimatedMinutes: 15,
               vocabItems: [v_en2, v_tva, v_tre, v_fyra, v_fem, v_sex, v_sju, v_atta2, v_nio, v_tio, v_hundra, v_tusen, v_idag, v_igår, v_imorgon, v_klockan,
                            v_mandag, v_tisdag, v_onsdag, v_torsdag, v_fredag, v_lordag, v_sondag],
               culturalContextCard: CulturalContextCard(bodyText: "Swedes use a 24-hour clock. 'Klockan 15' means 3 PM. Days of the week are NOT capitalized in Swedish.", illustrationName: "numbers_illustration"),
               dialogues: [], exercises: [
                Exercise(id: "ex_ev1_1", type: .multipleChoice, prompt: "What is 'åtta'?", correctAnswer: "eight", options: ["six", "seven", "eight", "nine"]),
                Exercise(id: "ex_ev1_2", type: .multipleChoice, prompt: "What day is 'fredag'?", correctAnswer: "Friday", options: ["Monday", "Wednesday", "Friday", "Sunday"])
               ], characterIDs: ["maja"]),
        Lesson(id: "everyday_food", moduleID: "vardagen", title: "Food & Drinks", estimatedMinutes: 12,
               vocabItems: [v_kaffe, v_te, v_vatten, v_brod, v_ost, v_kott, v_fisk, v_gront, v_frukt, v_glass, v_godis, v_mat,
                            v_sol, v_regn, v_sno, v_kallt, v_varmt, v_vader],
               culturalContextCard: CulturalContextCard(bodyText: "Fika culture revolves around coffee. 'Lördagsgodis' (Saturday candy) is a tradition where children eat sweets only on Saturdays.", illustrationName: "food_illustration"),
               dialogues: [], exercises: [
                Exercise(id: "ex_ev2_1", type: .multipleChoice, prompt: "What is 'bröd'?", correctAnswer: "bread", options: ["butter", "bread", "cheese", "milk"]),
                Exercise(id: "ex_ev2_2", type: .multipleChoice, prompt: "What does 'snö' mean?", correctAnswer: "snow", options: ["sun", "rain", "snow", "wind"])
               ], characterIDs: ["erik"]),
        Lesson(id: "everyday_getting_around", moduleID: "vardagen", title: "Getting Around", estimatedMinutes: 12,
               vocabItems: [v_hoger, v_vanster, v_rakt, v_buss, v_tag, v_tunnelbana, v_bil, v_cykel, v_hallplats, v_flygplats,
                            v_rod, v_bla, v_gron, v_gul, v_vit, v_svart],
               culturalContextCard: CulturalContextCard(bodyText: "Stockholm's public transport (SL) uses zones. Buy an SL card or use the SL app. The tunnelbana has beautiful art stations.", illustrationName: "transport_illustration"),
               dialogues: [], exercises: [
                Exercise(id: "ex_ev3_1", type: .multipleChoice, prompt: "What is 'tunnelbana'?", correctAnswer: "subway/metro", options: ["bus", "train", "subway/metro", "taxi"]),
                Exercise(id: "ex_ev3_2", type: .multipleChoice, prompt: "What color is 'blå'?", correctAnswer: "blue", options: ["red", "green", "blue", "yellow"])
               ], characterIDs: ["linh"]),
        Lesson(id: "everyday_people", moduleID: "vardagen", title: "People & Essentials", estimatedMinutes: 15,
               vocabItems: [v_mamma, v_pappa, v_barn, v_kompis, v_familj, v_flickvan, v_pojkvan, v_granne,
                            v_bra, v_daligt, v_stor, v_liten, v_snabb, v_langsam, v_ny, v_gammal,
                            v_tack, v_ursakt, v_hej, v_hejda, v_ja, v_nej, v_kanske,
                            v_var, v_hur, v_nar, v_hem, v_skola, v_sjukhus, v_apotek],
               culturalContextCard: CulturalContextCard(bodyText: "Swedish culture values 'lagom' — not too much, not too little. Greetings are casual: 'hej' works everywhere, 'hejdå' for goodbye.", illustrationName: "people_illustration"),
               dialogues: [], exercises: [
                Exercise(id: "ex_ev4_1", type: .multipleChoice, prompt: "What does 'kompis' mean?", correctAnswer: "friend/buddy", options: ["colleague", "friend/buddy", "neighbor", "boss"]),
                Exercise(id: "ex_ev4_2", type: .multipleChoice, prompt: "How do you say 'thank you'?", correctAnswer: "tack", options: ["hej", "tack", "ja", "nej"]),
                Exercise(id: "ex_ev4_3", type: .fillBlank, prompt: "Hej, ___ mår du?", correctAnswer: "hur", options: ["var", "hur", "när", "vad"])
               ], characterIDs: ["maja", "erik"])
    ]
    
    // MARK: - Boss Levels
    public static let bossArbeteTech = BossLevel(
        id: "boss_arbete_tech",
        moduleID: "arbete_tech",
        rounds: [
            BossRound(number: 1, type: .speedRecognition, itemCount: 10, timePerItemSeconds: 3.0),
            BossRound(number: 2, type: .sentenceReconstruction, itemCount: 5, timePerItemSeconds: 20.0),
            BossRound(number: 3, type: .scenario, itemCount: 6, timePerItemSeconds: 15.0),
            BossRound(number: 4, type: .errorHunter, itemCount: 5, timePerItemSeconds: 20.0),
            BossRound(number: 5, type: .translationSprint, itemCount: 6, timePerItemSeconds: 12.0)
        ],
        passThreshold: 0.8,
        partialThreshold: 0.6
    )
    
    public static let bossGatansSprak = BossLevel(
        id: "boss_gatanssprak",
        moduleID: "gatanssprak",
        rounds: [
            BossRound(number: 1, type: .speedRecognition, itemCount: 6, timePerItemSeconds: 3.0),
            BossRound(number: 2, type: .translationSprint, itemCount: 4, timePerItemSeconds: 12.0)
        ],
        passThreshold: 0.8,
        partialThreshold: 0.6
    )
    
    public static let bossSmsSocial = BossLevel(
        id: "boss_sms_social",
        moduleID: "sms_social",
        rounds: [
            BossRound(number: 1, type: .speedRecognition, itemCount: 6, timePerItemSeconds: 3.0),
            BossRound(number: 2, type: .translationSprint, itemCount: 4, timePerItemSeconds: 12.0)
        ],
        passThreshold: 0.8,
        partialThreshold: 0.6
    )

    public static let bossSocialtBar = BossLevel(
        id: "boss_socialt_bar",
        moduleID: "socialt_bar",
        rounds: [
            BossRound(number: 1, type: .speedRecognition, itemCount: 6, timePerItemSeconds: 3.0),
            BossRound(number: 2, type: .translationSprint, itemCount: 4, timePerItemSeconds: 12.0)
        ],
        passThreshold: 0.8,
        partialThreshold: 0.6
    )

    public static let bossDating = BossLevel(
        id: "boss_dating",
        moduleID: "dating",
        rounds: [
            BossRound(number: 1, type: .speedRecognition, itemCount: 6, timePerItemSeconds: 3.0),
            BossRound(number: 2, type: .translationSprint, itemCount: 4, timePerItemSeconds: 12.0)
        ],
        passThreshold: 0.8,
        partialThreshold: 0.6
    )

    public static let bossSvordomar = BossLevel(
        id: "boss_svordomar",
        moduleID: "svordomar",
        rounds: [
            BossRound(number: 1, type: .speedRecognition, itemCount: 6, timePerItemSeconds: 3.0),
            BossRound(number: 2, type: .translationSprint, itemCount: 4, timePerItemSeconds: 12.0)
        ],
        passThreshold: 0.8,
        partialThreshold: 0.6
    )
    
    public static let bossBestallning = BossLevel(
        id: "boss_bestallning",
        moduleID: "bestallning",
        rounds: [
            BossRound(number: 1, type: .speedRecognition, itemCount: 6, timePerItemSeconds: 3.0),
            BossRound(number: 2, type: .translationSprint, itemCount: 4, timePerItemSeconds: 12.0)
        ],
        passThreshold: 0.8,
        partialThreshold: 0.6
    )

    public static let bossVardagen = BossLevel(
        id: "boss_vardagen",
        moduleID: "vardagen",
        rounds: [
            BossRound(number: 1, type: .speedRecognition, itemCount: 10, timePerItemSeconds: 3.0),
            BossRound(number: 2, type: .translationSprint, itemCount: 6, timePerItemSeconds: 12.0)
        ],
        passThreshold: 0.8,
        partialThreshold: 0.6
    )
    
    public static let allBossLevels: [BossLevel] = [
        bossArbeteTech,
        bossGatansSprak,
        bossSmsSocial,
        bossSocialtBar,
        bossDating,
        bossSvordomar,
        bossBestallning,
        bossVardagen
    ]
    
    // MARK: - Helper getters
    public static func getLesson(byID id: String) -> Lesson? {
        return allLessons.first { $0.id == id }
    }
    
    public static func getModule(byID id: String) -> Module? {
        return allModules.first { $0.id == id }
    }
}
