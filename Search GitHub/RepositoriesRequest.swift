import Foundation

final class RepositoriesRequest: APIRequest {
    
    typealias Response = RepositoriesResponse
    
    let page: Int
    
    init (page: Int) {
        self.page = page
    }
    
    var method: Method { .GET}
    
    var path: String { "/repositories" }
    
    var parameters: [String: String] { ["since": String(page)] }
    
    var bodyObjects: [String: Any] { [:] }
    
    var headers: [String: String] { [:] }
}
