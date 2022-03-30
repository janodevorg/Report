import Foundation

@resultBuilder
enum LogBuilder
{
    static func buildExpression(_ expression: String) -> String {
        expression
    }

    static func buildExpression(_ section: ReportSection) -> String {
        guard !section.content.isEmpty else {
            return ""
        }
        guard let title = section.title, !title.isEmpty else {
            return format(content: section.content)
        }
        return format(title: title, content: section.content)
    }

    static func buildExpression(_ section: ReportSection?) -> String {
        section.flatMap { buildExpression($0) } ?? ""
    }

    static func buildBlock(_ components: String...) -> String {
        components.filter { !$0.isEmpty }.joined(separator: "\n")
    }

    static func buildFinalResult(_ component: String) -> String {
        guard !component.isEmpty else { return "" }
        return finishString(buffer: component)
    }

    // MARK: - Format

    private static let horBar = " ├─ "
    private static let verBar = " │ "
    private static let endBar = " └"

    private static func format(title: String, content: String) -> String {
        """
        \(format(title: title))
        \(format(content: content))
        """
    }

    private static func format(title: String) -> String {
        "\(horBar)\(title)"
    }

    private static func format(content: String) -> String {
        content.split(separator: "\n")
            .map { "\(verBar)\($0)" }
            .joined(separator: "\n")
    }

    private static func finishString(buffer: String) -> String {
        buffer + "\n\(endBar)"
    }
}
