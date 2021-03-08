//
//  CrewTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/26.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import Kingfisher

class CrewTableViewCell: UITableViewCell {

    var crewImageArr = [String]()
    var crewNameArr = [String]()
    var crewJobArr = [String]()
    
    @IBOutlet weak var crewCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        crewCollectionView.delegate = self
        crewCollectionView.dataSource = self
        crewCollectionView.reloadData()
    }

}

extension CrewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return crewImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = crewCollectionView.dequeueReusableCell(withReuseIdentifier: "crewCollectionViewcell", for: indexPath) as! CrewCollectionViewCell
        
        // 下載演員個人照
        let castProfilePathArrImageURL = URL(string: "https://image.tmdb.org/t/p/w154\(crewImageArr[indexPath.row])")
        cell.crewImage.kf.setImage(with: castProfilePathArrImageURL, placeholder: UIImage(named: "profile"), options: [.transition(.fade(0.7))], progressBlock: nil)
        // 名字
        cell.crewNameLbl.text = crewNameArr[indexPath.row]
        switch crewJobArr[indexPath.row] {
        case "Director":
            cell.JobTitleLbl.text = "導演"
        case "Producer":
            cell.JobTitleLbl.text = "監製"
        case "Screenplay":
            cell.JobTitleLbl.text = "編劇"
        case "Writer":
            cell.JobTitleLbl.text = "編劇"
        default:
            print("職業錯誤")
        }
        return cell
    }
    
    
}
