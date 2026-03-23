import MailKit

class ZapClipperExtension: NSObject, MEExtension {

    func handler(for session: MEComposeSession) -> MEComposeSessionHandler {
        return ComposeSessionHandler()
    }
}
