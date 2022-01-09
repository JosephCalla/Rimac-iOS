//
//  MovieViewController.swift
//  Rimac
//
//  Created by Joseph Estanislao Calla Moreyra on 1/9/22.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viemModel: MovieViewModelProtocol = MovieViewModel(service: MovieService())
    var moviesPopular : [Movie] = []
    var moviesTopRated: [Movie] = []
    var moviesUpComing: [Movie] = []
    var moviesPopularFilter = [Movie]()
    var moviesTopRatedFilter = [Movie]()
    var moviesUpcomingFilter = [Movie]()
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viemModel.delegate = self
        self.viemModel.getMovies(movieType: .popular)
        self.viemModel.getMovies(movieType: .topRated)
        self.viemModel.getMovies(movieType: .upComing)
        self.tableView.isHidden = true
        self.searchView.isHidden = true
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        self.tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getImages(movies:[Movie]) -> [Movie] {
        var moviesWithImage: [Movie] = movies
        for (index,movie) in movies.enumerated() {
            if movie.backdropImage == nil {
                moviesWithImage[index].backdropImage = self.viemModel.getCache(id: moviesWithImage[index].idBackdropPath)
            }
            if movie.posterImage == nil {
                moviesWithImage[index].posterImage = self.viemModel.getCache(id: moviesWithImage[index].idPosterPath)
            }
        }
        return moviesWithImage
    }
}
extension MovieViewController: MovieViewModelDelegate {
    func getMovies(movies: [Movie]?, error: Error?) {
        
        guard let movies = movies else {
            return
        }
        
        guard movies.count > 0 else {
            return
        }
        
//        if movies.contains(where: { movie in movie.backdropImage == nil || movie.posterImage == nil }){
//            sleep(1)
//        }
        
        let moviesWithImage = getImages(movies: movies)
        
        if movies.contains(where: { Movie in Movie.movieType == .popular }) {
            self.moviesPopular = moviesWithImage
        }
        
        if movies.contains(where: { Movie in Movie.movieType == .topRated }) {
            self.moviesTopRated = moviesWithImage
        }
        
        if movies.contains(where: { Movie in Movie.movieType == .upComing }) {
            self.moviesUpComing = moviesWithImage
        }
                
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.searchView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
}

extension MovieViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearch {
            switch section {
            case 0:
                return "Polular \(self.moviesPopularFilter.count)"
            case 1:
                return "Top Rated \(self.moviesTopRatedFilter.count)"
            case 2:
                return "Up Comming \(self.moviesUpcomingFilter.count)"
            default:
                return ""
            }
        } else {
            switch section {
            case 0:
                return "Polular \(self.moviesPopular.count)"
            case 1:
                return "Top Rated \(self.moviesTopRated.count)"
            case 2:
                return "Up Comming \(self.moviesUpComing.count)"
            default:
                return ""
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell
        
        self.moviesPopular = getImages(movies: self.moviesPopular)
        self.moviesTopRated = getImages(movies: self.moviesTopRated)
        self.moviesUpComing = getImages(movies: self.moviesUpComing)
        
        if isSearch {
            if indexPath.section == 0 {
                cell?.movies = self.moviesPopularFilter
            }
            
            if indexPath.section == 1 {
                cell?.movies = self.moviesTopRatedFilter
            }
            
            if indexPath.section == 2 {
                cell?.movies = self.moviesUpcomingFilter
            }
            
        } else {
            if indexPath.section == 0 {
                cell?.movies = self.moviesPopular
            }
            
            if indexPath.section == 1 {
                cell?.movies = self.moviesTopRated
            }
            
            if indexPath.section == 2 {
                cell?.movies = self.moviesUpComing
            }
        }
        
        if let movies = cell?.movies {
            cell!.configure(movies: movies)
            cell?.delegate = self
        }
        
        return cell!
    }
}

extension MovieViewController: MovieTableCellDelegate {
    func isSelected(movie: Movie) {
        DispatchQueue.main.async {
            let movieDetaildView = self.storyboard?.instantiateViewController(withIdentifier: "DetailMovieViewController") as! DetailMovieViewController
            movieDetaildView.movie = movie
            movieDetaildView.title = movie.title
            self.present(movieDetaildView, animated: true, completion: nil)
        }
    }
}

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MovieViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
        guard let filter = searchBar.text else {
            return
        }
        
        moviesPopularFilter = self.moviesPopular.filter({ movie in
            movie.title.contains(filter)
        })
        
        moviesTopRatedFilter = self.moviesTopRated.filter({ movie in
            movie.title.contains(filter)
        })
        
        moviesUpcomingFilter = self.moviesUpComing.filter({ movie in
            movie.title.contains(filter)
        })
        
        isSearch = true
        
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.searchView.isHidden = false
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearch = false
            
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.searchView.isHidden = false
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
}

