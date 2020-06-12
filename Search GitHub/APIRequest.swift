import Foundation

let APIURL = "https://api.github.com"

enum Method: String {
    case GET
    case POST
    case PUT
    case UPDATE
    case DELETE
}

protocol APIRequest: Encodable {
    associatedtype Response: Codable
    var method: Method { get }
    var baseURL: URL { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var bodyObjects: [String: Any] { get }
    var headers: [String: String] { get }
}

//Default implementation of APIRequest protocol
extension APIRequest {
    
    var baseURL: URL {
        guard let baseURL = URL(string: APIURL) else {
            fatalError("Imposible get baseURL for API")
        }
        return baseURL
    }
    
    func requestWithBaseURL() -> URLRequest {
        
        let URL = baseURL.appendingPathComponent(path)
        
        guard var components = URLComponents(url: URL, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URLCompounent form \(URL)")
        }
        
        if !parameters.isEmpty {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0, value: $1 )
            }
        }
        
        guard let finalURL = components.url else {
            fatalError("Unable to retrieve final URL")
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        // Set Body
        if !bodyObjects.isEmpty {
            request.httpBody = getDataFromJson(bodyObjects)
        }
        
        //Set Content-Type
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        //Set Headers
        if !headers.isEmpty {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        return request
    }
    
    private func getDataFromJson(_ params: [String:Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    }
}
