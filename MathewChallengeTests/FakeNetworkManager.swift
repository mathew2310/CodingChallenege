//
//  FakeNetworkManager.swift
//  MathewChallengeTests
//
//  Created by Mathew Ijidakinro on 4/25/22.
//

import Foundation
@testable import MathewChallenge

class FakeNetworkManager: NetworkProtocol {
    
    var data: Data?
    var error: Error?
    
    func getModel<T>(_ model: T.Type, from url: String, completionHandler: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        if let data = data {
            do {
                let response = try JSONDecoder().decode(model, from: data)
                completionHandler(.success(response))
            } catch (let error) {
                completionHandler(.failure(error))
            }
        }
        if let error = error {
            completionHandler(.failure(error))
        }
    }

    func getData(from url: String, completionHandler: @escaping (Result<Data, Error>) -> ()) {
        if let data = data {
            completionHandler(.success(data))
        }
        if let error = error {
            completionHandler(.failure(error))
        }
    }
}

