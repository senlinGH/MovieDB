//
//  UpcomingTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/2/22.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import Kingfisher

class UpcomingTableViewCell: UITableViewCell {
    
    weak var delegate: selectedCollectionItemDelegate?
    
    var fetchResultData = [MovieDetailData]()
    let cellScale: CGFloat = 0.6
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        setFlowLayout()
        
        
        // 取得畫面的寬和高
        //             let screenSize = UIScreen.main.bounds.size
        //             let cellWidth = floor(screenSize.width * cellScale)
        //             let cellHeight = floor(screenSize.height * cellScale)
        //             let insetX = (contentView.bounds.width - cellWidth ) / 2.0
        //             let insetY = (contentView.bounds.height - cellHeight) / 2.0
        //
        //             let layout = myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //             layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        //             myCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        myCollectionView.reloadData()
        
    }
    
}

extension UpcomingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    // MARK: - Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCollectionCell", for: indexPath) as! UpcomingCollectionViewCell
        
        if let posterPath = fetchResultData[indexPath.row].poster_path {
            let posterPathURL = URL(string: "https://image.tmdb.org/t/p/original" + posterPath)
            cell.imageView.kf.setImage(with: posterPathURL, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        } else {
            cell.imageView.image = UIImage(named: "filmPlaceholder_gary")
        }
        cell.movieTitle.text = fetchResultData[indexPath.row].title
        
        return cell
    }
    
    fileprivate func setFlowLayout() {
        let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = UIScreen.main.bounds.width
        let height = width * 1.5
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // 約束CollectionView的高度條件
        myCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    // MARK: - Pass Data To MovieDetailViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let itemNum = indexPath.row
        delegate?.selectedCollectionItem(index: itemNum, fetchResultData: fetchResultData)
        
    }
}
