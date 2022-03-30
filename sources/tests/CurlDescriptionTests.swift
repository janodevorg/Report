@testable import Report
import XCTest

final class CurlDescriptionTests: XCTestCase
{
    let urlString = "https://httpbin.org/get"
    lazy var url = URL(string: urlString)!
    lazy var urlRequest = URLRequest(url: url)

    func testGET() throws
    {
        let cURL = try CurlDescription(urlRequest: urlRequest, session: URLSession.shared).cURLDescription()
        let components = cURLCommandLines(from: cURL)
        guard components.count == 1 else {
            XCTFail("Expected 1 elements, but got \(components)")
            return
        }
        XCTAssertEqual(components[0..<1], ["curl -v -X GET \"https://httpbin.org/get\""])
        print(cURL as Any)
    }
    
    /// Returns single lines without linebreaks or trailing back slashes
    private func cURLCommandLines(from cURLString: String) -> [String] {
        return cURLString.components(separatedBy: " \\\n")
    }
    
    /// Returns each component of the bash command, e.g. "-X GET" --> "-X" "GET".
    private func cURLCommandComponents(from cURLString: String) -> [String] {
        return cURLString.components(separatedBy: .whitespacesAndNewlines)
            .filter { $0 != "" && $0 != "\\" }
    }
}
