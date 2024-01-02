// Test
//  DashTabBarVC.swift
//  ClickShare
//
//  Created by LN-iMAC-001 on 20/04/18.
//  Copyright © 2018 LetsNurture. All rights reserved.
//

import UIKit


var dashTabVC : DashTabBarVC?

class DashTabBarVC: UITabBarController,UITabBarControllerDelegate
{
    var rightBar: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dashTabVC = self as DashTabBarVC
        
        //tabBar.tintColor = UIColor.white
        self.delegate = self
        self.selectedIndex = 0
        
        //tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        title = nil
        
        //UITabBar.appearance().layer.borderWidth = -1.0
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        
        rightBar = UIBarButtonItem(image: UIImage(systemName: "bell"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(tapToOpenNotification))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        
        leftMenuButton()
        if let info = UserInfo.savedUser() {
            if info.UserType == 2 {
                viewControllers?.remove(at: 2)
            }
        }
        
        if let info = UserInfo.savedUser() {
            self.callGetUserData(baseURL+URLS.GetCustomerById.rawValue+"\(info.Id)") { (info) in
                if let info = info {
                    info.save()
                }
            }
        }
    }
    
    @objc func tapToOpenNotification() {
        let controll = MainBoard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.tabBar.itemPositioning = .fill
    }
    
    func setupTitle() {
        switch selectedIndex {
        case 0:
            title = "Need Help"
        case 1:
            title = "SOS History"
        case 2:
            title = "Emergency Contacts"
        case 3:
            title = "My Address"
        case 4:
            title = "My Profile"
        default:
            break
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        //tabBarItem.badgeColor = #colorLiteral(red: 0.2769611478, green: 0.3201989532, blue: 0.3351454437, alpha: 1)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setupTitle()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
