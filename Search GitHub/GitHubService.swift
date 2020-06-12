import Foundation
import RxSwift

protocol GitHubService {
    func getRepositories(page: Int) -> Single<[Repositories]>
    func searchRepositories(query: String) -> Single<[Repositories]>
}

final class GitHubServiceImpl: GitHubService {
    let session: SessionAPI

    init(session: SessionAPI = SessionAPI()) {
       self.session = session
    }
   
    func getRepositories(page: Int) -> Single<[Repositories]> {
        let request = RepositoriesRequest(page: page)
        return session.sendWithError(request: request)
    }
    
    func searchRepositories(query: String) -> Single<[Repositories]> {
        let request = SearchRepositoriesRequest(query: query)
        return session.sendWithError(request: request).map { $0.items ?? [] }
    }
}
