struct ReportSection
{
    let title: String?
    let content: String

    init?(content: String, title: String? = nil) {
        guard !content.isEmpty else { return nil }
        self.title = title
        self.content = content
    }
}
