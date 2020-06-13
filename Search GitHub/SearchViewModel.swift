

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    private let activity = ActivityIndicator()
    private let page = PublishSubject<Int>()
    private let query = BehaviorSubject<String>(value: "")
    private let isSearching = BehaviorSubject<Bool>(value: false)
    private let listRepos = PublishSubject<[Repositories]>()
    private let loadPage = PublishSubject<Bool>()
    private let gitHubService: GitHubService
    private var numberPage: Int = 1
    
    let input: Input
    struct Input {
        let query: AnyObserver<String>
        let isSearching: AnyObserver<Bool>
        let loadPage: AnyObserver<Bool>
    }
    
    let output: Output
    struct Output {
        let listRepos: PublishSubject<[Repositories]>
        let activity: Driver<Bool>
    }
    
    init(service: GitHubService = GitHubServiceImpl()) {
        self.gitHubService = service
        self.input = Input(query: query.asObserver(),
                           isSearching: isSearching.asObserver(),
                           loadPage: loadPage.asObserver())
        self.output = Output(listRepos: listRepos,
                             activity: activity.asDriver(onErrorJustReturn: false))
    }
    
    func bind() {
        loadPage.filter { $0 }
            .map { [unowned self] _ in return self.numberPage }
            .bind(to: page)
            .disposed(by: disposeBag)
         
        let repos = page.startWith(numberPage).flatMapLatest { [unowned self] page in
            self.gitHubService.getRepositories(page: page)
                .do(onSuccess: { self.numberPage = $0.last?.id ?? 1 })
                .trackActivity(self.activity)
                .catchError { _ in Observable.just([]) }
                .scan([]) { $0 + $1 } }
                
        
        let searchRepos = query.distinctUntilChanged()
            .filter {$0.count > 2}
            .startWith("")
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] query in
                self.gitHubService.searchRepositories(query: query)
                    .trackActivity(self.activity)
                    .catchError { _ in return Observable.just([]) }
        }
    
        Observable.combineLatest(repos, searchRepos, isSearching).map { list, search, isSearch in
                return isSearch ? search : list
            }.bind(to: listRepos)
            .disposed(by: disposeBag)
    }
}
