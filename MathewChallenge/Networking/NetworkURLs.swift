//
//  N etworkURLs.swift
//  MathewChallenge
//
//  Created by Mathew Ijidakinro on 4/22/22.
//

import Foundation

enum NetworkURLs {
    static let baseImgURL = "https://image.tmdb.org/t/p/w500"
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "?api_key=3215a185b25eb297a66e63d137fb994f"
    static let popularMovies = "\(baseURL)movie/popular\(apiKey)"
}

