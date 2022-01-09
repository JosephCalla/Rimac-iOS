//
//  RimacTests.swift
//  RimacTests
//
//  Created by Joseph Estanislao Calla Moreyra on 1/9/22.
//

import XCTest
@testable import Rimac

class MovieViewTest: XCTestCase {

    var service:MovieServiceProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        service = MovieService()
    }

    override func tearDownWithError() throws {
        service = nil
        try super.tearDownWithError()

    }
    
    func testMoviservice() {
        var hasData = false
        // Act
        service.getMovies(request: MovieRequest(movieType: .popular)) { response, error in
            if let response = response {
                if response.results.count > 0 {
                    hasData = true
                    XCTAssertEqual(hasData,true)
                    return
                }
            }
        }
        // Assert
    }
}
