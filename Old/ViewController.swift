//
//  ViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/12.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let images = ["movie1", "movie2", "movie3", "movie4", "movie5", "movie6", "movie7", "movie8", "movie9", "movie10", "movie11", "movie12", "movie13", "movie14", "movie15", "movie16", "movie17", "movie18", "movie19", "movie20"]
    

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
        cell.imageView.image = UIImage(named: images[indexPath.row])
        
        return cell
        
    }
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }


}

