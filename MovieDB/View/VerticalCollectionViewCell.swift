//
//  MyCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/12.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class VerticalCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var verticalImageView: UIImageView! {
        didSet {
            verticalImageView.layer.cornerRadius = 10
            verticalImageView.clipsToBounds = true
        }
    }
}
