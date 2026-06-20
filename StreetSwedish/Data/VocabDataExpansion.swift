import Foundation

// Compact vocab helper
extension LessonData {
    static func q(_ id: String, _ sv: String, _ en: String, _ pron: String, _ exSv: String, _ exEn: String, _ hook: String, _ reg: RegisterLevel, _ grammarNote: String? = nil) -> VocabItem {
        VocabItem(id: id, swedish: sv, english: en, pronunciation: pron,
                  exampleSentences: [ExampleSentence(swedish: exSv, english: exEn, registerLabel: reg)],
                  soundHook: hook, visualHook: "", cultureHook: "", registerLabel: reg, grammarNote: grammarNote)
    }

    // MARK: - Ordering & Shopping Vocab
    static let v_bestalla2 = q("vocab_bestalla", "beställa", "to order", "beh-stel-ah", "Jag vill beställa mat.", "I want to order food.", "bestell", .neutral)
    static let v_notan = q("vocab_notan", "notan", "the bill/check", "noo-tan", "Kan jag få notan?", "Can I get the bill?", "note-an", .neutral, "N-noun (en nota). Definite singular form. Plural: notorna.")
    static let v_meny = q("vocab_meny", "meny", "menu", "meh-ny", "Kan jag se menyn?", "Can I see the menu?", "menu", .neutral)
    static let v_tamed = q("vocab_tamed", "ta med", "takeaway", "tah med", "Jag vill ta med.", "I want takeaway.", "take-med", .neutral)
    static let v_atahar = q("vocab_atahar", "äta här", "eat here", "eh-tah hair", "Vi vill äta här.", "We want to eat here.", "eat-here", .neutral)
    static let v_bord = q("vocab_bord", "bord", "table", "boord", "Ett bord för två, tack.", "A table for two, please.", "board", .neutral)
    static let v_servitor = q("vocab_servitor", "servitör", "waiter", "ser-vi-tur", "Ursäkta, servitör!", "Excuse me, waiter!", "server", .neutral)
    static let v_dricks = q("vocab_dricks", "dricks", "tip", "dricks", "Dricks ingår inte.", "Tip is not included.", "drinks", .neutral)
    static let v_kvitto = q("vocab_kvitto", "kvitto", "receipt", "kvit-oh", "Kan jag få kvittot?", "Can I get the receipt?", "quit-oh", .neutral, "T-noun (ett kvitto). Indefinite singular. Plural: kvitton. Definite: kvittot.")
    static let v_kassa = q("vocab_kassa", "kassa", "checkout/register", "kas-ah", "Betala i kassan.", "Pay at the register.", "casa", .neutral)
    static let v_pase = q("vocab_pase", "påse", "bag", "paw-seh", "Vill du ha en påse?", "Do you want a bag?", "posse", .neutral)
    static let v_rea = q("vocab_rea", "rea", "sale/discount", "reh-ah", "Det är rea på ICA.", "There is a sale at ICA.", "ray-ah", .informal)
    static let v_prova = q("vocab_prova", "prova", "to try on", "proo-vah", "Kan jag prova den?", "Can I try it on?", "prove", .neutral)
    static let v_storlek = q("vocab_storlek", "storlek", "size", "stohr-lek", "Vilken storlek?", "What size?", "store-lake", .neutral)
    static let v_billigt = q("vocab_billigt", "billigt", "cheap", "bill-igt", "Det var billigt!", "That was cheap!", "bill", .neutral)
    static let v_dyrt = q("vocab_dyrt", "dyrt", "expensive", "deert", "Stockholm är dyrt.", "Stockholm is expensive.", "dirt", .neutral)
    static let v_kort = q("vocab_kort", "kort", "card (payment)", "koort", "Jag betalar med kort.", "I pay by card.", "court", .neutral)
    static let v_kontant = q("vocab_kontant", "kontant", "cash", "kon-tant", "Tar ni kontant?", "Do you take cash?", "contact", .neutral)
    static let v_swish = q("vocab_swish", "swisha", "to Swish (mobile pay)", "swish-ah", "Kan jag swisha?", "Can I Swish?", "swish", .informal)
    static let v_leverans = q("vocab_leverans", "leverans", "delivery", "leh-ver-ans", "Fri leverans över 500 kr.", "Free delivery over 500 kr.", "lever-ants", .neutral)

