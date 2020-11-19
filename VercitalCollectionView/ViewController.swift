//
//  ViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/12.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var VercitalCollectionView: UICollectionView!
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MoviesData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = VercitalCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
        cell.imageView.image = UIImage(named: MoviesData[indexPath.row])
        
        return cell
        
    }
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }


}

