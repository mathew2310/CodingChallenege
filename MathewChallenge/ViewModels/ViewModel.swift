//
//  ViewModel.swift
//  MathewChallenge
//
//  Created by Mathew Ijidakinro on 4/22/22.
//

import Foundation

class ViewModel {
    
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var imgCache: [String: Data] = [:]
    private var moviesDataSource: [Movie] = []
    private let networkManager: NetworkProtocol
    private var currentPage = 1
    private var isLoading = false
    private var searchText: String?
    
    init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func loadPopularMovies() {
        guard !isLoading else { return }
        
        // handle multiple loads
        isLoading = true
        
        // adding page to url
        let pageParameter = "&page=\(currentPage)"
        let url = "\(NetworkURLs.popularMovies)\(pageParameter)"
        networkManager.getModel(MoviesPopularResponse.self, from: url) { [weak self] result in
            switch result {
            case .success(let result):
                self?.moviesDataSource.append(contentsOf: result.results)
                self?.filterMovies(by: self?.searchText)
                self?.currentPage += 1
                self?.isLoading = false
            case .failure(let error):
                // printing error in console
                print(error.localizedDescription)
            }
        }
    }
    
    func filterMovies(by searchText: String?) {
        self.searchText = searchText
        guard let searchText = searchText, !searchText.isEmpty else {
            movies = moviesDataSource
            return
        }
        let moviesFiltered = moviesDataSource.filter { movie in
            let title = movie.originalTitle?.lowercased() ?? ""
            return title.contains(searchText.lowercased())
        }
        movies = moviesFiltered
    }
    
    func getImgData(by row: Int) -> Data? {
        guard let posterPath = movies[row].posterPath
        else { return nil }
        
        let url = "\(NetworkURLs.baseImgURL)\(posterPath)"
        
        // validating cache
        let data = imgCache[url]
        if data != nil {
            return data
        }
        
        // download image
        networkManager.getData(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.imgCache[url] = data
            case .failure(let error):
                // printing error in console
                print(error.localizedDescription)
            }
        }
        
        return nil
    }
    
    func getTitle(by row: Int) -> String? {
        return movies[row].originalTitle
    }
    
    func getOverview(by row: Int) -> String? {
        return movies[row].overview
    }
    
}

