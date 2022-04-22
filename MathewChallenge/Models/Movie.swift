//
//  Movie.swift
//  MathewChallenge
//
//  Created by Mathew Ijidakinro on 4/22/22.
//

import Foundation

struct Movie: Decodable {
    
    let overview: String?
    let originalTitle: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case overview
        case originalTitle = "original_title"
        case posterPath = "poster_path"
    }
}
