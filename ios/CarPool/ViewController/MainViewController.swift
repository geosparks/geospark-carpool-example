//
//  MainViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 26/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GeoSpark

class MainViewController: UIViewController {

    @IBOutlet weak var findARide: UIButton!
    @IBOutlet weak var giveARide: UIButton!
    @IBOutlet weak var userName: UILabel!
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Car Pool"
        self.userName.text = "Hey  " + SharedUtil.getDefaultString(kUserName)
    }
    
    static public func viewController() -> MainViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        return logsDisplayVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    @IBAction func findaRideAction(_ sender: Any) {
        let vc = FindaRideViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func getaRideAction(_ sender: Any) {
        let vc = GetaRideViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func profileAction(_ sender: Any) {
        let vc = ProfileViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tripHistoryAction(_ sender: Any) {
        let vc = TripHistoryViewController.viewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func logoutAction(_ sender: Any) {
        GeoSpark.logout({ (message) in
            DispatchQueue.main.async{
                Utils.resetDefaults()
                let vc = LoginViewController.viewController()
                self.window?.rootViewController = vc
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }) { (error) in
            Alert.alertController(title: error.errorCode, message: error.errorMessage, viewController: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
