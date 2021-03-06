//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/4.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Kingfisher

class MovieDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headerImageView: UIImageView! {
        didSet {
            // 取得背景海報
            if let backdropPath_Key = data.backdrop_path {
                let backdropPathImageURL = "https://image.tmdb.org/t/p/w780\(backdropPath_Key)"
                headerImageView.kf.setImage(with: URL(string: backdropPathImageURL), placeholder: UIImage(named: "collection_background"), options: [.transition(.fade(0.3))], progressBlock: nil)
            } else {
                headerImageView.image = UIImage(named: "filmPlaceholder_gary")
                headerImageView.contentMode = .scaleAspectFill
            }
        }
    }
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var blurEffectHeaderView: UIView!
    @IBOutlet weak var headerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurEffectViewHeightConstraint: NSLayoutConstraint!
    
    
    var data: MovieDetailData!
    var AllGenres = [GenresInfo]()
    var cast = [CastDetail]()
    var crew = [CrewDetail]()
    var posterPathURL = ""
    var videoKey = ""
    var certification = "未經分級"
    var runtime = ""
    var spinner = UIActivityIndicatorView()     // 建立旋轉指示器的物件
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadDatas() // 下載資料
        setupTableView()    // TableView相關設定
        bulidGradientView() // 建立漸層的HeaderView
        blurEffectHeaderView.alpha = 0
        print("電影名稱：\(data.title)")
        
    }
    
    // 延伸漸層效果
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        gradientLayer.frame = headerImageView.bounds
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never   // 停用大標題
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! titleTableViewCell

            cell.titleLabel.text = data.title
            cell.originalTitleLabel.text = data.original_title + "(原始片名)"
            
            if let releaseDate = data.release_date {
                if releaseDate != "" {
                    // 擷取字串1..4個字元
                    let stringToIndex = releaseDate.index(releaseDate.startIndex, offsetBy: 4)
                    let getStringToWord = String(releaseDate[..<stringToIndex])
                    cell.releaseDateLabel.text = getStringToWord
                } else { cell.releaseDateLabel.text = "" }
            } else { cell.releaseDateLabel.text = "" }
            
            
            cell.certificationLabel.text = certification
            cell.runtimeLabel.text = runtime
            cell.selectionStyle = .none //取消選取效果
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "posterCell", for: indexPath) as! PosterTableViewCell
            
            if let posterPath_Key = data.poster_path {
                let posterPathURL = "https://image.tmdb.org/t/p/w342" + posterPath_Key
                cell.posterImageView.kf.setImage(with: URL(string: posterPathURL), placeholder: nil, options: [.transition(.fade(0.1))], progressBlock: nil)
                self.posterPathURL = posterPathURL  // 儲存給OverviewController的背景圖的URL
            } else {
                cell.posterImageView.image = UIImage(named: "filmPlaceholder_gary")
                cell.posterImageView.contentMode = .scaleAspectFill
            }
            
            if data.overview != "" {
                cell.moreBtn.isHidden = false
                cell.overviewLabel.text = data.overview
            }
            else {
                cell.moreBtn.isHidden = true
                cell.overviewLabel.text = "無劇情簡介"
            }
            
            
            cell.AllGenres = AllGenres
            cell.voteAverage.text = "⭐️ \(data.vote_average)"
            
            if let voteCount = data.vote_count {
                cell.voteCount.text = "評論\(voteCount)"
            }
            
            cell.selectionStyle = .none //取消選取效果
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
            if videoKey != "" {
                cell.playerView.load(withVideoId: videoKey)
            } else {
                print("沒預告")
            }
            cell.selectionStyle = .none //取消選取效果
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "castCell", for: indexPath) as! CastTableViewCell
            cell.cast = self.cast
            cell.selectionStyle = .none //取消選取效果
            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "crewCell", for: indexPath) as! CrewTableViewCell
            cell.crew = self.crew
            cell.selectionStyle = .none //取消選取效果
            cell.delegate = self
            return cell
        default:
            fatalError("無法實例化表查看單元格詳細信息視圖控制器")
        }
        
    }
    
    
    // MARK: - ScrollView | HeaderView滑動漸變
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let moveDistance = abs(scrollView.contentOffset.y)
        let contentOffsetY = scrollView.contentOffset.y
        let offset = contentOffsetY / 186
