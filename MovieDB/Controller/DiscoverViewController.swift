//
//  DiscoverViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/2/22.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit



class DiscoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    var popularData = [MovieDetailData]()
    var nowPlayingData = [MovieDetailData]()
    var topRateData = [MovieDetailData]()
    var upcomingData = [MovieDetailData]()
    
    let sliderImageArr = ["SliderImage1", "SliderImage2", "SliderImage3"]
    var timer: Timer?   //計時器
    var counter = 0 // 計數器
    var randomNumArr = [Int]()
    
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true

        myTableView.delegate = self
        myTableView.dataSource = self
        
        // 載入電影資料
        fetchPopularData(page: 1)
        fetchNowPlayingData(page: 1)
        fetchTopRateData(page: 1)
        fetchUpcomingData(page: 1)
        
        // 設定SliderCollectionViewFlowLayout
        setSliderCollectionViewFlowLayout()
        
        // 設定Page Control
        pageControl.numberOfPages = sliderImageArr.count
        pageControl.currentPage = 0
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        
    }
    

    // MARK: - Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = myTableView.dequeueReusableCell(withIdentifier: "popularCell", for: indexPath) as! PopularTableViewCell
            cell.fetchResultData = popularData
            cell.delegate = self
            return cell
        case 1:
            let cell = myTableView.dequeueReusableCell(withIdentifier: "nowPlayingCell", for: indexPath) as! NowPlayingTableViewCell
            cell.fetchResultData = nowPlayingData
            cell.delegate = self
            return cell
        case 2:
            let cell = myTableView.dequeueReusableCell(withIdentifier: "topRateCell", for: indexPath) as! TopRateTableViewCell
            cell.fetchResultData = topRateData
            cell.delegate = self
            return cell
        case 3:
        let cell = myTableView.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! UpcomingTableViewCell
        cell.fetchResultData = upcomingData
        cell.delegate = self
        return cell
        default:
            fatalError("Cell錯誤")
        }
        
        
    }
    
    
    
    
    // MARK: - Get Popular Movies
    func fetchPopularData(page: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&page=\(page)&region=TW") else { return }
                            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else if data != nil {
                DispatchQueue.main.async {
                    do {
                        let myData = try JSONDecoder().decode(TmdbMovies.self, from: data!)
                        
                        self.popularData.append(contentsOf: myData.results)
                        self.myTableView.reloadData()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - Get Now Playing Movies
    func fetchNowPlayingData(page: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&page=\(page)&region=TW") else { return }
                            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else if data != nil {
                DispatchQueue.main.async {
                    do {
                        let resultData = try JSONDecoder().decode(TmdbMovies.self, from: data!)
                        self.nowPlayingData.append(contentsOf: resultData.results)
                        self.myTableView.reloadData()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - Get Top Rate Movies
    func fetchTopRateData(page: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&page=\(page)&region=TW") else { return }
                            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else if data != nil {
                DispatchQueue.main.async {
                    do {
                        let resultData = try JSONDecoder().decode(TmdbMovies.self, from: data!)
                        self.topRateData.append(contentsOf: resultData.results)
                        self.myTableView.reloadData()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - Get Upcoming Movies
    func fetchUpcomingData(page: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW&page=\(page)&region=TW") else { return }
                            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else if data != nil {
                DispatchQueue.main.async {
                    do {
                        let resultData = try JSONDecoder().decode(TmdbMovies.self, from: data!)
                        self.upcomingData.append(contentsOf: resultData.results)
                        self.myTableView.reloadData()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    
    

}

extension DiscoverViewController: selectedCollectionItemDelegate {
    func selectedCollectionItem(index: Int, fetchResultData: [MovieDetailData]) {
        print("Selected item \(index)")

        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = mainStoryBoard.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
                
        destinationVC.data = fetchResultData[index]
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! SliderCollectionCell
        cell.sliderImage.image = UIImage(named: sliderImageArr[indexPath.row])
        
        return cell
    }
    
    
    func setSliderCollectionViewFlowLayout() {
        let layout = sliderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal    // 設定水平滑動
        
        // section與section之間的距離(如果只有一個section，可以想像成frame)
        layout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let screenWidth = UIScreen.main.bounds.width    // 取得螢幕寬度
        layout?.itemSize = CGSize(width: screenWidth, height: screenWidth / 1.7) // Cell的寬、高
        
        // 滑動方向為「垂直」的話即「上下」的間距;滑動方向為「平行」則為「左右」的間距
        layout?.minimumLineSpacing = 0
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        sliderCollectionView.showsHorizontalScrollIndicator = false //隱藏水平滑動bar
        
        // 動態調整HeaderView的高度
        myTableView.tableHeaderView?.frame.size.height = screenWidth / 1.7
        
    }
    
    @objc func changeImage() {
        if counter < sliderImageArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter = 1
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    // 離開畫面停止Timer
    // Timer 如同執行緒，若沒停止它的話，它是會一直在背景執行的。所以必須在離開畫面時去停止它。
    override func viewDidDisappear(_ animated: Bool) {
        //  將timer執行緒停止
        if self.timer != nil {
            self.timer?.invalidate() //停止timer的循環
        }
    }
    
    
    
    
    
}
