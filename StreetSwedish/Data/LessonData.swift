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
    
    public static let allVocabItems: [VocabItem] = [
        standup, sprint, pinga, vabba, sajna, prio, sittaIMote, taDetOffline,
        paDet, kingsMo, codeReview, fredagsmys, ASAP, kriga, spika, hojdare,
        fika, gnalla, skitaI, losa, sjukskrivaSig, flexa, overtid, AW
    ]
    
    // MARK: - Dialogues
    public static let techDialogues: [Dialogue] = [
        Dialogue(
            title: "Planeringsmöte (Planning Meeting)",
            lines: [
                DialogueLine(speakerID: "karin", swedish: "Maja, är alla feature-kort klara för nästa sprint?", english: "Maja, are all feature cards ready for the next sprint?"),
                DialogueLine(speakerID: "maja", swedish: "Nästan, jag sitter i möte med designern nu. Jag löser det ASAP.", english: "Almost, I'm sitting in a meeting with the designer now. I will solve it ASAP."),
                DialogueLine(speakerID: "karin", swedish: "Grymt. Pinga mig på Slack när du är klar så vi kan spika listan.", english: "Great. Ping me on Slack when you are done so we can nail down the list.")
            ],
            pullQuote: "Jag löser det ASAP. (I'll solve it ASAP.)"
        ),
        Dialogue(
            title: "Slack Drama",
            lines: [
                DialogueLine(speakerID: "maja", swedish: "Kan någon göra en code review på min pull request?", english: "Can someone do a code review on my pull request?"),
                DialogueLine(speakerID: "erik", swedish: "Jag är på det! Men jag måste vabba i eftermiddag, så jag kollar nu.", english: "I'm on it! But I have to care for my sick child this afternoon, so I'll check now."),
                DialogueLine(speakerID: "maja", swedish: "Tack Erik! Vi tar feedbacken offline sen.", english: "Thanks Erik! We will take the feedback offline later.")
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
            characterIDs: ["karin", "maja"]
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
        )
    ]
    
    // MARK: - Boss Level
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
    
    public static let allBossLevels: [BossLevel] = [bossArbeteTech]
    
    // MARK: - Helper getters
    public static func getLesson(byID id: String) -> Lesson? {
        return allLessons.first { $0.id == id }
    }
    
    public static func getModule(byID id: String) -> Module? {
        return allModules.first { $0.id == id }
    }
}
