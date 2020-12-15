//
//  UpcomingViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/12/13.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class UpcomingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    var upcomingArray = [String]()
    var pageNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        
        switchIPadOrIphone()    // 判斷iPhone或iPad調整圖片大小
        downloadUpcomingMovies()  // 下載Upcoming的電影海報
        
        navigationController?.navigationBar.prefersLargeTitles = true   //啟用導覽列大標題
        
        
        // 讓大標題向右移
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.layoutMargins.left = 37
        }
    }
    

    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = upcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterCollectionViewCell
        
        let posterPath = upcomingArray[indexPath.row]
        if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + posterPath) {
            URLSession.shared.dataTask(with: imageURL) {
                (data, response, error) in
                if let newData = data {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(data:newData)
                    }
                }
            }.resume()  //啟動dataTask任務
        }
        
        return cell
    }
    
    // MARK: - 判斷iPhone或iPad選擇自適應圖片大小
    func switchIPadOrIphone() {
        
        let lowestWidthPixelOfIpad: CGFloat = 1500
        let screenPixelWidth = UIScreen.main.nativeBounds.width    // nativeBounds 以 pixel 為單位
        
        if screenPixelWidth > lowestWidthPixelOfIpad {
            forIpadAutoLayout()
        }
        else {
            forIphoneAutoLayout()
        }
    }
    
    // MARK: - iPad自適應圖片大小
    func forIpadAutoLayout() {
        
        let itemSpace: CGFloat = 40
        let sectionInsetSpace: CGFloat = itemSpace * 2
        let columnCount: CGFloat = 2
        let flowLayout = upcomingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((UIScreen.main.bounds.width - (sectionInsetSpace * 2) - itemSpace) / columnCount)
        let height = floor(width * 1.5)
        
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = sectionInsetSpace
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: sectionInsetSpace, bottom: 0, right: sectionInsetSpace)
    }
    
    // MARK: - iPhone自適應圖片大小
    func forIphoneAutoLayout() {
        
        let itemSpace: CGFloat = 20
        let sectionInsetSpace: CGFloat = itemSpace * 2
        let columnCount: CGFloat = 2
        let flowLayout = upcomingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((UIScreen.main.bounds.width - (sectionInsetSpace * 2) - itemSpace) / columnCount)
        let height = floor(width * 1.5)
        
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = sectionInsetSpace
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: sectionInsetSpace, bottom: sectionInsetSpace, right: sectionInsetSpace)
    }
    
    // MARK: - 下載Upcoming的電影海報
    func downloadUpcomingMovies() {
            
        let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&page=\(pageNum)&region=TW")

        if let downloadURL = url {
            URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
                guard let data = data, error == nil, urlResponse !== nil else {
                    print("電影海報下載錯誤")
                    return
                }
                print("電影海報下載完成")
                do {
                    let decoder = JSONDecoder()
                    let downloadPosterPaths = try decoder.decode(PosterPaths.self, from: data)
                    let totalPages = downloadPosterPaths.total_pages

                    if self.pageNum <= totalPages {
                        var item = 0
                        while item < downloadPosterPaths.results.count {
                            if let singlePoster = downloadPosterPaths.results[item].poster_path {
                                self.upcomingArray.append(singlePoster)
                                item += 1
                            }
                            else { item += 1 }  //如果該筆資料沒有海報也要+1
                        }
                        DispatchQueue.main.async {
                            self.upcomingCollectionView.reloadData()
                        }
                    }
                } catch { print("do敘述內容錯誤") }
                print("電影海報共\(self.upcomingArray.count)筆")
            }.resume()
        }
    }

}
