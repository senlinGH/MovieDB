//
//  ViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/12.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class VerticalViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var vercitalCollectionView: UICollectionView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // vercitalCollectionView的委派和資料來源設定自己
        vercitalCollectionView.delegate = self
        vercitalCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = vercitalCollectionView.dequeueReusableCell(withReuseIdentifier: "verticalCollectionCell", for: indexPath) as! VerticalCollectionViewCell
        cell.verticalImageView.image = UIImage(named: movieData[indexPath.row])
        
        return cell
    }


}

