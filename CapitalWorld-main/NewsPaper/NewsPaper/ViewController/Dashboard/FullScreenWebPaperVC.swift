//
//  FullScreenWebPaperVC.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 16/12/21.
//

import UIKit
import WebKit

class FullScreenWebPaperVC: UIViewController {
    
    
    var filePath : String?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = filePath {
            self.webView.load(URLRequest(url: URL(fileURLWithPath: path)))
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapOnDownCLK(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
