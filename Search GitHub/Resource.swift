
import Foundation

enum Method: String {
    
    case GET = "GET"
    case POST = "POST"
    case UPDATE = "UPDATE"
    case DELEETE = "DELETE"
    
}

protocol Resource {
    
    var method: Method { get }
    var baseURL: URL { get }
    var path: String { get }
    var parameters: [String: String] { get }
    var bodyObjects: [String: Any] { get }
}

//Implementacion por defecto del protoco Resource
extension Resource {
    
    var baseURL: URL {
        guard let baseURL = URL(string: API_URL) else {
            fatalError("Imposible get baseURL for API")
        }
        return baseURL
    }
    
    
    
     func requestWithBaseURL() -> URLRequest {
        
        let URL = baseURL.appendingPathComponent(path)
        
        guard var components = URLComponents(url: URL, resolvingAgainstBaseURL: false) else {

            fatalError("Unable to create URLCompounent form \(URL)")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: $1 )

        }
       
        guard let finalURL = components.url else {
            fatalError("Unable to retrieve final URL")
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        return request
    }
        
    
}



