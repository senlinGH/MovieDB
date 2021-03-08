//
//  CastCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/25.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView! {
        didSet {
            cellView.layer.cornerRadius = 10
            cellView.clipsToBounds = true
            
            // 加入陰影
            cellView.layer.shadowColor = UIColor.black.cgColor
            cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cellView.layer.shadowOpacity = 0.8
            cellView.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var castImage: UIImageView! {
        didSet {
            castImage.contentMode = .scaleAspectFill
            
        }
    }
    @IBOutlet weak var castNameLbl: UILabel!
    @IBOutlet weak var roleNameLbl: UILabel!
    
    
}
