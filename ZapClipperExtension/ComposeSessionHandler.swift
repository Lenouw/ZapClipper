import Foundation
import MailKit

class ComposeSessionHandler: NSObject, MEComposeSessionHandler {

    // MARK: - Lifecycle

    func mailComposeSessionDidBegin(_ session: MEComposeSession) {
        // Nothing to do when the compose window opens
    }

    func mailComposeSessionDidEnd(_ session: MEComposeSession) {
        // Nothing to do when the compose window closes
    }

    func viewController(for session: MEComposeSession) -> MEExtensionViewController {
        return MEExtensionViewController()
    }

    // MARK: - Send validation

    func allowMessageSendForSession(
        _ session: MEComposeSession,
        completion: @escaping (Error?) -> Void
    ) {
        guard let rawData = session.mailMessage.rawData else {
            // Cannot read message data — allow sending to avoid blocking the user
            completion(nil)
            return
        }

        let parsed = MIMEParser.parse(data: rawData)
        let bodyText = parsed.bodyText

        // Also check subject — but skip inherited subjects from forwards/replies
        // (e.g. "Tr : Facture..." or "Re: Invoice..." are not the user's words)
        let subject = session.mailMessage.subject
        let trimmedSubject = subject.trimmingCharacters(in: .whitespaces).lowercased()
        let inheritedPrefixes = ["tr :", "tr:", "fwd:", "fwd :", "re :", "re:", "fw:", "fw :"]
        let isInherited = inheritedPrefixes.contains(where: { trimmedSubject.hasPrefix($0) })
        let fullText = (isInherited ? "" : subject) + " " + bodyText

        // Look for attachment keywords
        guard let matchedKeyword = KeywordDetector.findKeyword(in: fullText) else {
            // No attachment keywords found — allow sending
            completion(nil)
            return
        }

        // Keywords found — check if there are attachments
        if parsed.hasAttachments {
            // Attachment present — all good
            completion(nil)
            return
        }

        // Keywords found but no attachment → block sending
        let errorMessage: String
        if KeywordDetector.frenchKeywords.contains(where: { matchedKeyword.lowercased() == $0.lowercased() }) {
            errorMessage = "Oups ! Vous avez mentionné « \(matchedKeyword) » mais aucune pièce jointe n'est attachée à ce mail. Ajoutez votre fichier avant d'envoyer."
        } else {
            errorMessage = "Oops! You mentioned \"\(matchedKeyword)\" but no attachment was found. Please attach your file before sending."
        }

        let error = NSError(
            domain: "com.zapclipper.mail",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: errorMessage]
        )
        completion(error)
    }
}
