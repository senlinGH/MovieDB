//
//  UpcomingCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/2/22.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

class UpcomingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView! {
        didSet {
            cellView.layer.cornerRadius = 10
            
            // 加入陰影
            cellView.layer.shadowColor = UIColor.label.cgColor
            // 陰影的偏移為正下方
            cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cellView.layer.shadowOpacity = 0.8
            cellView.layer.shadowRadius = 5
        }
    }
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var movieTitle: UILabel!
    
}
