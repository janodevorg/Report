import Foundation

public struct CurlDescription
{
    private let urlRequest: URLRequest
    private let session: URLSession
    private let url: URL
    private let host: String
    private let httpMethod: String
    private let lineSeparator = " \\\n"
    
    public init(urlRequest: URLRequest, session: URLSession) throws
    {
        guard
            let url = urlRequest.url,
            let host = url.host,
            let httpMethod = urlRequest.httpMethod
        else {
            throw URLError(.badURL)
        }
        
        self.urlRequest = urlRequest
        self.session = session
        self.url = url
        self.host = host
        self.httpMethod = httpMethod
    }

    /// cURL representation of the instance.
    ///
    /// - Returns: The cURL equivalent of the instance.
    public func cURLDescription() -> String
    {
        [
            "curl -v \(method()) \(absoluteURL())",
            body(),
            cookieComponent(),
            credentials()?.joined(separator: lineSeparator),
            headers()?.joined(separator: lineSeparator)
        ]
        .compactMap { $0 }
        .joined(separator: lineSeparator)
    }
    
    private func method() -> String
    {
        "-X \(httpMethod)"
    }
    
    private func absoluteURL() -> String
    {
        "\"\(url.absoluteString)\""
    }
    
    private func credentials() -> [String]?
    {
        guard let credentialStorage = session.configuration.urlCredentialStorage else { return [] }
        let protectionSpace = URLProtectionSpace(host: host,
                                                 port: url.port ?? 0,
                                                 protocol: url.scheme,
                                                 realm: host,
                                                 authenticationMethod: NSURLAuthenticationMethodHTTPBasic)
        return credentialStorage.credentials(for: protectionSpace)?.values
            .compactMap { credential in
                guard let user = credential.user, let password = credential.password else { return nil }
                return "-u \(user):\(password)"
            }
    }
    
    private func cookieComponent() -> String?
    {
        guard session.configuration.httpShouldSetCookies else { return nil }
        guard
            let cookieStorage = session.configuration.httpCookieStorage,
            let cookies = cookieStorage.cookies(for: url),
            !cookies.isEmpty
        else {
            return nil
        }
        let allCookies = cookies.map { "\($0.name)=\($0.value)" }.joined(separator: ";")
        return "-b \"\(allCookies)\""
    }
    
    private func headers() -> [String]?
    {
        let allHeaders: [AnyHashable: Any] = {
            var sessionHeaders = session.configuration.httpAdditionalHeaders?.filter { "\($0.0)" != "Cookie" } ?? [:]
            let requestHeaders = urlRequest.allHTTPHeaderFields?.filter { "\($0.0)" != "Cookie" } ?? [:]
            sessionHeaders.merge(requestHeaders, uniquingKeysWith: { $1 })
            return sessionHeaders
        }()
        guard !allHeaders.isEmpty else {
            return nil
        }
        return allHeaders.map {
            let escapedValue = "\($0.1)".replacingOccurrences(of: "\"", with: "\\\"")
            return "-H \"\($0.0): \(escapedValue)\""
        }
    }
    
    private func body() -> String?
    {
        guard let httpBodyData = urlRequest.httpBody else { return nil }
        let httpBody = String(decoding: httpBodyData, as: UTF8.self)
        var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
        escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")
        return "-d \"\(escapedBody)\""
    }
}
