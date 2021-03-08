//
//  VideoTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/16.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var playerView: YTPlayerView! {
        didSet {
            playerView.layer.cornerRadius = 10
            playerView.clipsToBounds = true
        }
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
