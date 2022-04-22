//
//  MovieCell.swift
//  MathewChallenge
//
//  Created by Mathew Ijidakinro on 4/22/22.
//

import UIKit

class MovieCell: UITableViewCell {

    static let identifier = String(describing: MovieCell.self)

    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    
    func configure(imgData: Data?, title: String?, overview: String?) {
        movieImageView.image = nil
        if let imgData = imgData {
            movieImageView.image = UIImage(data: imgData)
        }
        titleLabel.text = title
        overviewLabel.text = overview
    }
}
