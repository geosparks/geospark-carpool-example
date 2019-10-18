//
//  ProfileViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 26/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GeoSpark

class ProfileViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        userName.text = SharedUtil.getDefaultString(kUserName)
        userId.text = SharedUtil.getDefaultString(kUserId)
        phoneNumber.text = SharedUtil.getDefaultString(kUserPhone)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    static public func viewController() -> ProfileViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        return logsDisplayVC
    }

}
