//
//  SceneDelegate.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 25/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications
import GeoSpark

class SceneDelegate: UIResponder, UIWindowSceneDelegate,UNUserNotificationCenterDelegate{

    var window: UIWindow?
    var navigationController: UINavigationController = UINavigationController()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        if SharedUtil.getDefaultBoolean(kIsfirstTime) == true{

            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var rootViewController:UIViewController?
            if SharedUtil.getDefaultBoolean(kTripStarted){
                rootViewController = storyboard.instantiateViewController(withIdentifier: "MyTripViewController") as! MyTripViewController
            }else if SharedUtil.getDefaultBoolean(kTripRequest){
                rootViewController = storyboard.instantiateViewController(withIdentifier: "MyTripFindRideViewController") as! MyTripFindRideViewController
            }
            else{
                rootViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            }
            navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            navigationController.viewControllers = [rootViewController] as! [UIViewController]
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}

