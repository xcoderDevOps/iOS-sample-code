//
//  AppDelegate.swift
//  SOS
//
//  Created by Alpesh Desai on 26/12/20.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SVProgressHUD
import GoogleMaps
import GooglePlaces
import FirebaseMessaging
import Firebase
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager : CLLocationManager?
    var location : CLLocation?
    var locationCompletionBlock : ((_ location : CLLocation)->())?
    var planData = PlanData()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        GMSServices.provideAPIKey(GooglePlaceKey)
        GMSPlacesClient.provideAPIKey(GooglePlaceKey)
        
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        registerForPushNotifications()
        
        DispatchQueue.main.async {
            self.checkAppNewVersionAndShowAlertForUpdate()
        }
        
//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
//                print(status)
//            })
//        }
        return true
    }
    
    func checkAppNewVersionAndShowAlertForUpdate() {
        if let harpy = Harpy.sharedInstance() {
            harpy.presentingViewController = self.window?.rootViewController
            harpy.delegate = self
            harpy.isDebugEnabled = true
            harpy.majorUpdateAlertType = .force
            harpy.minorUpdateAlertType = .option
            harpy.patchUpdateAlertType = .skip
            harpy.revisionUpdateAlertType = .skip
            harpy.checkVersion()
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone{
            return UIInterfaceOrientationMask.portrait
        } else {
            return UIInterfaceOrientationMask.all
        }
    }
    
    func setupLocationManager(_ locationCompletionBlock : ((_ location : CLLocation)->())?) {
        locationManager = CLLocationManager()
        self.locationCompletionBlock = locationCompletionBlock
        if let loc = locationManager {
            loc.desiredAccuracy = kCLLocationAccuracyHundredMeters
            loc.pausesLocationUpdatesAutomatically = true
            loc.showsBackgroundLocationIndicator = true
            loc.delegate = self
            if loc.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                loc.requestWhenInUseAuthorization()
            } else {
                loc.startUpdatingLocation()
            }
            loc.startUpdatingLocation()
        }
    }

    func registerForPushNotifications() {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            // Enable or disable features based on authorization.
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
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
        let container = NSPersistentContainer(name: "SOS")
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

}


extension AppDelegate {
    func gotToDashBoardView() {
       for obj in self.window!.subviews {
           obj.removeFromSuperview()
       }
    
       let nav = MainBoard.instantiateViewController(withIdentifier: "KYDrawerController") as? KYDrawerController
       self.window?.rootViewController = nav
       self.window?.makeKeyAndVisible()
   }
       
    func gotToSigninView() {
        UserInfo.clearUser()
        UIApplication.shared.applicationIconBadgeNumber = 0
        for obj in self.window!.subviews {
            obj.removeFromSuperview()
        }
        let nav = LoginBord.instantiateViewController(withIdentifier: "NavLoginVC")
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
//    func gotToPlanSelection() {
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        for obj in self.window!.subviews {
//            obj.removeFromSuperview()
//        }
//        let nav = MainBoard.instantiateViewController(withIdentifier: "NavPlanSelect")
//        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
//    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                if let loc = locationManager {
                    loc.startUpdatingLocation()
                }
            }
            else {
                if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
                    let title = "Location services are off" //?  : "Background location is not enabled"
                    let message = "To use background location you must turn on 'Always' in the Location Services Settings"
                    alertShow(title: title, message: message, okStr: "Setting", cancelStr: "Cancel", okClick: {
                        if let url = NSURL(string:UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        }
                    }, cancelClick: nil)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if let loc = locationManager {
                loc.startUpdatingLocation()
            }
        }else {
            if status == .denied || status == .restricted {
                let title = "Location services are off" //?  : "Background location is not enabled"
                let message = "To use background location you must turn on 'Always' in the Location Services Settings"
                alertShow(title: title, message: message, okStr: "Setting", cancelStr: "Cancel", okClick: {
                    if let url = NSURL(string:UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                    }
                }, cancelClick: nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last! as CLLocation
        if let loc = location, locationCompletionBlock != nil {
            self.locationCompletionBlock!(loc)
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification.request.content.userInfo
        DispatchQueue.main.async {
            if let data = notification as? [String:Any] {
                self.getNotification(data)
            }
            
        }
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let notification = notification.request.content.userInfo
        DispatchQueue.main.async {
            if let data = notification as? [String:Any] {
                self.getNotification(data)
            }
        }
        completionHandler(.badge)
    }
    
    func getNotification(_ dict:[String:Any]) {
       if let apns = dict["aps"] as? [String:AnyObject] {
            if let alert = apns["alert"] as? [String:AnyObject], let title = alert["title"] as? String, let body = alert["body"] as? String {
                let notiData = HDNotificationData(
                iconImage: UIImage(named: "logo"),
                appTitle: "My Watchman",
                title: title,
                message: body,
                time: "")
                HDNotificationView.show(data: notiData, onTap: {
                    
                }, onDidDismiss: nil)
                
            }
        }
    }
}

// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //setDeviceToken(fcmToken)
    }
}

extension AppDelegate : HarpyDelegate {
}
