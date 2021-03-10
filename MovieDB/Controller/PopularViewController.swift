//
//  PopularViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/12/12.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit
import Kingfisher

class PopularViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    var totalPages = 1
    var currentPage = 1
    var data = [MovieDetailData]()
    var spinner = UIActivityIndicatorView()     // 建立旋轉指示器的物件
    var videoKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        
        switchIPadOrIphone()    // 判斷iPhone或iPad調整圖片大小
        fetchData(page: 1)
        // 讓大標題向右移
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.layoutMargins.left = 37
        }
        
        setSpinner() // 啟用旋轉指示器
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true   //啟用導覽列大標題
    }
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popularCollectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterCollectionViewCell
        
        // 電影封面海報
        if let posterPath = data[indexPath.row].poster_path {
            let posterPathImageURL = URL(string: "https://image.tmdb.org/t/p/w342" + posterPath)

            cell.imageView.kf.setImage(with: posterPathImageURL, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        }
        self.spinner.stopAnimating()    // 停止旋轉指示器動畫
        
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
        
        let sectionInsetSpace: CGFloat = 20  // 整個section上下左右的間距
        let columnCount: CGFloat = 3    // 每一列圖片數量
        let flowLayout = popularCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        // 寬 = ( 螢幕的寬 - 兩邊section的間距40 ) / item的數量3
        let width = floor((UIScreen.main.bounds.width - (sectionInsetSpace * 2)) / columnCount)
        let height = floor(width * 1.5)
        
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = 10 // 每一列的上下間距
        flowLayout?.minimumInteritemSpacing = 0 //圖片之間的間距
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) //Section間的上下左右邊距
    }
    
    // MARK: - iPhone自適應圖片大小
    func forIphoneAutoLayout() {
        
        let sectionInsetSpace: CGFloat = 20  // 整個section上下左右的間距
        let columnCount: CGFloat = 3    // 每一列圖片數量
        let flowLayout = popularCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        // 寬 = ( 螢幕的寬 - 兩邊section的間距40 ) / item的數量3
        let width = floor((UIScreen.main.bounds.width - (sectionInsetSpace * 2)) / columnCount)
        let height = floor(width * 1.5)
        
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumLineSpacing = 10 // 每一列的上下間距
        flowLayout?.minimumInteritemSpacing = 0 //圖片之間的間距
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) //Section間的上下左右邊距
    }
    
    // MARK: - 下拉加載更多
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPages && indexPath.row == data.count - 5 {
            currentPage += 1
            fetchData(page: currentPage)
        }
    }
    
    // MARK: - Get Popular Movies
    func fetchData(page: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&page=\(page)&region=TW") else { return }
                            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else if data != nil {
                DispatchQueue.main.async {
                    do {
                        let myData = try JSONDecoder().decode(TmdbMovies.self, from: data!)
                        self.totalPages = myData.total_pages
                        self.data.append(contentsOf: myData.results)
        //                self.spinner.stopAnimating()    // 停止旋轉指示器動畫
                        self.popularCollectionView.reloadData()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - 設置旋轉指示器
    func setSpinner() {
        spinner.style = .large     // 旋轉指示器大小樣式設定為大
        spinner.hidesWhenStopped = true // hidesWhenStopped屬性控制當動畫結束後是否隱藏指示器
        view.addSubview(spinner)
        
        // 這設定是告知iOS不要建立旋轉指示器視圖的自動佈局約束條件
        spinner.translatesAutoresizingMaskIntoConstraints = false
        // 建立佈局約束條件讓指示器水平置中，並設置在安全區域頂端的下方250點的位置
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        spinner.startAnimating()    //啟用旋轉指示器
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
        
        destinationVC.data = data[indexPath.row]
        navigationController?.pushViewController(destinationVC, animated: true)
       
    }
    

}



