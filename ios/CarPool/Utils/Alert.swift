//
//  Alert.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 25/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import Foundation
import UIKit


class Alert: NSObject {

    static func alertController(title: String?,message:String?, viewController:UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let firstAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(firstAction)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}
