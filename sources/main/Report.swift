import Foundation

/**
 Creates a report for a data task result.
 */
public struct Report: CustomStringConvertible
{
    private let request: URLRequest
    private let response: HTTPURLResponse?
    private let error: Error?
    private let data: Data?
    private let curl: CurlDescription?

    /// Initializes the report with the result of a data task request.
    public init(
        request: URLRequest,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error? = nil,
        session: URLSession? = nil
    ) {
        self.request = request
        self.response = response
        self.error = error
        self.data = data
        self.curl = try? CurlDescription(urlRequest: request, session: URLSession.shared)
    }

    public func report() -> String {
        [
            summary,
            reportRequest(),
            response.flatMap { _ in reportResponse() },
            curl.flatMap { _ in cURLDescription() }
        ]
            .compactMap { $0 }
            .joined(separator: "\n")
    }

    public func cURLDescription() -> String
    {
        var desc = curl?.cURLDescription() ?? ""
        desc = desc.replacingOccurrences(of: "\n", with: "\n\t")
        let blank = "‎" // contains an unicode invisible space
        return """
        To save this request to a file run:
          \(desc) | python -mjson.tool > file.json
        \(blank)
        """
    }

    @LogBuilder
    public func reportRequest() -> String
    {
        "Request"
        ReportSection(content: queryString, title: "Query String")
        ReportSection(content: requestHeaders, title: "Headers")
        ReportSection(content: sentDataDescription, title: "Body")
    }

    @LogBuilder
    public func reportResponse() -> String
    {
        "Response"
        ReportSection(content: responseHeaders, title: "Headers")
        ReportSection(content: responseDataDescription, title: "Body")
        ReportSection(content: errorDescription, title: "Error")
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        report()
    }

    // MARK: - Private

    private var errorDescription: String { error.flatMap { "\($0)" } ?? "" }
    private var status: String? { response?.statusCode.description }
    private var method: String? { request.httpMethod?.description }
    private var url: String? { request.url?.absoluteString }
    private var requestHeaders: String {
        let headers = format(request.allHTTPHeaderFields ?? [:])
        return headers.isEmpty ? "" : headers
    }
    private var responseHeaders: String {
        guard let response = response else { return "" }
        let headers = format(response.allHeaderFields)
        return headers.isEmpty ? "" : headers
    }
    private var responseDataDescription: String { describe(data: data) }
    private var sentDataDescription: String { describe(data: request.httpBody) }

    private func describe(data: Data?) -> String {
        let visibleStringCount = 200
        guard let data = data else {
            // no data sent
            return ""
        }
        guard let string = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\n", with: "") else {
            // not a UTF-8 string
            return "<not a UTF-8 string> \(data.count) bytes"
        }
        guard string.count <= visibleStringCount else {
            // string bigger than 'visibleStringCount' characters
            let suffix = "… (continues up to \(data.count) bytes)"
            return String(string.prefix(visibleStringCount - suffix.count)) + suffix
        }
        // string under 'visibleStringCount'' characters
        return string
    }

    // Returns `200 GET https://domain.com/api?1=2`
    private var summary: String {
        let summary = [status, method, url]
            .compactMap { $0 }
            .joined(separator: " ")
        return summary.isEmpty ? "Can’t summarize the request" : summary
    }

    private var queryString: String {
        guard
            let url = request.url,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let queryItems = components.queryItems
        else {
            return ""
        }
        let dic = queryItems.reduce(into: [AnyHashable: Any]()) {
            $0[$1.name] = $1.value
        }
        return format(dic)
    }

    private func format(_ headers: [AnyHashable: Any]) -> String {
        headers
            .compactMap { key, value in "\(key) = \(value)" }
            .sorted(by: { $0.lowercased() < $1.lowercased() })
            .joined(separator: "\n")
    }
}