    // MARK: - Everyday Essentials Vocab
    // Numbers & Time
    static let v_en2 = q("vocab_en2", "en/ett", "one", "ehn/et", "En kaffe, tack.", "One coffee, please.", "en", .neutral)
    static let v_tva = q("vocab_tva", "två", "two", "tvaw", "Två biljetter.", "Two tickets.", "tvor", .neutral)
    static let v_tre = q("vocab_tre", "tre", "three", "treh", "Tre gånger om dagen.", "Three times a day.", "tray", .neutral)
    static let v_fyra = q("vocab_fyra", "fyra", "four", "few-rah", "Klockan fyra.", "At four o'clock.", "fear-ah", .neutral)
    static let v_fem = q("vocab_fem", "fem", "five", "fem", "Fem minuter.", "Five minutes.", "fem", .neutral)
    static let v_sex = q("vocab_sex", "sex", "six", "sex", "Sex kronor.", "Six crowns.", "sex", .neutral)
    static let v_sju = q("vocab_sju", "sju", "seven", "shew", "Klockan sju.", "At seven.", "shoe", .neutral)
    static let v_atta2 = q("vocab_atta2", "åtta", "eight", "ot-ah", "Åtta timmar.", "Eight hours.", "otter", .neutral)
    static let v_nio = q("vocab_nio", "nio", "nine", "nee-oh", "Nio av tio.", "Nine out of ten.", "knee-oh", .neutral)
    static let v_tio = q("vocab_tio", "tio", "ten", "tee-oh", "Tio kronor.", "Ten crowns.", "tea-oh", .neutral)
    static let v_hundra = q("vocab_hundra", "hundra", "hundred", "hun-drah", "Hundra procent.", "One hundred percent.", "hound-ra", .neutral)
    static let v_tusen = q("vocab_tusen", "tusen", "thousand", "too-sen", "Tusen tack!", "Thanks a lot!", "two-sen", .neutral)
    static let v_idag = q("vocab_idag", "idag", "today", "ee-dahg", "Vad gör vi idag?", "What do we do today?", "e-dog", .neutral)
    static let v_igår = q("vocab_igar", "igår", "yesterday", "ee-gawr", "Igår regnade det.", "Yesterday it rained.", "e-gore", .neutral)
    static let v_imorgon = q("vocab_imorgon", "imorgon", "tomorrow", "ee-mor-on", "Vi ses imorgon.", "See you tomorrow.", "e-morning", .neutral)
    static let v_klockan = q("vocab_klockan", "klockan", "the time/o'clock", "klock-an", "Klockan är tre.", "It is three o'clock.", "clock-an", .neutral)
    // Days
    static let v_mandag = q("vocab_mandag", "måndag", "Monday", "mawn-dahg", "Måndag är jobbig.", "Monday is tough.", "moon-dog", .neutral)
    static let v_tisdag = q("vocab_tisdag", "tisdag", "Tuesday", "tees-dahg", "Vi ses på tisdag.", "See you Tuesday.", "tease-dog", .neutral)
    static let v_onsdag = q("vocab_onsdag", "onsdag", "Wednesday", "oons-dahg", "Onsdag mitt i veckan.", "Wednesday middle of the week.", "ones-dog", .neutral)
    static let v_torsdag = q("vocab_torsdag", "torsdag", "Thursday", "toors-dahg", "Torsdag är AW-dag.", "Thursday is After Work day.", "tours-dog", .neutral)
    static let v_fredag = q("vocab_fredag", "fredag", "Friday", "freh-dahg", "Äntligen fredag!", "Finally Friday!", "fray-dog", .neutral)
    static let v_lordag = q("vocab_lordag", "lördag", "Saturday", "lur-dahg", "Lördag är städdag.", "Saturday is cleaning day.", "lure-dog", .neutral)
    static let v_sondag = q("vocab_sondag", "söndag", "Sunday", "sun-dahg", "Söndag vilar vi.", "Sunday we rest.", "sun-dog", .neutral)
    // Weather
    static let v_sol = q("vocab_sol", "sol", "sun", "sool", "Solen skiner!", "The sun is shining!", "soul", .neutral)
    static let v_regn = q("vocab_regn", "regn", "rain", "rehn", "Det är regn idag.", "It is rainy today.", "rain", .neutral)
    static let v_sno = q("vocab_sno", "snö", "snow", "snuh", "Det snöar ute.", "It is snowing outside.", "snow", .neutral)
    static let v_kallt = q("vocab_kallt", "kallt", "cold", "kalt", "Det är kallt idag.", "It is cold today.", "called", .neutral)
    static let v_varmt = q("vocab_varmt", "varmt", "warm/hot", "varmt", "Det är varmt ute.", "It is warm outside.", "warmed", .neutral)
    static let v_vader = q("vocab_vader", "väder", "weather", "veh-der", "Fint väder idag.", "Nice weather today.", "weather", .neutral)
    // Food & Drinks
    static let v_kaffe = q("vocab_kaffe", "kaffe", "coffee", "kaf-eh", "En kopp kaffe, tack.", "A cup of coffee, please.", "café", .neutral)
    static let v_te = q("vocab_te", "te", "tea", "teh", "Jag dricker te.", "I drink tea.", "tea", .neutral)
    static let v_vatten = q("vocab_vatten", "vatten", "water", "vat-en", "Ett glas vatten.", "A glass of water.", "vat-en", .neutral)
    static let v_brod = q("vocab_brod", "bröd", "bread", "bruhd", "Svenskt bröd är gott.", "Swedish bread is good.", "brewed", .neutral)
    static let v_ost = q("vocab_ost", "ost", "cheese", "oost", "Ost på mackan.", "Cheese on the sandwich.", "oost", .neutral)
    static let v_kott = q("vocab_kott", "kött", "meat", "shut", "Jag äter inte kött.", "I don't eat meat.", "shirt", .neutral)
    static let v_fisk = q("vocab_fisk", "fisk", "fish", "fisk", "Sverige har bra fisk.", "Sweden has good fish.", "fisk", .neutral)
    static let v_gront = q("vocab_gront", "grönsaker", "vegetables", "grun-sah-ker", "Ät dina grönsaker!", "Eat your vegetables!", "green-soccer", .neutral)
    static let v_frukt = q("vocab_frukt", "frukt", "fruit", "frookt", "Jag köper frukt.", "I buy fruit.", "fruit", .neutral)
    static let v_glass = q("vocab_glass", "glass", "ice cream", "glass", "Vi äter glass.", "We eat ice cream.", "glass", .neutral)
    static let v_godis = q("vocab_godis", "godis", "candy/sweets", "goo-dis", "Lördagsgodis!", "Saturday candy!", "good-is", .neutral)
    static let v_mat = q("vocab_mat", "mat", "food", "maht", "Maten är klar.", "The food is ready.", "mat", .neutral)
    // Directions & Transport
    static let v_hoger = q("vocab_hoger", "höger", "right", "huh-ger", "Sväng höger.", "Turn right.", "hunger", .neutral)
    static let v_vanster = q("vocab_vanster", "vänster", "left", "ven-ster", "Sväng vänster.", "Turn left.", "fenster", .neutral)
    static let v_rakt = q("vocab_rakt", "rakt fram", "straight ahead", "rakt frahm", "Gå rakt fram.", "Go straight ahead.", "wrecked from", .neutral)
    static let v_buss = q("vocab_buss", "buss", "bus", "boos", "Jag tar bussen.", "I take the bus.", "bus", .neutral)
    static let v_tag = q("vocab_tag", "tåg", "train", "tawg", "Tåget är försenat.", "The train is delayed.", "tug", .neutral)
    static let v_tunnelbana = q("vocab_tunnelbana", "tunnelbana", "subway/metro", "tun-el-bah-nah", "Ta tunnelbanan.", "Take the subway.", "tunnel-banana", .neutral)
    static let v_bil = q("vocab_bil", "bil", "car", "beel", "Jag kör bil.", "I drive a car.", "bill", .neutral)
    static let v_cykel = q("vocab_cykel", "cykel", "bicycle", "sy-kel", "Jag cyklar till jobbet.", "I cycle to work.", "cycle", .neutral)
    static let v_hallplats = q("vocab_hallplats", "hållplats", "bus stop", "hawl-plats", "Nästa hållplats.", "Next stop.", "hall-plots", .neutral)
    static let v_flygplats = q("vocab_flygplats", "flygplats", "airport", "flyg-plats", "Vi åker till flygplatsen.", "We go to the airport.", "fly-plots", .neutral)
    // Family & People
    static let v_mamma = q("vocab_mamma", "mamma", "mom", "mam-ah", "Min mamma lagar mat.", "My mom cooks.", "mama", .neutral)
    static let v_pappa = q("vocab_pappa", "pappa", "dad", "pap-ah", "Pappa jobbar hemma.", "Dad works from home.", "papa", .neutral)
    static let v_barn = q("vocab_barn", "barn", "child/children", "barn", "Barnen leker.", "The children are playing.", "barn", .neutral)
    static let v_kompis = q("vocab_kompis", "kompis", "friend/buddy", "komp-is", "Min bästa kompis.", "My best friend.", "compass", .informal)
    static let v_familj = q("vocab_familj", "familj", "family", "fah-milj", "Min familj bor i Malmö.", "My family lives in Malmö.", "family", .neutral)
    static let v_flickvan = q("vocab_flickvan", "flickvän", "girlfriend", "flick-ven", "Min flickvän heter Sara.", "My girlfriend's name is Sara.", "flick-van", .neutral)
    static let v_pojkvan = q("vocab_pojkvan", "pojkvän", "boyfriend", "poyk-ven", "Hennes pojkvän är svensk.", "Her boyfriend is Swedish.", "boy-van", .neutral)
    static let v_granne = q("vocab_granne", "granne", "neighbor", "gran-eh", "Min granne är trevlig.", "My neighbor is nice.", "granite", .neutral)
    // Colors
    static let v_rod = q("vocab_rod", "röd", "red", "ruhd", "En röd bil.", "A red car.", "rude", .neutral)
    static let v_bla = q("vocab_bla", "blå", "blue", "blaw", "Himlen är blå.", "The sky is blue.", "blah", .neutral)
    static let v_gron = q("vocab_gron", "grön", "green", "gruhn", "Grönt ljus.", "Green light.", "groan", .neutral)
    static let v_gul = q("vocab_gul", "gul", "yellow", "gool", "En gul blomma.", "A yellow flower.", "ghoul", .neutral)
    static let v_vit = q("vocab_vit", "vit", "white", "veet", "Vit snö.", "White snow.", "wheat", .neutral)
    static let v_svart = q("vocab_svart", "svart", "black", "svart", "Svart kaffe.", "Black coffee.", "start", .neutral)
    // Common adjectives & phrases
    static let v_bra = q("vocab_bra", "bra", "good", "brah", "Det är bra!", "It is good!", "bra", .neutral)
    static let v_daligt = q("vocab_daligt", "dåligt", "bad", "daw-lit", "Dåligt väder.", "Bad weather.", "doll-it", .neutral)
    static let v_stor = q("vocab_stor", "stor", "big", "stohr", "En stor stad.", "A big city.", "store", .neutral)
    static let v_liten = q("vocab_liten", "liten", "small", "lee-ten", "En liten katt.", "A small cat.", "lee-ten", .neutral)
    static let v_snabb = q("vocab_snabb", "snabb", "fast", "snab", "Tåget är snabbt.", "The train is fast.", "snap", .neutral)
    static let v_langsam = q("vocab_langsam", "långsam", "slow", "long-sam", "Bussen är långsam.", "The bus is slow.", "long-some", .neutral)
    static let v_ny = q("vocab_ny", "ny", "new", "new", "En ny mobil.", "A new phone.", "new", .neutral)
    static let v_gammal = q("vocab_gammal", "gammal", "old", "gam-al", "En gammal kyrka.", "An old church.", "gamble", .neutral)
    static let v_tack = q("vocab_tack", "tack", "thanks", "tack", "Tack så mycket!", "Thanks so much!", "tack", .neutral)
    static let v_ursakt = q("vocab_ursakt", "ursäkta", "excuse me/sorry", "ur-shek-tah", "Ursäkta mig.", "Excuse me.", "ur-shek-tah", .neutral)
    static let v_hej = q("vocab_hej", "hej", "hello", "hey", "Hej, hur mår du?", "Hello, how are you?", "hey", .neutral)
    static let v_hejda = q("vocab_hejda", "hejdå", "goodbye", "hey-daw", "Hejdå, vi ses!", "Goodbye, see you!", "hey-door", .neutral)
    static let v_ja = q("vocab_ja", "ja", "yes", "yah", "Ja, absolut!", "Yes, absolutely!", "yah", .neutral)
    static let v_nej = q("vocab_nej", "nej", "no", "ney", "Nej, tack.", "No, thanks.", "nay", .neutral)
    static let v_kanske = q("vocab_kansen", "kanske", "maybe", "kan-sheh", "Kanske imorgon.", "Maybe tomorrow.", "can-she", .neutral)
    static let v_var = q("vocab_var", "var", "where", "vahr", "Var är toaletten?", "Where is the toilet?", "var", .neutral)
    static let v_hur = q("vocab_hur", "hur", "how", "hoor", "Hur mår du?", "How are you?", "who-r", .neutral)
    static let v_nar = q("vocab_nar", "när", "when", "nair", "När börjar filmen?", "When does the movie start?", "near", .neutral)
    static let v_hem = q("vocab_hem", "hem", "home", "hem", "Jag går hem.", "I go home.", "hem", .neutral)
    static let v_skola = q("vocab_skola", "skola", "school", "skoo-lah", "Barnen går i skolan.", "The children go to school.", "school-ah", .neutral)
    static let v_sjukhus = q("vocab_sjukhus", "sjukhus", "hospital", "shewk-hoos", "Han är på sjukhuset.", "He is at the hospital.", "shook-house", .neutral)
    static let v_apotek = q("vocab_apotek", "apotek", "pharmacy", "ah-poo-tek", "Jag köper medicin på apoteket.", "I buy medicine at the pharmacy.", "ah-po-take", .neutral)

