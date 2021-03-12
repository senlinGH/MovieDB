//
//  CastAndCrewViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/3/9.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

class CastAndCrewViewController: UIViewController {

    @IBOutlet weak var castAndCrewCollectionView: UICollectionView!
    
    var data = [MovieDetailData]()
    var personID = 0
    var name = ""
    var cellIdentifier = ""
    var job = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        castAndCrewCollectionView.dataSource = self
        castAndCrewCollectionView.delegate = self
        
        setFlowLayout()
        fetchCastData(PersonID: personID)
        self.title = name  // 標題
    }
    
    // 抓個人檔案資料
    func fetchCastData(PersonID: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/person/\(PersonID)/movie_credits?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW") else { return }
                            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else if data != nil {
                DispatchQueue.main.async {
                    do {
                        let ResultData = try JSONDecoder().decode(MovieCreditsForPerson.self, from: data!)
                        
                        switch self.cellIdentifier {
                        case "cast":
                            // 篩選演員電影作品評論超過220筆的電影
                            for item in ResultData.cast {
                                guard let voteCount = item.vote_count else { return }
                                if voteCount >= 220 {
                                    self.data.append(item)
                                }
                            }
                        case "crew":
                            // 篩選演員電影作品評論超過220筆的電影
                            for item in ResultData.crew {
                                guard let voteCount = item.vote_count else { return }
                                guard let job = item.job else { return }
                                if voteCount >= 220 && job == self.job {
                                    self.data.append(item)
                                }
                            }
                        default:
                            fatalError("載入人物電影作品清單錯誤！！！")
                        }
                        self.castAndCrewCollectionView.reloadData()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }

}

extension CastAndCrewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = castAndCrewCollectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterCollectionViewCell
        
        // 電影封面海報
        if let posterPath = data[indexPath.row].poster_path {
            let posterPathImageURL = URL(string: "https://image.tmdb.org/t/p/w342" + posterPath)

            cell.imageView.kf.setImage(with: posterPathImageURL, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        }
        
        return cell
    }
    
    // FlowLayout
    func setFlowLayout() {
        let sectionInsetSpace: CGFloat = 20  // 整個section上下左右的間距
        let columnCount: CGFloat = 3    // 每一列圖片數量
        let flowLayout = castAndCrewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        // 寬 = ( 螢幕的寬 - 兩邊section的間距40 ) / item的數量3
        let width = floor((UIScreen.main.bounds.width - (sectionInsetSpace * 2)) / columnCount)
        let height = floor(width * 1.5)
        
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = 10 // 每一列的上下間距
        flowLayout?.minimumInteritemSpacing = 0 //圖片之間的間距
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) //Section間的上下左右邊距
    }
    
    //MARK: - 長按選單預覽
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: indexPath.row as NSCopying, previewProvider: {
            
            guard let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return nil }
            
            let selectedMovie = self.data[indexPath.row]
            movieDetailVC.data = selectedMovie
            
            return movieDetailVC
        }) { action in
            
            let shareAction = UIAction(title: "分享", image: UIImage(systemName: "square.and.arrow.up")) {
                _ in
                
                let shareMovieURL = URL(string: "https://www.themoviedb.org/movie/\(self.data[indexPath.row].id)?language=zh-TW")
                
                let activityController: UIActivityViewController
                
                activityController = UIActivityViewController(activityItems: [shareMovieURL!], applicationActivities: nil)
                
                self.present(activityController, animated: true, completion: nil)
            }
            
            return UIMenu(title: "", children: [shareAction])
        }
        
        return configuration
        
    }
    
    // 呈現完整內容
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        
        guard let selectedItem = configuration.identifier as? Int else {
            print("未能檢索到項目號碼")
            return
        }
        
        guard let movieDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
        
        let selectedMovie = self.data[selectedItem]
        movieDetailViewController.data = selectedMovie
        
        animator.preferredCommitStyle = .pop
        animator.addCompletion {
            self.show(movieDetailViewController, sender: self)
        }
    }
    
    // MARK: - Pass Data To MovieDetailViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = mainStoryBoard.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
        print(data[indexPath.row].title)
        destinationVC.data = data[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
       
    }
}
