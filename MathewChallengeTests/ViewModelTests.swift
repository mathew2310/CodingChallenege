//
//  MathewChallengeTests.swift
//  MathewChallengeTests
//
//  Created by Mathew Ijidakinro on 4/25/22.
//

import XCTest
import Combine
@testable import MathewChallenge

class ViewModelTests: XCTestCase {
    
    private var subscribers = Set<AnyCancellable>()
    var viewModel: ViewModel!
    var mockServiceManager: MockServiceManager!
    
    

    override func setUpWithError() throws {
        mockServiceManager = MockServiceManager()
        viewModel = ViewModel(serviceManager: mockServiceManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadPopularMovies() throws {
        // Given
        resetMockServiceManager()
        mockServiceManager.data = try getData(json: "movies")
        let expectation = expectation(description: "waiting for response")
        
        // When
        viewModel
            .$movies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        viewModel.loadPopularMovies()
        
        // Then
        waitForExpectations(timeout: 2.0)
        XCTAssertTrue(viewModel.movies.count == 20)
        XCTAssertTrue(viewModel.movies.first?.originalTitle == "Nightmare Alley")
        XCTAssertEqual(viewModel.movieCount, 20)
    }
    
    func testFilterMovies() throws {
        // Given
        resetMockServiceManager()
        mockServiceManager.data = try getData(json: "movies")
        let expectation = expectation(description: "waiting for response")
        expectation.expectedFulfillmentCount = 2
        
        // When
        viewModel
            .$movies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        viewModel.loadPopularMovies()
        viewModel.filterMovies(by: "Morbius")
        waitForExpectations(timeout: 2.0)
        
        // Then
        XCTAssertTrue(viewModel.movies.count == 1)
        XCTAssertTrue(viewModel.movies.first?.originalTitle == "Morbius")
    }
    
    private func resetMockServiceManager() {
        mockServiceManager.data = nil
        mockServiceManager.error = nil
    }
    
    private func getData(json: String) throws -> Data {
        guard let urlFile = Bundle(for: ViewModelTests.self).url(forResource: json, withExtension: "json")
        else { return Data() }
        let data = try Data(contentsOf: urlFile)
        return data
    }
    
}

