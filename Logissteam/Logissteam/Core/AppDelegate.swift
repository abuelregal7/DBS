//
//  AppDelegate.swift
//  Logissteam
//
//  Created by Ahmed Abo Al-Regal on 19/08/2024.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import netfox
import FirebaseMessaging
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        
        //MARK: - Loading Fonts
        let fonts = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: nil)
        fonts?.forEach({ url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        })
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }else {
            // Fallback on earlier versions
        }
        
        #if Development
            print("Running Development Configuration")
            //MARK: - Handling App Shake for show response in Development
            NFX.sharedInstance().start()
        #elseif Test
            print("Running Test Configuration")
            //MARK: - Handling App Shake for show response in Test
            NFX.sharedInstance().start()
        #elseif Stage
            print("Running Stage Configuration")
            //MARK: - Handling App Shake for show response in Stage
            NFX.sharedInstance().start()
        #elseif Production
            print("Running Production Configuration")
        #endif
        
        NetworkMonitor.shared.startMonitoring()
        AppLocalizer.DoTheMagic()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor.black//().colorWithHexString(hexString: "A70751")
        IQKeyboardManager.shared.keyboardConfiguration.overrideAppearance = true
        IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = .init(title: "Done".localized)
        
        initWindow()
        
        return true
    }
    
    func initWindow() {
        UIApplication.setRoot(AuthVCBuilder.splash.viewController, animated: false)
    }
    
//    func handleForegroundPushNotification(userInfo: [AnyHashable: Any]) {
//        // Extract notification content from userInfo dictionary
//        // Example: Access custom data from the notification payload
//        
//        print(userInfo)
//        
//        guard let mobilePage = userInfo["mobilePage"] as? String else {
//            print("No mobilePage found in the userInfo")
//            return
//        }
//        
//        guard let refrenceToken = userInfo["reference_token"] as? String else {
//            print("No refrenceToken found in the userInfo")
//            return
//        }
//        
//        let dateResponse: [String: Any] = [
//            "Navigation": "success",
//            "mobilePage": mobilePage,
//            "referenceToken": refrenceToken
//        ]
//        NotificationCenter.default
//            .post(name: NSNotification.Name("handleNotificationCenterForegroundTap"),
//                  object: nil,
//                  userInfo: dateResponse)
//        
//    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Logissteam")
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

//extension AppDelegate {
//    func configureFireBase(application: UIApplication){
//        FirebaseApp.configure()
//        // [START set_messaging_delegate]
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
//            guard granted else { return }
//            UNUserNotificationCenter.current().getNotificationSettings { settings in
//                guard settings.authorizationStatus == .authorized else { return }
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            }
//        }
//        // [END register_for_notifications]
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        print(userInfo)
//    }
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print(userInfo)
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//    
//    // [END receive_message]
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Unable to register for remote notifications: \(error.localizedDescription)")
//    }
//    
//    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
//    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
//    // the FCM registration token.
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("APNs token retrieved: \(deviceToken)")
//        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        print(token)
//        // UserDefaultsConfig.saveFirebaseToken(token: deviceToken ?? "")
//        // With swizzling disabled you must set the APNs token here.
//        Messaging.messaging().apnsToken = deviceToken
//    }
//}
//
//// [START ios_10_message_handling]
//@available(iOS 10, *)
//extension AppDelegate : UNUserNotificationCenterDelegate {
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                    willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        
//        // Extract the userInfo dictionary from the notification content
//        guard let userInfo = notification.request.content.userInfo as? [String: Any] else {
//            print("No user info found in the notification")
//            return
//        }
//        print(userInfo)
//        // Change this to your preferred presentation options
//        completionHandler([.alert, .badge, .sound])
//        
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                    didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        // [START_EXCLUDE]
//        // Print message ID.
//        
//        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
//            print("No user info found in the notification")
//            return
//        }
//        print(userInfo)
//        
//        handleForegroundPushNotification(userInfo: userInfo)
//        completionHandler()
//    }
//    
//}
//
//extension AppDelegate : MessagingDelegate {
//    // [START refresh_token]
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(String(describing: fcmToken))")
//        UD.FCMToken = fcmToken
//    }
//}

