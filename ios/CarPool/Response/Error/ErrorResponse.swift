//
//  ErrorResponse.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 26/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import Foundation
import UIKit

@objc public class ErrorResponse: NSObject {
    
    @objc public let errorCode: String
    @objc public let errorMessage: String
    
    init(_ code:String, _ message:String){
        self.errorCode = code
        self.errorMessage = message
    }
}
