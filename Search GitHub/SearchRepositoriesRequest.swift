import Foundation

final class SearchRepositoriesRequest: APIRequest {
    
    typealias Response = SearchRepositoriesResponse
    
    let query: String
    
    init (query: String) {
        self.query = query
    }
    
    var method: Method { .GET}
    
    var path: String { "/search/repositories" }
    
    var parameters: [String: String] { ["q": query] }
    
    var bodyObjects: [String: Any] { [:] }
    
    var headers: [String: String] { [:] }
}
