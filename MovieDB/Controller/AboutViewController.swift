//
//  AboutViewController.swift
//  MovieDB
//
//  Created by Lin Yi Sen on 2021/3/16.
//  Copyright © 2021 Ethan. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class AboutViewController: UIViewController {

    @IBAction func emailBtnAction(_ sender: UIButton) {
        sendEmail()
    }
    @IBAction func gitHubBtnAction(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/senlinGH") {
            UIApplication.shared.open(url)
        }
    }
    @IBOutlet weak var tmdbLogoeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tmdbLogoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var statementLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTMDBLogoConstraint()
        statementLbl.text = "此應用程式使用TMDB公開的API。\n嚴正聲明此應用程式不是TMDB認可的官方應用程式。"
    }
    
    fileprivate func setTMDBLogoConstraint() {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight <= 667 {
            tmdbLogoeTopConstraint.constant = 40
            tmdbLogoBottomConstraint.constant = 30
        }
    }


}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setSubject("聯絡 MovieDB 開發者") // 標題
            vc.setToRecipients(["Ethan.lin.office@gmail.com"])  // 收件人
            vc.setMessageBody("以下是我使用 MovieDB App 後的感想。", isHTML: false)    // 信件內容
            present(vc, animated: true)
        } else {
            guard let url = URL(string: "https://www.google.com") else { return }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true)
    }
    
}
