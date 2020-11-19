//
//  CustomTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/16.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return MoviesData.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CustomCollectionViewCell
            cell.moviesImage.image = UIImage(named: MoviesData[indexPath.row])
            
            return cell
        }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        // CollectionView加上背景圖片
        myCollectionView.backgroundView = UIImageView(image: UIImage(named: "collection_background"))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
