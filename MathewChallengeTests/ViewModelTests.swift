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
    var fakeNetworkManager: FakeNetworkManager!

    override func setUpWithError() throws {
        fakeNetworkManager = FakeNetworkManager()
        viewModel = ViewModel(networkManager: fakeNetworkManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadPopularMovies() throws {
        // Given
        resetFakeNetworkManager()
        fakeNetworkManager.data = try getData(json: "movies")
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
    }
    
    func testFilterMovies() throws {
        // Given
        resetFakeNetworkManager()
        fakeNetworkManager.data = try getData(json: "movies")
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
    
    private func resetFakeNetworkManager() {
        fakeNetworkManager.data = nil
        fakeNetworkManager.error = nil
    }
    
    private func getData(json: String) throws -> Data {
        guard let urlFile = Bundle(for: ViewModelTests.self).url(forResource: json, withExtension: "json")
        else { return Data() }
        let data = try Data(contentsOf: urlFile)
        return data
    }
    
}
