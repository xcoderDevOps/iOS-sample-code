//
//  HelpDetailVC.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 18/01/22.
//

import UIKit
import WebKit

class HelpDetailVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var titleLabel = ""
    var link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleLabel
        backButton()
        webView.load(URLRequest(url: URL(string: link)!))
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