    // MARK: - Extra words for existing categories
    // Extra Work & Tech
    static let v_mail = q("vocab_mail", "mejla", "to email", "may-lah", "Mejla mig rapporten.", "Email me the report.", "mail-ah", .workplaceOK)
    static let v_deadline = q("vocab_deadline", "deadline", "deadline", "ded-line", "Vi har deadline på fredag.", "We have a deadline on Friday.", "deadline", .workplaceOK)
    static let v_lon = q("vocab_lon", "lön", "salary", "luhn", "Lönen kommer den 25:e.", "Salary comes on the 25th.", "loon", .neutral)
    static let v_chef = q("vocab_chef", "chef", "boss/manager", "shef", "Min chef är snäll.", "My boss is nice.", "chef", .neutral)
    static let v_semester = q("vocab_semester", "semester", "vacation", "seh-mes-ter", "Jag tar semester i juli.", "I take vacation in July.", "semester", .neutral)
    static let v_mote2 = q("vocab_mote2", "möte", "meeting", "muh-teh", "Vi har möte klockan tio.", "We have a meeting at ten.", "mute-eh", .workplaceOK)
    static let v_rapport = q("vocab_rapport", "rapport", "report", "rah-port", "Skicka rapporten.", "Send the report.", "rapport", .workplaceOK)
    static let v_kollega = q("vocab_kollega", "kollega", "colleague", "ko-leh-gah", "Min kollega hjälper mig.", "My colleague helps me.", "colleague", .neutral)
    // Extra Street
    static let v_snuten = q("vocab_snuten", "snuten", "cops (slang)", "snoo-ten", "Snuten är här.", "The cops are here.", "snoot-en", .slang)
    static let v_mannen = q("vocab_mannen", "mannen", "the man/dude", "man-en", "Mannen sa det.", "The man said it.", "man-en", .slang)
    static let v_fett = q("vocab_fett", "fett", "very/fat (intensifier)", "fet", "Det var fett bra.", "That was really good.", "fat", .slang)
    static let v_sicken = q("vocab_sicken", "sicken", "what a (excl.)", "sick-en", "Sicken tur!", "What luck!", "sick-en", .slang)
    static let v_bansen = q("vocab_bansen", "ba", "just/only", "bah", "Jag ba chilla.", "I'm just chilling.", "bah", .slang)
    // Extra Social
    static let v_forsta2 = q("vocab_forsta2", "förfest", "pre-party", "fur-fest", "Vi kör förfest hemma.", "We pre-game at home.", "fur-feast", .informal)
    static let v_bakfull = q("vocab_bakfull", "bakfull", "hungover", "bahk-ful", "Jag är bakfull.", "I am hungover.", "back-full", .informal)
    static let v_nachspiel = q("vocab_nachspiel", "nachspiel", "afterparty", "nahk-shpeel", "Nachspiel hos mig.", "Afterparty at my place.", "nock-spiel", .informal)
    // Extra Dating
    static let v_dejt = q("vocab_dejt", "dejt", "a date", "dayt", "Vi hade en dejt igår.", "We had a date yesterday.", "date", .neutral)
    static let v_krossa = q("vocab_krossa", "crush", "crush", "krush", "Jag har en crush.", "I have a crush.", "crush", .informal)
    static let v_relation = q("vocab_relation", "förhållande", "relationship", "fur-hawl-an-deh", "Vi är i ett förhållande.", "We are in a relationship.", "fur-hold", .neutral)
    // Extra Swears
    static let v_jansen = q("vocab_jansen", "jäklar", "darn/dammit", "yek-lar", "Jäklar också!", "Dammit!", "yak-lar", .vulgar)
    static let v_attans = q("vocab_attans", "attans", "darn (mild)", "at-ans", "Attans, jag glömde.", "Darn, I forgot.", "at-ans", .informal)
    static let v_herregud = q("vocab_herregud", "herregud", "oh my god", "hair-eh-good", "Herregud, vad fint!", "Oh my god, how beautiful!", "hairy-good", .neutral)

