//
//  OverviewViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/1/7.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import Kingfisher

class OverviewViewController: UIViewController {

    @IBOutlet weak var navigatinBar: UINavigationBar!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    
    var movieTitle = ""
    var posterPathURL = ""
    var overview = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigatinBar.topItem?.title = movieTitle
        backgroundImageView.kf.setImage(with: URL(string: posterPathURL), placeholder: nil, options: [.transition(.fade(0.1))])
        backgroundImageView.contentMode = .scaleAspectFill
        setupBlurEffectImageView()  // 建立模糊效果的背景圖片
        overviewTextView.text = overview
        
    }
    
    // MARK: - 建立模糊效果的背景圖片
    fileprivate func setupBlurEffectImageView() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }

    

}
