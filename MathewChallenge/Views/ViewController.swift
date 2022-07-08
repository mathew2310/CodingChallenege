//
//  ViewController.swift
//  MathewChallenge
//
//  Created by Mathew Ijidakinro on 4/22/22.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var viewModel: ViewModel = ViewModel(serviceManager: ServiceManager())
    private var subscribers = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
        setUpBinding()
    }
    
    private func setUpUI() {
        title = NSLocalizedString("movies_title_key", comment: "")
    }
    
    private func setUpBinding() {
        viewModel
            .$movies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        viewModel
            .$imgCache
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        viewModel.loadPopularMovies()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterMovies(by: searchText)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell
        else { return UITableViewCell() }
        
        let row = indexPath.row
        let imgData = viewModel.getImgData(by: row)
        let title = viewModel.getTitle(by: row)
        let overview = viewModel.getOverview(by: row)
        cell.configure(imgData: imgData, title: title, overview: overview)
        return cell
    }
}


extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.loadPopularMovies()
    }
}
