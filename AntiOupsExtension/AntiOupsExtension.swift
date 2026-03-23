import MailKit

class AntiOupsExtension: NSObject, MEExtension {

    func handler(for session: MEComposeSession) -> MEComposeSessionHandler {
        return ComposeSessionHandler()
    }
}
