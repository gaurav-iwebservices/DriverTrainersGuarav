//
//  AppDelegate.swift
//  Driving Trainers
//
//  Created by iWeb on 12/18/17.
//  Copyright © 2017 iWeb. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import GoogleSignIn
import Google
import IQKeyboardManagerSwift
import NotificationBannerSwift
import NVActivityIndicatorView
import SwiftyJSON
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    
    var window: UIWindow?
    let gcmMessageIDKey = "AIzaSyCXhEFFS1Kkp540boHWNsvfkZGG11LvHeg"
   // let spm = SharedPref()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = true
        self.createDatabase()
        
        //FireBase
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
        FIRApp.configure()
        FIRMessaging.messaging().remoteMessageDelegate = self
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        
        //Facebook Login
         FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Initialize Google sign-in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
   // Facebook Login Delegate
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        // Add any custom logic here.
        return handled
    }
    
    // Google Login Delegate
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name!
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email!
            // ...
            print(fullName, givenName, familyName, email)
            
            
            var dataDict:[String:String] =  [
                "firstname": givenName!,
                "lastname": familyName!,
                "email": email,
                "socialkey":"1", // [1=google,2=facebook]":""
                "socialid": userId!,
                "role": TrainerProfile.UserType // [2=trainer,3=learner]
            ]
            self.socialAction(data: dataDict)
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    func socialAction(data:[String:String]) {
        
        if Reachability.isConnectedToNetwork() == false {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        
        print(data)
        DataProvider.sharedInstance.getDataUsingPost(path: Defines.ServerUrl + Defines.socialLoginAPI, dataDict: data, { (json) in
            print(json)
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
            if json["status"].stringValue == "True" {
                self.afterLoginAction(json: json)
                let banner = NotificationBanner(title: "Confirmation", subtitle: json["message"].stringValue , style: .success)
                banner.show(queuePosition: .front)
            }else if json["status"].stringValue == "False" {
                let banner = NotificationBanner(title: "Alert", subtitle: json["message"].stringValue , style: .danger)
                banner.show(queuePosition: .front)
            }
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            print(error)
        }
        
    }
    
    func afterLoginAction(json:JSON){
        
        if json["status"].stringValue == "True" {
            UserData.firstName = json["data"][0]["fname"].stringValue
            UserData.lastName = json["data"][0]["lname"].stringValue
            UserData.email = json["data"][0]["email"].stringValue
            UserData.Id = json["data"][0]["id"].stringValue
            UserData.role = json["data"][0]["role"].stringValue
            UserData.socialId = json["data"][0]["social_id"].stringValue
            UserData.socialKey = json["data"][0]["social_key"].stringValue
            UserData.userStatus = json["data"][0]["status"].stringValue
            UserData.userName = json["data"][0]["username"].stringValue
            
            UserDefaults.standard.setValue(UserData.firstName, forKey: "firstName")
            UserDefaults.standard.setValue(UserData.lastName, forKey: "lastName")
            UserDefaults.standard.setValue(UserData.email, forKey: "email")
            UserDefaults.standard.setValue(UserData.Id, forKey: "Id")
            UserDefaults.standard.setValue(UserData.role, forKey: "role")
            UserDefaults.standard.setValue(UserData.socialId, forKey: "socialId")
            UserDefaults.standard.setValue(UserData.socialKey, forKey: "socialKey")
            UserDefaults.standard.setValue(UserData.userStatus, forKey: "userStatus")
            UserDefaults.standard.setValue(UserData.userName, forKey: "userName")
            UserDefaults.standard.setValue("", forKey: "ImgPath")
            UserDefaults.standard.setValue("yes", forKey: "login")
            
           // if UserData.userStatus == "1" {
                
                if UserData.role == "2" {
                    
                    let storyBoard = UIStoryboard(name: "Trainer", bundle: nil) as UIStoryboard
                    let mfSideMenuContainer = storyBoard.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
                    let dashboard = storyBoard.instantiateViewController(withIdentifier: "Dashboard_VC") as! UINavigationController
                    let leftSideMenuController = storyBoard.instantiateViewController(withIdentifier: "TrainerRoot_VC_id") as! TrainerRoot_VC
                    mfSideMenuContainer.leftMenuViewController = leftSideMenuController
                    mfSideMenuContainer.centerViewController = dashboard
                    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = mfSideMenuContainer
                    
                }else{
                    let storyBoard = UIStoryboard(name: "Learner", bundle: nil) as UIStoryboard
                    let storyBoard1 = UIStoryboard(name: "Trainer", bundle: nil) as UIStoryboard
                    
                    let mfSideMenuContainer = storyBoard1.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
                    let dashboard = storyBoard.instantiateViewController(withIdentifier: "LearnerRoot_id") as! UINavigationController
                    let leftSideMenuController = storyBoard.instantiateViewController(withIdentifier: "LearnerRoot_VC_id") as! LearnerRoot_VC
                    mfSideMenuContainer.leftMenuViewController = leftSideMenuController
                    mfSideMenuContainer.centerViewController = dashboard
                    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = mfSideMenuContainer
                }
           // }
        }
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    // firebase
   
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("ddd\(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    // [START refresh_token]
    @objc func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            
            print("InstanceID token: \(refreshedToken)")
            
            
           // spm.setFcmToken(password: refreshedToken)
            
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(String(describing: error))")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the InstanceID token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
    }
    
    // [START connect_on_active]
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFcm()
    }
    // [END connect_on_active]
    // [START disconnect_from_fcm]
    func applicationDidEnterBackground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
    }
    // [END disconnect_from_fcm]

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    func saveSuburbOffline(json:JSON) {
        if json["status"].stringValue == "True" {
            
            let databasePath = UserDefaults.standard.url(forKey: "DataBasePath")!
            let contactDB = FMDatabase(path: String(describing: databasePath))
            
            if (contactDB?.open())! {
                let querySQL = "DELETE FROM Suburb "
                _ = contactDB!.executeUpdate(querySQL, withArgumentsIn: nil)
                for i in 0 ..< json["data"].arrayValue.count {
                    let insertSQL = "INSERT INTO Suburb (ID,name,urbanArea,stateCode,state,postCode,type) VALUES ('\(json["data"][i]["id"].stringValue)', '\(json["data"][i]["name"].stringValue)','\(json["data"][i]["urban_area"].stringValue)', '\(json["data"][i]["state_code"].stringValue)', '\(json["data"][i]["state"].stringValue)', '\(json["data"][i]["postcode"].stringValue)', '\(json["data"][i]["type"].stringValue)')"
                    let result = contactDB?.executeUpdate(insertSQL , withArgumentsIn: nil)
                    
                    if !result! {
                        print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                    }
                }
            } else {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
            //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    
    func saveStateOffline(json:JSON)  {
        if json["status"].stringValue == "True" {
            
            let databasePath = UserDefaults.standard.url(forKey: "DataBasePath")!
            let contactDB = FMDatabase(path: String(describing: databasePath))
            
            if (contactDB?.open())! {
                let querySQL = "DELETE FROM State "
                _ = contactDB!.executeUpdate(querySQL, withArgumentsIn: nil)
                for i in 0 ..< json["data"].arrayValue.count {
                    let insertSQL = "INSERT INTO State (ID,name,urbanArea,stateCode,state,postCode,type) VALUES ('\(json["data"][i]["id"].stringValue)', '\(json["data"][i]["name"].stringValue)','\(json["data"][i]["urban_area"].stringValue)', '\(json["data"][i]["state_code"].stringValue)', '\(json["data"][i]["state"].stringValue)', '\(json["data"][i]["postcode"].stringValue)', '\(json["data"][i]["type"].stringValue)')"
                    let result = contactDB?.executeUpdate(insertSQL , withArgumentsIn: nil)
                    
                    if !result! {
                        print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                    }
                }
                
                UserDefaults.standard.setValue("yes", forKey: "stateApi")
            } else {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
    }
    }
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Driving_Trainers")
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
    
    func createDatabase(){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let databasePath = documentsURL.appendingPathComponent("DriverTrainer.sqlite")
        
        let filemgr = FileManager.default
        print(databasePath)
        
        UserDefaults.standard.set(databasePath, forKey:"DataBasePath")
        UserDefaults.standard.synchronize()
        
        
        if !filemgr.fileExists(atPath: String(describing: databasePath)) {
            
            let contactDB = FMDatabase(path: String(describing: databasePath))
            
            if contactDB == nil {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
            
            if (contactDB?.open())! {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS Suburb (ID INTEGER PRIMARY KEY, name TEXT , urbanArea TEXT, stateCode TEXT , state Text, postCode TEXT , type Text)"
                if !(contactDB?.executeStatements(sql_stmt))! {
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                }
                
                let sql_stmt1 = "CREATE TABLE IF NOT EXISTS State (ID INTEGER PRIMARY KEY, name TEXT , urbanArea TEXT, stateCode TEXT , state Text, postCode TEXT , type Text)"
                if !(contactDB?.executeStatements(sql_stmt1))! {
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                }
                contactDB?.close()
            } else {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
        }
    }
    

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("aaa\(userInfo)")
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
    }
    //when we click on notificaiton
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print("bbb\(userInfo)")
        //
        //Code to be executed when you click notification
        
        //
        completionHandler()
    }
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}

