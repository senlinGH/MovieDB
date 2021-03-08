//
//  titleTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/5.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

class titleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel! {
        didSet { originalTitleLabel.textColor = UIColor.systemGray }
    }
    @IBOutlet weak var releaseDateLabel: UILabel! {
        didSet { releaseDateLabel.textColor = UIColor.systemGray }
    }
    @IBOutlet weak var certificationLabel: UILabel! {
        didSet {
            certificationLabel.textColor = UIColor.systemBackground
            certificationLabel.layer.borderColor = UIColor.systemGray.cgColor
            certificationLabel.layer.backgroundColor = UIColor.systemGray.cgColor
            certificationLabel.layer.borderWidth = 1.0
            certificationLabel.textAlignment = .center
            certificationLabel.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var runtimeLabel: UILabel! {
        didSet { runtimeLabel.textColor = UIColor.systemGray }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
