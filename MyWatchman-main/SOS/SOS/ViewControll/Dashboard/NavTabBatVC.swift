//
//  NavTabBatVC.swift
//  SOS
//
//  Created by Alpesh Desai on 20/07/21.
//

import UIKit

class NavTabBatVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size:20)!, NSAttributedString.Key.foregroundColor:UIColor.white]
       
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.font:
        UIFont.boldSystemFont(ofSize: 20.0),
                                      .foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(named:"AccentColor")
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Do any additional setup after loading the view.
    }

}
