//
//  HorizontalCollectionViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/24.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

var tmdbs = [TMDB_Info]()
var posters = [PosterPath]()
var posterList = [String]() //儲存電影海報的陣列
var pageNum = 1

class HorizontalCollectionViewController: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var horizontalCollectionView: UICollectionView!
    @IBOutlet weak var categoryMovieLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // horizontalCollectionView的委派和資料來源設定自己
        horizontalCollectionView.delegate = self
        horizontalCollectionView.dataSource = self
        
        // CollectionView加上背景圖片
        horizontalCollectionView.backgroundView = UIImageView(image: UIImage(named: "collection_background"))
        
        downloadPosters()   //下載海報
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    // MARK: - HorizontalCollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posterList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = horizontalCollectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCollectionCell", for: indexPath) as! HorizontalCollectionViewCell
        let tmdbList = posterList[indexPath.row]
        
        if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + tmdbList) {
            URLSession.shared.dataTask(with: imageURL) {
                (data, response, error) in
                if let newData = data {
                    DispatchQueue.main.async {
                        cell.horizontalImageView.image = UIImage(data:newData)
                    }
                }
            }.resume()  //啟動dataTask任務
        }
        
        return cell
    }
    
    

    // MARK: - DownloadPosters
    func downloadPosters() {
        
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
                    
                    if pageNum <= totalPages {
                        
                        var item = 0
                        while item < downloadPosterPaths.results.count {
                            if let singlePoster = downloadPosterPaths.results[item].poster_path {

                                posterList.append(singlePoster)
                                item += 1
                            }
                            else { item += 1 }  //如果該筆資料沒有海報也要+1
                        }
                        
                        DispatchQueue.main.async {
                            self.horizontalCollectionView.reloadData()
                        }
                        
                    }
                } catch {
                    print("do敘述內容錯誤")
                }
                print("電影海報共\(posterList.count)筆")
            }.resume()
        }
        
        
    }
    
    
    // MARK: - WillDisPlay
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = posterList.count - 1
        if indexPath.row == lastItem {
            pageNum += 1
            downloadPosters()
        }

    }
    
    
    
    
    
}
