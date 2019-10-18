//
//  MyTripViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 01/10/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GeoSpark
class MyTripViewController: UIViewController {

    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Trip"
        fromAddress.text = "From  :" + SharedUtil.getDefaultString(kFromAddress)
        toAddress.text = "To  :" + SharedUtil.getDefaultString(kToAddress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    static public func viewController() -> MyTripViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "MyTripViewController") as! MyTripViewController
        return logsDisplayVC
    }

    @IBAction func tripLiveTracking(_ sender: Any) {
        let vc = LiveTrackingViewController.viewController()
        vc.tripId = SharedUtil.getDefaultString(kTripId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func endTrip(_ sender: Any) {
        showHud()
        let tripId = SharedUtil.getDefaultString(kTripId)
        GeoSpark.endTrip(tripId, { (trip) in
            if trip.msg == "Trip Ended."{
                SharedUtil.setDefaultBoolean(false, kTripStarted)
                SharedUtil.removeKey(kFromAddress)
                SharedUtil.removeKey(kToAddress)
                SharedUtil.removeKey(kTripId)
                
                DispatchQueue.main.async {
                    self.dismissHud()
                    let vc = MainViewController.viewController()
                    self.window?.rootViewController = vc
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }) { (error) in
            self.dismissHud()
            Alert.alertController(title: error.errorCode, message: error.errorMessage, viewController: self)
        }
    }
    
}
