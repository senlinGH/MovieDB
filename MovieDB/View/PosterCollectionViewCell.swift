//
//  PosterCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/12/13.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView! {
        didSet {
            
            let lowestWidthPixelOfIpad: CGFloat = 1500
            let screenPixelWidth = UIScreen.main.nativeBounds.width    // nativeBounds 以 pixel 為單位
            if screenPixelWidth > lowestWidthPixelOfIpad {
                cellView.backgroundColor = .tertiarySystemFill
                cellView.layer.cornerRadius = 20
                
                // 加入陰影
                cellView.layer.shadowColor = UIColor.black.cgColor
                cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
                cellView.layer.shadowOpacity = 0.8
                cellView.layer.shadowRadius = 5
            } else {
                cellView.backgroundColor = .tertiarySystemFill
                cellView.layer.cornerRadius = 10
                
                // 加入陰影
                cellView.layer.shadowColor = UIColor.label.cgColor
                cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
                cellView.layer.shadowOpacity = 0.8
                cellView.layer.shadowRadius = 5
            }
            
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let lowestWidthPixelOfIpad: CGFloat = 1500
            let screenPixelWidth = UIScreen.main.nativeBounds.width    // nativeBounds 以 pixel 為單位
            
            if screenPixelWidth > lowestWidthPixelOfIpad {
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 20
                imageView.clipsToBounds = true
            }
            else {
                imageView.contentMode = .scaleAspectFill
                imageView.layer.cornerRadius = 10
                imageView.clipsToBounds = true
            }
        }
    }
}
