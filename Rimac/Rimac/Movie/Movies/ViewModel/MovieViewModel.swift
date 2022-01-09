//
//  MovieViewModeel.swift
//  Rimac
//
//  Created by Joseph Estanislao Calla Moreyra on 1/9/22.
//

import Foundation
import UIKit
import Alamofire

protocol MovieViewModelProtocol: AnyObject {
    func getMovies(movieType: MovieType)
    func getCache(id:NSString) -> UIImage?
    
    var delegate: MovieViewModelDelegate? {get set}
    var service: MovieServiceProtocol { get }
}

protocol MovieViewModelDelegate: AnyObject {
    func getMovies(movies: [Movie]?, error: Error?)
}

class MovieViewModel: MovieViewModelProtocol {
    
    var service: MovieServiceProtocol
    var delegate: MovieViewModelDelegate?
    
    static let cache = NSCache<NSString, UIImage>()
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func getMovies(movieType: MovieType) {
        let request = MovieRequest(movieType: movieType)
        self.service.getMovies(request: request) {[weak self] response, error in
            
            let urlImage = "https://image.tmdb.org/t/p/w500"
            
            if let error = error {
                self?.delegate?.getMovies(movies: nil, error: error)
                return
            }
            
            if let movieResponse = response {
                var movies = [Movie]()
                for movieData in movieResponse.results {
                    var movie = Movie(movieData: movieData, movieType: request.movieType)
                    
                    movie.backdropPath = urlImage + movieData.backdropPath
                    movie.posterPath = urlImage + movieData.posterPath
                    movie.backdropImage = MovieViewModel.cache.object(forKey: movie.idBackdropPath)
                    movie.posterImage = MovieViewModel.cache.object(forKey: movie.idPosterPath)
                    movies.append(movie)
                }
                self?.delegate?.getMovies(movies: movies, error: nil)
            }
        }
    }
    
    func downloadImage(url:URL, completion: @escaping (UIImage?) -> Void) {}
    
    func getCache(id:NSString ) -> UIImage? {
        return MovieViewModel.cache.object(forKey: id as NSString)
    }
}
