//
//  MainViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2020/11/16.
//  Copyright © 2020 Ethan. All rights reserved.
//

import UIKit

var MoviesData = [
    
    Movies(sectionType: "最受歡迎的電影", imageGallery: ["movie1", "movie2", "movie3", "movie4", "movie5", "movie6", "movie7", "movie8", "movie9", "movie10", "movie11", "movie12", "movie13", "movie14", "movie15", "movie16", "movie17", "movie18", "movie19", "movie20"]),
    Movies(sectionType: "評分最佳的影片", imageGallery: ["movie1", "movie2", "movie3", "movie4", "movie5", "movie6", "movie7", "movie8", "movie9", "movie10", "movie11", "movie12", "movie13", "movie14", "movie15", "movie16", "movie17", "movie18", "movie19", "movie20"]),
    Movies(sectionType: "即將在戲院上映", imageGallery: ["movie1", "movie2", "movie3", "movie4", "movie5", "movie6", "movie7", "movie8", "movie9", "movie10", "movie11", "movie12", "movie13", "movie14", "movie15", "movie16", "movie17", "movie18", "movie19", "movie20"]),
    Movies(sectionType: "奧斯卡最佳影片", imageGallery: ["movie1", "movie2", "movie3", "movie4", "movie5", "movie6", "movie7", "movie8", "movie9", "movie10", "movie11", "movie12", "movie13", "movie14", "movie15", "movie16", "movie17", "movie18", "movie19", "movie20"]),
    Movies(sectionType: "最佳票房", imageGallery: ["movie1", "movie2", "movie3", "movie4", "movie5", "movie6", "movie7", "movie8", "movie9", "movie10", "movie11", "movie12", "movie13", "movie14", "movie15", "movie16", "movie17", "movie18", "movie19", "movie20"]),
    Movies(sectionType: "熱門電影", imageGallery: ["movie1", "movie2", "movie3", "movie4", "movie5", "movie6", "movie7", "movie8", "movie9", "movie10", "movie11", "movie12", "movie13", "movie14", "movie15", "movie16", "movie17", "movie18", "movie19", "movie20"])
]


class MainViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MoviesData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MoviesData[section].sectionType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! CustomTableViewCell
        cell.myCollectionView.tag = indexPath.section
        
        return cell
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

   

}
