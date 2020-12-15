//
//  PosterCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/12/13.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let lowestWidthPixelOfIpad: CGFloat = 1500
            let screenPixelWidth = UIScreen.main.nativeBounds.width    // nativeBounds 以 pixel 為單位
            
            if screenPixelWidth > lowestWidthPixelOfIpad {
                imageView.layer.cornerRadius = 20
                imageView.clipsToBounds = true
            }
            else {
                imageView.layer.cornerRadius = 10
                imageView.clipsToBounds = true
            }
        }
    }
}
