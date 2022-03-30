@testable import Report
import os
import XCTest

final class ReportTests: XCTestCase
{
    private let log = Logger(subsystem: "dev.jano", category: "report")

    func testRequest() throws
    {
        let url = URL(string: "https://www.google.com")!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Host": "developer.mozilla.org",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:50.0) Gecko/20100101 Firefox/50.0",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.5",
            "Accept-Encoding": "gzip, deflate, br",
            "Referer": "https://developer.mozilla.org/en-US/docs/Glossary/Simple_header"

        ]
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: [
                "Content-Type": "text/html; charset=utf-8",
                "Date": "Wed, 20 Jul 2016 10:55:30 GMT",
                "Etag": "547fa7e369ef56031dd3bff2ace9fc0832eb251a",
                "Keep-Alive": "timeout=5, max=1000",
                "Last-Modified": "Tue, 19 Jul 2016 00:59:33 GMT",
                "Server": "Apache",
                "Transfer-Encoding": "chunked",
                "Vary": "Cookie, Accept-Encoding"
            ]
        )
        let data = """
        <!DOCTYPE html>
        <html>
          <body>Some content.</body>
        </html>
        """.data(using: .utf8)
        let report = Report(request: request, response: response, data: data, error: nil).report()
        log.debug("\(report)")
    }
}
