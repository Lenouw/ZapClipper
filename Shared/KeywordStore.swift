import Foundation
import AppKit

struct KeywordData: Codable {
    var french: [String]
    var english: [String]
}

class KeywordStore {

    static let shared = KeywordStore()

    private let suiteName = "TQVHUV8MZY.com.zapclipper.app"
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

    // MARK: - Export / Import

    /// Exporte les mots-cles dans un fichier JSON via NSSavePanel
    func exportKeywords() -> Bool {
        let data = load()
        let panel = NSSavePanel()
        panel.title = "Exporter les mots-cles"
        panel.nameFieldStringValue = "ZapClipper-keywords.json"
        panel.allowedContentTypes = [.json]
        panel.canCreateDirectories = true

        guard panel.runModal() == .OK, let url = panel.url else { return false }

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: url)
            return true
        } catch {
            return false
        }
    }

    /// Importe les mots-cles depuis un fichier JSON via NSOpenPanel
    func importKeywords() -> KeywordData? {
        let panel = NSOpenPanel()
        panel.title = "Importer des mots-cles"
        panel.allowedContentTypes = [.json]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        guard panel.runModal() == .OK, let url = panel.url else { return nil }

        do {
            let jsonData = try Data(contentsOf: url)
            let imported = try JSONDecoder().decode(KeywordData.self, from: jsonData)
            save(imported)
            return imported
        } catch {
            return nil
        }
    }
}
