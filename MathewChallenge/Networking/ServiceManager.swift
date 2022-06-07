//
//  NetworkManager.swift
//  MathewChallenge
//
//  Created by Mathew Ijidakinro on 4/22/22.
//

import Foundation

protocol ServiceProtocol {
    func getModel<T: Decodable>(_ model: T.Type, from url: String, completionHandler: @escaping (Result<T, Error>) -> ())
    func getData(from url: String, completionHandler: @escaping (Result<Data, Error>) -> ())
}

class ServiceManager: ServiceProtocol {
    
    func getModel<T: Decodable>(_ model: T.Type, from url: String, completionHandler: @escaping (Result<T, Error>) -> ()) {
        guard let url = URL(string: url) else {
            completionHandler(.failure(NSError(domain: "bad url", code: 0)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NSError(domain: "bad data", code: 0)))
                return
            }
            do {
                let response = try JSONDecoder().decode(model, from: data)
                completionHandler(.success(response))
            } catch (let error) {
                completionHandler(.failure(error))
            }
        }
        .resume()
    }
    
    func getData(from url: String, completionHandler: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: url) else {
            completionHandler(.failure(NSError(domain: "bad url", code: 0)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NSError(domain: "bad data", code: 0)))
                return
            }
            completionHandler(.success(data))
        }
        .resume()
    }
}

