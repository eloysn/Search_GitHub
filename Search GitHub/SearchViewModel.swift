

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    let clientAPI = SessionAPI()
    var repoArr = [Repositories] ()
    let diposeBag = DisposeBag()
    var page = BehaviorRelay<Int>(value: 1)
    var query = BehaviorRelay<String>(value: "")
    
    func listReposCount() -> Int {
        
        return repoArr.count - 5
    }
    func getPage() -> Int? {
        guard let page = repoArr.last?.id else {
            return nil
        }
        return page
    }
    
    private lazy var _listRepos: Observable<[Repositories]> = self.page.asObservable()
        .distinctUntilChanged()
        .flatMapLatest { page  in
            return self.clientAPI.send(request: API.listRepos(page: page))
        }.catchErrorJustReturn([])
    
    private(set) lazy var listRepos: Observable<[Repositories]> = self._listRepos
        .map { repos  in
            self.repoArr += repos
            return self.repoArr
    }
    
    
    private(set) lazy var searchProyects: Observable<[Repositories]> = self._searchProyects.asObservable()
        .map {  p in
            return p.items
        }.catchErrorJustReturn([])
    
    
    private lazy var _searchProyects: Observable<SearchItems> = self.query.asObservable()
        .distinctUntilChanged()
        .filter{ $0.count > 0 && !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        .flatMap {  query in
            return self.clientAPI.send(request: API.searchRepos(query: query))
    }
    
}
