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
