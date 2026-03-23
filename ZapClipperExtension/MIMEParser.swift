import Foundation

/// Lightweight MIME parser to extract body text and detect attachments
/// from raw RFC 2822 email data.
struct MIMEParser {

    struct Result {
        let bodyText: String
        let hasAttachments: Bool
    }

    static func parse(data: Data) -> Result {
        guard let raw = String(data: data, encoding: .utf8)
                ?? String(data: data, encoding: .ascii) else {
            return Result(bodyText: "", hasAttachments: false)
        }

        // Split headers from body
        let headerBodySeparator = "\r\n\r\n"
        let altSeparator = "\n\n"

        let separator: String
        let separatorRange: Range<String.Index>

        if let range = raw.range(of: headerBodySeparator) {
            separator = headerBodySeparator
            separatorRange = range
        } else if let range = raw.range(of: altSeparator) {
            separator = altSeparator
            separatorRange = range
        } else {
            return Result(bodyText: raw, hasAttachments: false)
        }

        let headers = String(raw[raw.startIndex..<separatorRange.lowerBound]).lowercased()
        let body = String(raw[separatorRange.upperBound...])

        // Check if multipart
        if let boundaryValue = extractBoundary(from: headers) {
            return parseMultipart(body: body, boundary: boundaryValue)
        }

        // Simple message — no multipart, no attachments
        let hasAttachment = headers.contains("content-disposition: attachment")
        return Result(bodyText: stripHTMLTags(body), hasAttachments: hasAttachment)
    }

    // MARK: - Private

    private static func extractBoundary(from headers: String) -> String? {
        // Look for boundary= in Content-Type header
        guard let boundaryRange = headers.range(of: "boundary=") else { return nil }
        let afterBoundary = String(headers[boundaryRange.upperBound...])
        // Remove leading quote if present
        let trimmed = afterBoundary.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("\"") {
            // Quoted boundary
            let unquoted = trimmed.dropFirst()
            if let endQuote = unquoted.firstIndex(of: "\"") {
                return String(unquoted[unquoted.startIndex..<endQuote])
            }
        }
        // Unquoted — take until whitespace, semicolon, or newline
        let endChars = CharacterSet.whitespacesAndNewlines.union(CharacterSet(charactersIn: ";"))
        var result = ""
        for char in trimmed {
            if char.unicodeScalars.allSatisfy({ endChars.contains($0) }) {
                break
            }
            result.append(char)
        }
        return result.isEmpty ? nil : result
    }

    private static func parseMultipart(body: String, boundary: String) -> Result {
        let delimiter = "--\(boundary)"
        let parts = body.components(separatedBy: delimiter)

        var textParts: [String] = []
        var hasAttachments = false

        for part in parts {
            let trimmed = part.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty || trimmed == "--" { continue }

            let lowered = trimmed.lowercased()

            // Check for attachment indicators
            if lowered.contains("content-disposition: attachment") ||
               (lowered.contains("content-disposition:") && lowered.contains("filename=")) {
                hasAttachments = true
                continue
            }

            // Extract body from this part
            let partSeparator = "\r\n\r\n"
            let altPartSep = "\n\n"

            let partBody: String
            if let range = trimmed.range(of: partSeparator) {
                partBody = String(trimmed[range.upperBound...])
            } else if let range = trimmed.range(of: altPartSep) {
                partBody = String(trimmed[range.upperBound...])
            } else {
                partBody = trimmed
            }

            // Only include text parts
            if lowered.contains("content-type: text/plain") || lowered.contains("content-type: text/html") ||
               (!lowered.contains("content-type:") && !partBody.isEmpty) {
                textParts.append(stripHTMLTags(partBody))
            }

            // Recursively check for nested multipart
            if let nestedBoundary = extractBoundary(from: lowered) {
                let nested = parseMultipart(body: partBody, boundary: nestedBoundary)
                textParts.append(nested.bodyText)
                if nested.hasAttachments { hasAttachments = true }
            }
        }

        return Result(bodyText: textParts.joined(separator: "\n"), hasAttachments: hasAttachments)
    }

    /// Extract only the NEW text from an HTML email, discarding quoted replies.
    /// Mail wraps previous messages in <blockquote> tags — we keep only what's before.
    private static func extractNewHTMLContent(_ html: String) -> String {
        // Find the first <blockquote (case insensitive) and take everything before it
        if let range = html.range(of: "<blockquote", options: .caseInsensitive) {
            return String(html[html.startIndex..<range.lowerBound])
        }
        // Also check for Apple Mail's specific div class for quoted content
        if let range = html.range(of: "<div class=\"gmail_quote\"", options: .caseInsensitive) {
            return String(html[html.startIndex..<range.lowerBound])
        }
        return html
    }

    /// Extract only the NEW text from a plain text email, discarding quoted replies.
    private static func extractNewPlainTextContent(_ text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
        var cleanLines: [String] = []

        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Stop at reply headers (everything after is quoted)
            // French: "Le [date], [name] a écrit :"
            // English: "On [date], [name] wrote:"
            let lowered = trimmed.lowercased()
            if (lowered.hasPrefix("le ") && lowered.contains("a écrit")) ||
               (lowered.hasPrefix("on ") && lowered.contains("wrote:")) {
                break
            }
            // "---------- Forwarded message ----------"
            if lowered.contains("forwarded message") || lowered.contains("message transféré") ||
               lowered.contains("début du message transféré") || lowered.contains("begin forwarded message") {
                break
            }
            // Separator lines like "---" or "___" before quoted content
            if trimmed.count >= 10 && (trimmed.allSatisfy({ $0 == "-" }) || trimmed.allSatisfy({ $0 == "_" })) {
                break
            }

            // Skip lines starting with > (quoted text in plain text emails)
            if trimmed.hasPrefix(">") {
                continue
            }

            cleanLines.append(line)
        }

        return cleanLines.joined(separator: "\n")
    }

    private static func stripHTMLTags(_ html: String) -> String {
        // First extract only the new content (before any blockquote/quoted reply)
        let newContent = extractNewHTMLContent(html)

        // Convert HTML to plain text
        guard let data = newContent.data(using: .utf8) else {
            return extractNewPlainTextContent(newContent)
        }
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            // Also apply plain text filtering as a safety net
            return extractNewPlainTextContent(attributedString.string)
        }
        // Fallback: regex strip then filter plain text
        let stripped = newContent.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression)
        return extractNewPlainTextContent(stripped)
    }
}
