//
//  AppURL.swift
//  GeoSpark Ignite
//
//  Created by GeoSpark Mac #1 on 24/04/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit

let kBASE_URL = "http://redbus.geospark.xyz"

let kCREATE_USER = kBASE_URL + "/user/"

let kGET_USER = kBASE_URL + "/user/?phone="

let kFIND_RIDE = kBASE_URL + "/service/"

let kGET_ALL_USER_PROVIDERS = kBASE_URL + "/service/?service_type=provider"

let kGET_ALL_USER_REQUEST = kBASE_URL + "/service/?service_type=request"

let kCREATE_TRIP_URL = "https://api.geospark.co/v1/api/trips/"

let TRIP_HISTORY_URL = "https://api.geospark.co/v1/api/trips/?trip_type=completed&user_id="

let TRIP_API = "https://api.geospark.co/v1/api/trips/?trip_id="

let UPDATE_TRIP_API = "https://api.geospark.co/v1/api/trips/"

let TRIP_DATA =  kBASE_URL + "/trip-data/"

let TRIP_METADATA =  kBASE_URL + "/trip-metadata/"

