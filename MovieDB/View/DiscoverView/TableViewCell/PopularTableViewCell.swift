//
//  PopularTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/2/24.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

protocol selectedCollectionItemDelegate: class {
    func selectedCollectionItem(index: Int, fetchResultData: [MovieDetailData])
}

class PopularTableViewCell: UITableViewCell {

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        myCollectionView.reloadData()
    }

}


extension PopularTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    // MARK: - Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "popularCollectionCell", for: indexPath) as! PopularCollectionViewCell
        
        if let posterPath = fetchResultData[indexPath.row].poster_path {
            let posterPathURL = URL(string: "https://image.tmdb.org/t/p/w780" + posterPath)
            cell.imageView.kf.setImage(with: posterPathURL, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        } else {
            cell.imageView.image = UIImage(named: "placeholder")
            cell.imageView.contentMode = .scaleAspectFit
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




