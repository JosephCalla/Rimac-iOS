//
//  MovieResponse.swift
//  Rimac
//
//  Created by Joseph Estanislao Calla Moreyra on 1/9/22.
//

import Foundation

struct MovieResponse: Codable {
    let dates: MovieDates?
    let page: Int
    let results: [MovieData]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDates: Codable {
    let maximum, minimum: String
}
