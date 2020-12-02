//
//  TableViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/24.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

var movieData = [ "movie1", "movie2", "movie3", "movie4", "movie5", "movie6", "movie7", "movie8", "movie9", "movie10", "movie11", "movie12", "movie13", "movie14", "movie15", "movie16", "movie17", "movie18", "movie19", "movie20" ]

var categoryMovies = ["上映中的電影", "熱門的電影", "即將在戲院上映", "評分最高的電影"]

class TableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView的委派和資料來源設定自己
        tableView.delegate = self
        tableView.dataSource = self
        // 設定導覽列大標題
        navigationController?.navigationBar.prefersLargeTitles = true
        // 移除TableView分隔線
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! HorizontalCollectionViewController
        cell.categoryMovieLabel.text = categoryMovies[indexPath.row]
        cell.selectionStyle = .none //取消cell被選取的狀態
        
        return cell
        
    }

    

}
