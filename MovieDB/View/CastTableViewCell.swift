//
//  CastTableViewCell.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/25.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import Kingfisher

protocol selectedCastAndCrewCollectionItemDelegate: class {
    func selectedCollectionItem(name: String, personID: Int, cellIdentifier: String, job: String)
}

class CastTableViewCell: UITableViewCell {
    
    var cast = [CastDetail]()
    let cellIdentifier = "cast"
    weak var delegate: selectedCastAndCrewCollectionItemDelegate?

    @IBOutlet weak var castCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        castCollectionView.reloadData()
    }

}

extension CastTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCollectionViewcell", for: indexPath) as! CastCollectionViewCell
        var castProfilePath = ""
        var castName = ""
        var characterName = ""
        
        // 演員個人照
        if let castProfilePath_Temp = cast[indexPath.row].profile_path {
            castProfilePath = castProfilePath_Temp
        } else { castProfilePath = ""}
        
        // 演員名字
        if let castName_Temp = cast[indexPath.row].name {
            castName = castName_Temp
        } else { castName = "無演員名字" }
        
        // 角色名稱
        if let characterName_Temp = cast[indexPath.row].character {
            characterName = characterName_Temp
        } else { characterName = "無角色名稱" }
        
        // 下載演員個人照
        let castProfilePathArrImageURL = URL(string: "https://image.tmdb.org/t/p/w154\(castProfilePath)")
        cell.castImage.kf.setImage(with: castProfilePathArrImageURL, placeholder: UIImage(named: "profile"), options: [.transition(.fade(0.7))], progressBlock: nil)
        
        cell.castNameLbl.text = castName
        cell.roleNameLbl.text = characterName
        
        return cell
    }
    
    // MARK: - Pass Data To MovieDetailViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.selectedCollectionItem(name: cast[indexPath.row].name ?? "", personID: cast[indexPath.row].id, cellIdentifier: cellIdentifier, job: "")
    }
    
    
}
