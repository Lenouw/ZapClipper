import Foundation

struct KeywordData: Codable {
    var french: [String]
    var english: [String]
}

class KeywordStore {

    static let shared = KeywordStore()

    private let suiteName = "TQVHUV8MZY.com.florianbonin.ZapClipper"
    private let key = "customKeywords"

    static let defaultFrench: [String] = [
        "ci-joint",
        "ci-jointe",
        "ci-joints",
        "ci-jointes",
        "pièce jointe",
        "pièces jointes",
        "piece jointe",
        "pieces jointes",
        "en annexe",
        "fichier joint",
        "fichier ci-joint",
        "document joint",
        "document ci-joint",
        "je joins",
        "je vous joins",
        "vous trouverez ci-joint",
        "veuillez trouver",
        "j'attache",
        "j'ai attaché",
        "j'ai attache",
        "je vous envoie le fichier",
        "je vous envoie le document",
        "je t'envoie le fichier",
        "je t'envoie le document",
        "vous trouverez en pièce jointe",
        "tu trouveras ci-joint",
        "tu trouveras en pièce jointe",
        "voir pièce jointe",
        "voir le fichier joint",
        "cf. pièce jointe",
        "voici le ",
        "voici la ",
        "voici les ",
        "facture",
        "factures",
        "PJ",
    ]

    static let defaultEnglish: [String] = [
        "attached",
        "attachment",
        "find attached",
        "see attached",
        "see the attached",
        "please find attached",
        "enclosed",
        "find enclosed",
        "i'm attaching",
        "i am attaching",
        "i've attached",
        "i have attached",
        "attaching the",
        "see the attachment",
        "attached file",
        "attached document",
        "invoice",
        "invoices",
        "here is the",
    ]

    func load() -> KeywordData {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let data = defaults.data(forKey: key),
              let keywords = try? JSONDecoder().decode(KeywordData.self, from: data) else {
            return KeywordData(french: Self.defaultFrench, english: Self.defaultEnglish)
        }
        return keywords
    }

    func save(_ keywords: KeywordData) {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let data = try? JSONEncoder().encode(keywords) else { return }
        defaults.set(data, forKey: key)
    }

    func resetToDefaults() {
        save(KeywordData(french: Self.defaultFrench, english: Self.defaultEnglish))
    }
}
