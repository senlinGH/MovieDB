//
//  HorizontalCollectionViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/24.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class HorizontalCollectionViewController: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var categoryMovieLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // horizontalCollectionView的委派和資料來源設定自己
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        
        // CollectionView加上背景圖片
        horizontalCollectionView.backgroundView = UIImageView(image: UIImage(named: "collection_background"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    //MARK - HorizontalCollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = horizontalCollectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCollectionCell", for: indexPath) as! HorizontalCollectionViewCell
        cell.horizontalImageView.image = UIImage(named: movieData[indexPath.row])
        
        return cell
    }

}
