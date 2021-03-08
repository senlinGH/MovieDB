//
//  SearchTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/28.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import Kingfisher

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellView: UIView! {
        didSet {
            cellView.layer.cornerRadius = 5
            cellView.clipsToBounds = true
        }
    }
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! 
    
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var overviewLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
