//
//  NowPlayingTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/2/23.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import Kingfisher



class NowPlayingTableViewCell: UITableViewCell {
    
    weak var delegate: selectedCollectionItemDelegate?
    
    var fetchResultData = [MovieDetailData]()
    let cellScale: CGFloat = 0.6

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        /*
        // 取得畫面的寬和高
        let screenSize = UIScreen.main.bounds.size
        // floor() 是取整數函式
        let cellWidth = floor(screenSize.width * cellScale)
        let cellHeight = floor(screenSize.height * cellScale)
        let insetX = (contentView.bounds.width - cellWidth ) / 2.0
        let insetY = (contentView.bounds.height - cellHeight) / 2.0
        
        let layout = myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        myCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        */
        
        let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = (UIScreen.main.bounds.width) - 100.0
        let height = width / 1.4
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // 約束CollectionView的高度條件
        myCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        myCollectionView.reloadData()
        
    }

}

extension NowPlayingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    // MARK: - Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "nowPlayingCollectionCell", for: indexPath) as! NowPlayingCollectionViewCell
        
        if let backdropPath = fetchResultData[indexPath.row].backdrop_path {
            let backdropPathURL = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            cell.imageView.kf.setImage(with: backdropPathURL, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        } else {
            cell.imageView.image = UIImage(named: "filmPlaceholder_gary")
        }
        cell.movieTitle.text = fetchResultData[indexPath.row].title
        
        return cell
    }
    
    // MARK: - 告訴委託人用戶何時完成內容滾動
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.myCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // cell的寬 + 間距
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        // roud() 將小數取整數, 超過0.5 整數+1
        let roundedIndex = round(index)
        
        offset = CGPoint(x: (roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left) - 30, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset 
        
    }
    
    // MARK: - Pass Data To MovieDetailViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let itemNum = indexPath.row
        delegate?.selectedCollectionItem(index: itemNum, fetchResultData: fetchResultData)
       
    }
    
    
}


