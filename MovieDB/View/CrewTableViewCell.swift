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

    var crew = [CrewDetail]()
    let cellIdentifier = "crew"
    weak var delegate: selectedCastAndCrewCollectionItemDelegate?
    
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
        return crew.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = crewCollectionView.dequeueReusableCell(withReuseIdentifier: "crewCollectionViewcell", for: indexPath) as! CrewCollectionViewCell
        
        var crewProfilePath = ""
        // 製作群個人照
        if let crewProfilePath_Temp = crew[indexPath.row].profile_path {
            crewProfilePath = crewProfilePath_Temp
        } else { crewProfilePath = ""}
        
        // 下載演員個人照
        let castProfilePathArrImageURL = URL(string: "https://image.tmdb.org/t/p/w154\(crewProfilePath)")
        cell.crewImage.kf.setImage(with: castProfilePathArrImageURL, placeholder: UIImage(named: "profile"), options: [.transition(.fade(0.7))], progressBlock: nil)
        
        // 名字
        if let name = crew[indexPath.row].name {
            cell.crewNameLbl.text = name
        }
        
        if let job = crew[indexPath.row].job {
            switch job {
            case "Director":
                cell.JobTitleLbl.text = "導演"
            case "Producer":
                cell.JobTitleLbl.text = "監製"
            case "Screenplay":
                cell.JobTitleLbl.text = "編劇"
            case "Writer":
                cell.JobTitleLbl.text = "編劇"
            default:
                fatalError("switch...case 職業錯誤")
            }
        }
        
        return cell
    }
    
    // MARK: - Pass Data To MovieDetailViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.selectedCollectionItem(name: crew[indexPath.row].name ?? "", personID: crew[indexPath.row].id, cellIdentifier: cellIdentifier, job: crew[indexPath.row].job ?? "")
    }
    
}