//        let titleStartPoint = contentOffsetY - 279
//        let titleOffset = titleStartPoint / 31
        
        if contentOffsetY > 0 {
            // 上滑圖片漸變
            blurEffectHeaderView.alpha = offset
            if offset > 1.50 {
                navigationItem.title = data.title
                // 標題的顏色設定
//                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: titleOffset)]
            } else { navigationItem.title = "" }
        } else {
            // 下滑放大
            headerImageHeightConstraint.constant = 210 + moveDistance
            blurEffectViewHeightConstraint.constant = 210 + moveDistance
        }
    }
    
    
    // MARK: - 建立漸層view物件
    fileprivate func bulidGradientView() {
        
        let layer = CAGradientLayer()
        let width = UIScreen.main.bounds.width
        layer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: 210.0)
        layer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        layer.locations = [0.8, 1]
        gradientView.layer.addSublayer(layer)
    }
    
    // MARK: - TableView相關設定
    fileprivate func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none    // 移除TableView的分隔符號
        tableview.showsVerticalScrollIndicator = false  // 關掉collection滑動的bar
        tableview.backgroundColor = .clear  // tableview背景顏色透明
    }
    
    // MARK: - 下載資料檔案
    fileprivate func downloadDatas() {
        getVideoKey(movieID: data.id)   // 取得電影預告的Key
        getMovieCertification(movieID: data.id) // 取得電影分級
        getMovieDetail(movieID: data.id)    // 取得電影詳細資料
        getCastAndCrew(movieID: data.id)
    }
    
    
    
    // MARK: - 取得電影預告
    
    func getVideoKey(movieID: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW")
        else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            else if data != nil {
                DispatchQueue.main.sync {
                    do {
                        let myData = try JSONDecoder().decode(MovieVideo.self, from: data!)
                        if myData.results != [] {   // 如果有資料
                            for item in myData.results {
                                // 如果資料的類型是Trailer
                                if item.size == 1080 && item.type == "Trailer" {
                                    self.videoKey = item.key
                                    self.tableview.reloadData()
                                } else if item.size == 720 && item.type == "Trailer" {
                                    self.videoKey = item.key
                                    self.tableview.reloadData()
                                }
                            }
//                            let key = myData.results[0].key
//                            self.videoKey = key
//                            self.tableview.reloadData()
                        }
                        // 否則找US預告的key
                        else {
                            self.getUS_MovieTrailer(movieID: movieID)
                        }
                    } catch let error { print(error.localizedDescription) }
                }
            }
        }.resume()
    }
    
    // MARK: - US預告
    func getUS_MovieTrailer(movieID: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=en-US")
        else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            else if data != nil {
                DispatchQueue.main.sync {
                    do {
                        let myData = try JSONDecoder().decode(MovieVideo.self, from: data!)
                        //  判斷有無預告片的key
                        if myData.results != [] {
                            for item in myData.results {
                                if item.size == 1080 && item.type == "Trailer" {
                                    self.videoKey = item.key
                                    self.tableview.reloadData()
                                } else if item.size == 720 && item.type == "Trailer" {
                                    self.videoKey = item.key
                                    self.tableview.reloadData()
                                } else if item.size == 480 && item.type == "Trailer" {
                                    self.videoKey = item.key
                                    self.tableview.reloadData()
                                } else if item.size == 360 && item.type == "Trailer" {
                                    self.videoKey = item.key
                                    self.tableview.reloadData()
                                }
                            }
                        } else { return }
                    } catch let error { print(error.localizedDescription) }
                }
            }
        }.resume()
    }
    // MARK: - 取得電影分級
    func getMovieCertification(movieID: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/release_dates?api_key=fa36146a9c9339288ef9538e4bb1abb6")
        else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if error != nil {
                            print(error.debugDescription)
                            return
                        } else if data != nil {
                            DispatchQueue.main.sync {
                                do {
                                    let myData = try JSONDecoder().decode(MovieCertification.self, from: data!)
                                    // TW 電影分級
                                    for item in myData.results {
                                        let certification = item.release_dates[0].certification
                                        if item.iso_3166_1 == "TW" && certification != "" {
                                            self.certification = certification
                                        }
                                    }
                                    self.tableview.reloadData()
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                    task.resume()
    }
    
    // MARK: - 取得電影時間長度、電影類別
    func getMovieDetail(movieID: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW")
            else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else if data != nil {
                DispatchQueue.main.sync {
                    do {
                        let myData = try JSONDecoder().decode(MovieDetail.self, from: data!)
                        // 電影時間長度
                        guard let runtime = myData.runtime else { return }
                        let hour = 60
                        // 同時得到商和餘數的方法
                        let result = runtime.quotientAndRemainder(dividingBy: hour)
                        self.runtime = "\(result.quotient)小時\(result.remainder)分鐘"
                        self.AllGenres = myData.genres
                        self.tableview.reloadData()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: - 取得電影卡司與團隊
    func getCastAndCrew(movieID: Int) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=fa36146a9c9339288ef9538e4bb1abb6&language=zh-TW")
            else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                return
            } else if data != nil {
                DispatchQueue.main.sync {
                    do {
                        let myData = try JSONDecoder().decode(CastAndCrew.self, from: data!)
                        self.cast = myData.cast
                        
                        // 只取得導演、監製、編劇的資料
                        for item in myData.crew {
                            if (item.job == "Director") || (item.job == "Producer") || (item.job == "Screenplay") || (item.job == "Writer") {
                                
                                self.crew.append(item)
                            }
                        }
                        self.tableview.reloadData()
                    } catch let error {
                        print(error.localizedDescription)
                        print("失敗")
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
    // MARK: - 設置旋轉指示器
    func setSpinner() {
        spinner.style = .large     // 旋轉指示器大小樣式設定為大
        spinner.hidesWhenStopped = true // hidesWhenStopped屬性控制當動畫結束後是否隱藏指示器
        view.addSubview(spinner)
        
        // 這設定是告知iOS不要建立旋轉指示器視圖的自動佈局約束條件
        spinner.translatesAutoresizingMaskIntoConstraints = false
        // 建立佈局約束條件讓指示器水平置中，並設置在安全區域頂端的下方290點的位置
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 290.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        spinner.startAnimating()    //啟用旋轉指示器
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOverview" {
            let destinationController = segue.destination as! OverviewViewController
            destinationController.movieTitle = data.title
            destinationController.posterPathURL = self.posterPathURL
            destinationController.overview = data.overview
        } 
        
    }
    
    // 回退Segue
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension MovieDetailViewController: selectedCastAndCrewCollectionItemDelegate {
    
    func selectedCollectionItem(name: String, personID: Int, cellIdentifier: String, job: String) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let VC = mainStoryBoard.instantiateViewController(identifier: "castAndCrewViewController") as! CastAndCrewViewController
        
        VC.name = name
        VC.personID = personID
        VC.cellIdentifier = cellIdentifier
        VC.job = job
        navigationController?.pushViewController(VC, animated: true)
    }
    
}
