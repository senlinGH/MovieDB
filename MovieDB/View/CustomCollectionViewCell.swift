//
//  CustomCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/16.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviesImage: UIImageView! {
        didSet {
            moviesImage.layer.cornerRadius = 10
            moviesImage.clipsToBounds = true
        }
    }
    
    
    
}
