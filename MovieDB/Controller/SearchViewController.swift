//
//  SearchViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/28.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    var result = [MovieDetailData]()
    var searchController: UISearchController!
    var releaseDate = ""
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var emptyView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        tableview.delegate = self
        
        settingSearchController()
        // TableView的背景視圖為空視圖
        tableview.backgroundView = emptyView
        // 預設上設為隱藏
        tableview.backgroundView?.isHidden = true
        tableview.separatorStyle = .none    // 移除TableView的分隔符號
        tableview.keyboardDismissMode = .onDrag // TableView 滑動關閉鍵盤
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true   //啟用導覽列大標題
    }

    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result.count > 0 {
            tableView.backgroundView?.isHidden = true
        }
        else {
            tableView.backgroundView?.isHidden = false
        }
        
        return result.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        // 電影封面海報
                if let posterPath = result[indexPath.row].poster_path {
                    let posterPathImageURL = URL(string: "https://image.tmdb.org/t/p/w342" + posterPath)
                    cell.moviePosterImageView.kf.setImage(with: posterPathImageURL, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                }
        cell.titleLabel.text = result[indexPath.row].title
        
        let releaseDate = result[indexPath.row].release_date
        let voteAverage = result[indexPath.row].vote_average
        if releaseDate != "" {
            // 擷取字串1..4個字元
            let stringToIndex = releaseDate.index(releaseDate.startIndex, offsetBy: 4)
            let getStringToWord = String(releaseDate[..<stringToIndex])
            cell.detailsLbl.text = "\(getStringToWord) • \(voteAverage)/10"
        } else {
            cell.detailsLbl.text = "\(voteAverage)/10"
        }
        
        cell.overviewLbl.text = result[indexPath.row].overview
        cell.selectionStyle = .none //取消選取效果
        return cell
    }
    
   
    
    func settingSearchController() {
        // 實例化UISearchController, 回傳nil代表搜尋結果會顯示在我們正在搜尋的ViewController上
        searchController = UISearchController(searchResultsController: nil)
        // 告知searchController哪個物件負責更新我們搜尋的結果
        searchController.searchResultsUpdater = self
        // placeholder是在SearchBar沒有文字時，預設顯示的文字
        searchController.searchBar.placeholder = "搜尋電影..."
        searchController.obscuresBackgroundDuringPresentation = false
        // TableViewHeader加上SearchBar
        navigationItem.searchController = searchController
        // 滑動不隱藏搜尋欄
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text {
            result = []
            tableview.reloadData()
            searchData(query: text)
            print(result.count)
        }
    }
    
    // MARK: - Setup Search Data
    func searchData(query: String) {
        let apiKey = "fa36146a9c9339288ef9538e4bb1abb6"
        // 使用URLComponent才能解析繁體中文字
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.themoviedb.org"
        urlComponent.path = "/3/search/movie"
        urlComponent.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "zh-TW"),
            URLQueryItem(name: "region", value: "TW"),
            URLQueryItem(name: "query", value: query)
        ]
        
        guard let url = urlComponent.url else {
            print("URL錯誤")
            return
        }
        

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let jsonResult = try JSONDecoder().decode(TmdbMovies.self, from: data)
                DispatchQueue.main.async {
                    self?.result = jsonResult.results
                    self?.tableview.reloadData()
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovieDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            if let indexPath = tableview.indexPathForSelectedRow {
                let MovieDetailVC = segue.destination as! MovieDetailViewController
                
                MovieDetailVC.data = result[indexPath.row]
            }
        }
    }


}
