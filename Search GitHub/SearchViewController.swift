
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
    private let activity = UIActivityIndicatorView()
    let model = SearchViewModel()
   
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
        tableView.dataSource = nil
        tableView.rowHeight = 100
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.title = "Github"
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        activity.color = .gray
        activity.style = .whiteLarge
        activity.hidesWhenStopped = true
    }
    
    func setupBinding()  {
        searchController.searchBar.rx.text.orEmpty
            .bind(to: viewModel.input.query)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty.map { !$0.isEmpty }
            .bind(to: viewModel.input.isSearching)
            .disposed(by: disposeBag)
        
        viewModel.output.listRepos
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: SearchViewCell.self)) { index, model, cell in
                cell.populate(model: model)
        }.disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .map { [unowned self] _ in self.tableView.isNearBottomEdge() }
            .distinctUntilChanged()
            .bind(to: viewModel.input.loadPage)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Repositories.self).do(onNext: { repo in
            self.performSegue(withIdentifier: "showDetail", sender: repo)
            }).subscribe().disposed(by: disposeBag)
        
        viewModel.output.activity
            .drive(activity.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.bind()
    }
}

// MARK: - Segues
extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
            let detailVC = (segue.destination as? UINavigationController)?.topViewController as?  DetailViewController,
            let model = sender as? Repositories {
            detailVC.model = model
        }
    }
}
