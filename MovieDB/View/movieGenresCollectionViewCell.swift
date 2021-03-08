//
//  movieGenresCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/19.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

class movieGenresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genresLabel: UILabel! {
        didSet {
            genresLabel.textColor = .systemGray
            genresLabel.tintColor = .systemGray
            genresLabel.layer.borderColor = UIColor.systemGray.cgColor
            genresLabel.layer.borderWidth = 1
            genresLabel.layer.cornerRadius = 5
        }
    }
    
}
