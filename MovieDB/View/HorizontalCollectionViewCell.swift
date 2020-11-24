//
//  HorizontalCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/24.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var horizontalImageView: UIImageView! {
        didSet {
            horizontalImageView.layer.cornerRadius = 10
            horizontalImageView.clipsToBounds = true
        }
    }
}
