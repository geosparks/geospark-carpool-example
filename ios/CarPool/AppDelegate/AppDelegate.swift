//
//  AppDelegate.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 25/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import GeoSpark
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GeoSparkDelegate,UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    var navigationController: UINavigationController = UINavigationController()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        Fabric.with([Crashlytics.self])
        
        if GeoSpark.isLocationTracking(){
            GeoSpark.stopTracking()
            GeoSpark.startTracking()
        }
        GMSServices.provideAPIKey(GOOGLE_SERVICES_KEY)
        GeoSpark.intialize(GEOSPARK_PUBLISH_KEY)
        GeoSpark.delegate = self
        GeoSpark.trackLocationInAppState([GSAppState.AlwaysOn])
        GeoSpark.trackLocationInMotion([GSMotion.All])
        GeoSpark.setLocationAccuracy(100)
        
        registerForPushNotifications()
        GeoSpark.requestMotion()
        GeoSpark.requestLocation()
        
        return true
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
    
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func registerForPushNotifications() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        GeoSpark.setDeviceToken(deviceToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        return completionHandler([.alert,.sound,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let responseDict = response.notification.request.content.userInfo as? [String:Any]
        Utils.storeNotiofication(responseDict!)
        let handler = NotificationHandler(fromDictionary: responseDict!)
        guard let type = handler.type
            else { return }
        if type == "origin"{
            SharedUtil.setDefaultBoolean(true, kTripRequest)
            SharedUtil.setDefaultString(handler.trip_id!, kTripId)
            SharedUtil.removeKey(kFromAddress)
            SharedUtil.removeKey(kToAddress)
            DispatchQueue.main.async {
                let vc = MyTripFindRideViewController.viewController()
                vc.tripId = handler.trip_id!
                vc.isNotification = true
                SharedUtil.setDefaultBoolean(true, kNotification)
                self.window?.rootViewController = vc
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }else if type == "destination" {
            SharedUtil.setDefaultBoolean(false, kTripRequest)
            SharedUtil.setDefaultBoolean(false, kTripStarted)
            SharedUtil.setDefaultString(handler.trip_id!, kTripId)
            SharedUtil.removeKey(kFromAddress)
            SharedUtil.removeKey(kToAddress)
            reachDestination()            
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        GeoSpark.notificationOpenedHandler(response)
        completionHandler()
    }
    
    func didUpdateLocation(_ location: GSLocation) {
    }
    
    func reachDestination(){
        DispatchQueue.main.async {
            let vc = MainViewController.viewController()
            self.window?.rootViewController = vc
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


