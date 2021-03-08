//
//  PosterTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/6.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

class PosterTableViewCell: UITableViewCell {
   
    @IBOutlet weak var posterView: UIView! {
        didSet {
            posterView.layer.cornerRadius = 10
            posterView.clipsToBounds = true
        }
    }
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel! {
        didSet { overviewLabel.textColor = UIColor.systemGray }
    }
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var voteCount: UILabel! {
        didSet { voteCount.textColor = UIColor.systemGray }
    }
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var AllGenres = [GenresInfo]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        // 關掉collection滑動的bar
        collectionView.showsHorizontalScrollIndicator = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        collectionView.reloadData()
    }

}

extension PosterTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return AllGenres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genresCell", for: indexPath) as! movieGenresCollectionViewCell
        
        if let genres = AllGenres[indexPath.row].name {
            cell.genresLabel.text = genres
        }
        
        return cell
        
    }
    
    
}
