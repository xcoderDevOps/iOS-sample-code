//
//  AppDelegate.swift
//  CargoXpress
//
//  Created by infolabh on 28/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SVProgressHUD
import Firebase
import FirebaseMessaging
import UserNotifications
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isFindService = false
//    var lat = "43.719884"
//    var long = "-79.445515"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForPushNotifications(application: application)
        
        GMSPlacesClient.provideAPIKey(GooglePlaceKey)
        
        return true
    }

    func registerForPushNotifications(application: UIApplication) {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // Enable or disable features based on authorization.
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CargoXpress")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func gotToDashBoardView() {
           for obj in self.window!.subviews {
               obj.removeFromSuperview()
           }
        var board :  UIStoryboard!
        if appDelegate.isFindService {
            board = MainBoard
        } else {
            board = DriverBoard
        }
        
           let nav = board.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController
           self.window?.rootViewController = nav
           self.window?.makeKeyAndVisible()
       }
       
       func gotToSigninView() {
           UIApplication.shared.applicationIconBadgeNumber = 0
           for obj in self.window!.subviews {
               obj.removeFromSuperview()
           }
           let nav = LoginBord.instantiateViewController(withIdentifier: "NavLoginVC") as? NavLoginVC
           self.window?.rootViewController = nav
           self.window?.makeKeyAndVisible()
       }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("--------------> \(deviceToken.hexString)")
        if deviceToken.hexString.count > 0 {
            Messaging.messaging().apnsToken = deviceToken
        }
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.badge)
    }
}

// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        setDeviceToken(fcmToken)
    }
}

