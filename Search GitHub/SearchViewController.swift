
import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UITableViewController {


    // MARK: - Private
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    private var listRepos = [Repositories]()
    private var searchRepos = [Repositories]()
    private let searchController = UISearchController(searchResultsController: nil)
    
   
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBinding()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed {
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Configure
    func setup()  {
        
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.title = "Github"
    }
    
    func setupBinding()  {
        
        viewModel.listRepos.observeOn(MainScheduler.instance)
            .subscribe { event in
                guard let result = event.element else {
                    return
                }
                self.listRepos = result
                self.updateTable()
            }.disposed(by: disposeBag)
        
        viewModel.searchProyects.observeOn(MainScheduler.instance)
            .subscribe { event in
                guard let result = event.element else {
                    return
                }
                self.searchRepos = result
                self.updateTable()
            }.disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { cell, index in
                if index.row == self.viewModel.listReposCount() {
                    if let page = self.viewModel.getPage()   {
                        self.viewModel.page.accept(page)}
                }}).disposed(by: disposeBag)
        
        searchController.searchBar.rx.searchButtonClicked.subscribe { _ in
            self.viewModel.query.accept(self.searchController.searchBar.text ?? "")
            }.disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked.subscribe { _ in
            self.updateTable()
            }.disposed(by: disposeBag)
        
    }
    
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    func updateTable() {
        tableView.reloadData()
    }

    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail", let detailVC = (segue.destination as? UINavigationController)?.topViewController as?  DetailViewController {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let repo: Repositories
                if isFiltering() {
                    repo = searchRepos[indexPath.row]
                    
                }else{
                    repo = listRepos[indexPath.row]
                }
                
                detailVC.model = repo
            }
        }
    }

    


}
   // MARK: - Table View
extension SearchViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchRepos.count
        }else {
            return listRepos.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchViewCell
        if isFiltering() {
            cell.populate(model: searchRepos[indexPath.row])
        }else {
            cell.populate(model: listRepos[indexPath.row])
            
        }
        
        
        return cell
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController){
        updateTable()
    }
    
}
