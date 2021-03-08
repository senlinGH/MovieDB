//
//  CrewCollectionViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/26.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

class CrewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var crewView: UIView! {
        didSet {
            crewView.layer.cornerRadius = 10
            crewView.clipsToBounds = true
            
            // 加入陰影
            crewView.layer.shadowColor = UIColor.black.cgColor
            crewView.layer.shadowOffset = CGSize(width: 0, height: 0)
            crewView.layer.shadowOpacity = 0.8
            crewView.layer.shadowRadius = 5
        }
    }
    
    @IBOutlet weak var crewImage: UIImageView! {
        didSet {
            crewImage.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var crewNameLbl: UILabel! 
    @IBOutlet weak var JobTitleLbl: UILabel!
}