    // MARK: - Expansion Vocab Arrays
    static let orderingVocab: [VocabItem] = [
        v_bestalla2, v_notan, v_meny, v_tamed, v_atahar, v_bord, v_servitor, v_dricks,
        v_kvitto, v_kassa, v_pase, v_rea, v_prova, v_storlek, v_billigt, v_dyrt,
        v_kort, v_kontant, v_swish, v_leverans
    ]

    static let everydayVocab: [VocabItem] = [
        v_en2, v_tva, v_tre, v_fyra, v_fem, v_sex, v_sju, v_atta2, v_nio, v_tio,
        v_hundra, v_tusen, v_idag, v_igår, v_imorgon, v_klockan,
        v_mandag, v_tisdag, v_onsdag, v_torsdag, v_fredag, v_lordag, v_sondag,
        v_sol, v_regn, v_sno, v_kallt, v_varmt, v_vader,
        v_kaffe, v_te, v_vatten, v_brod, v_ost, v_kott, v_fisk, v_gront, v_frukt, v_glass, v_godis, v_mat,
        v_hoger, v_vanster, v_rakt, v_buss, v_tag, v_tunnelbana, v_bil, v_cykel, v_hallplats, v_flygplats,
        v_mamma, v_pappa, v_barn, v_kompis, v_familj, v_flickvan, v_pojkvan, v_granne,
        v_rod, v_bla, v_gron, v_gul, v_vit, v_svart,
        v_bra, v_daligt, v_stor, v_liten, v_snabb, v_langsam, v_ny, v_gammal,
        v_tack, v_ursakt, v_hej, v_hejda, v_ja, v_nej, v_kanske,
        v_var, v_hur, v_nar, v_hem, v_skola, v_sjukhus, v_apotek
    ]

    static let extraWorkVocab: [VocabItem] = [v_mail, v_deadline, v_lon, v_chef, v_semester, v_mote2, v_rapport, v_kollega]
    static let extraStreetVocab: [VocabItem] = [v_snuten, v_mannen, v_fett, v_sicken, v_bansen]
    static let extraSocialVocab: [VocabItem] = [v_forsta2, v_bakfull, v_nachspiel]
    static let extraDatingVocab: [VocabItem] = [v_dejt, v_krossa, v_relation]
    static let extraSwearsVocab: [VocabItem] = [v_jansen, v_attans, v_herregud]

    static let expansionVocab: [VocabItem] = orderingVocab + everydayVocab + extraWorkVocab + extraStreetVocab + extraSocialVocab + extraDatingVocab + extraSwearsVocab
}
