//
//  NowPlayingViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/12/11.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    var nowPlayingArray = [String]()
    var pageNum = 1
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        nowPlayingCollectionView.delegate = self
        nowPlayingCollectionView.dataSource = self
        
        switchIPadOrIphone()    // 判斷iPhone或iPad調整圖片大小
        downloadNowPlayingMovies()  // 下載NowPlaying的電影海報
        
        navigationController?.navigationBar.prefersLargeTitles = true   //啟用導覽列大標題
        
        
        // 讓大標題向右移
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.layoutMargins.left = 37
        }
    }
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = nowPlayingCollectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterCollectionViewCell
        
        let posterPath = nowPlayingArray[indexPath.row]
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
        let flowLayout = nowPlayingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
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
        let flowLayout = nowPlayingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((UIScreen.main.bounds.width - (sectionInsetSpace * 2) - itemSpace) / columnCount)
        let height = floor(width * 1.5)
        
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = sectionInsetSpace
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: sectionInsetSpace, bottom: sectionInsetSpace, right: sectionInsetSpace)
    }
    
    // MARK: - 下載NowPlaying的電影海報
    func downloadNowPlayingMovies() {
            
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&page=\(pageNum)&region=TW")

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
                                self.nowPlayingArray.append(singlePoster)
                                item += 1
                            }
                            else { item += 1 }  //如果該筆資料沒有海報也要+1
                        }
                        DispatchQueue.main.async {
                            self.nowPlayingCollectionView.reloadData()
                        }
                    }
                } catch { print("do敘述內容錯誤") }
                print("電影海報共\(self.nowPlayingArray.count)筆")
            }.resume()
        }
    }

    // MARK: - 即將顯示畫面
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let lastItem = self.nowPlayingArray.count - 1
//        if indexPath.row == lastItem {
//            self.pageNum += 1
//            downloadNowPlayingMovies()
//        }
//    }
    
    
    
    
    
}
