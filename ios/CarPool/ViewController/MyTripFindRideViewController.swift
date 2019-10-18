//
//  MyTripFindRideViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 02/10/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GeoSpark

class MyTripFindRideViewController: UIViewController {

    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var nameAddress: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var liveTrackingBtn: UIButton!

    var isNotification:Bool = false
    var window: UIWindow?
    var tripId:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Trip"
        self.nameAddress.text = SharedUtil.getDefaultString(kUserName)
        if isNotification == false{
            if SharedUtil.getDefaultString(kFromAddress).isEmpty == false{
                fromAddress.text = "From  :" + SharedUtil.getDefaultString(kFromAddress)
            }
            if SharedUtil.getDefaultString(kToAddress).isEmpty == false{
                toAddress.text = "To  :" + SharedUtil.getDefaultString(kToAddress)
            }
            liveTrackingBtn.isHidden = true
        }else{
            liveTrackingBtn.isHidden = false
            fromAddress.text = ""
            toAddress.text = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    static public func viewController() -> MyTripFindRideViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "MyTripFindRideViewController") as! MyTripFindRideViewController
        return logsDisplayVC
    }

    @IBAction func endTrip(_ sender: Any) {
        
        SharedUtil.setDefaultBoolean(false, kTripRequest)
        SharedUtil.setDefaultBoolean(false, kTripStarted)
        SharedUtil.removeKey(kFromAddress)
        SharedUtil.removeKey(kToAddress)
        SharedUtil.removeKey(kTripId)
        
        DispatchQueue.main.async {
            let vc = MainViewController.viewController()
            self.window?.rootViewController = vc
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func tripLiveTracking(_ sender: Any) {
        let vc = LiveTrackingViewController.viewController()
        vc.tripId = SharedUtil.getDefaultString(kTripId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
