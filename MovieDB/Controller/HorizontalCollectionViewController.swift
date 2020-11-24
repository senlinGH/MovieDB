//
//  HorizontalCollectionViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/24.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

var TMDBs = [TMDB_Info]()
var posters = [PosterPath]()

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
        
        downloadJson()  //下載JSON api
        downloadPosters()   //下載海報
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    // MARK: - HorizontalCollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = horizontalCollectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCollectionCell", for: indexPath) as! HorizontalCollectionViewCell
        cell.horizontalImageView.image = UIImage(named: movieData[indexPath.row])
        
        return cell
    }
    
    // MARK: - URL
    final let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&page=1&region=TW")
    
    // MARK: - DownloadJASON
    func downloadJson() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse !== nil else {
                print("下載JSON錯誤")
                return
            }
            print("JSON下載完成")
            do {
                let decoder = JSONDecoder()
                let downloadTMDBs = try decoder.decode(TMDB.self, from: data)
                TMDBs = downloadTMDBs.results
//                print(TMDBs)
            } catch {
                print("下載JSON之後錯誤")
            }
        }.resume()
    }

    // MARK: - DownloadPosters
    func downloadPosters() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse !== nil else {
                print("電影海報下載錯誤")
                return
            }
            print("電影海報下載完成")
            do {
                let decoder = JSONDecoder()
                let downloadPosters = try decoder.decode(PosterPaths.self, from: data)
                print(downloadPosters.results[0].poster_path)
            } catch {
                print("電影海報下載之後錯誤")
            }
        }.resume()
    }
    
    
    
    
    
}
