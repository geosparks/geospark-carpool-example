//
//  GetUserProvider.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 30, 2019

import Foundation


class GetUserProvider : NSObject{

    var destLat : Double!
    var destLng : Double!
    var poolUsr : Int!
    var srcLat : Double!
    var srcLng : Double!

    var model : String!
    var pk : Int!

    var name : String!
    var phone : Int!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        model = dictionary["model"] as? String
        pk = dictionary["pk"] as? Int
        
        if let fieldsData = dictionary["fields"] as? [String:Any]{
            destLat = fieldsData["dest_lat"] as? Double
            destLng = fieldsData["dest_lng"] as? Double
            poolUsr = fieldsData["pool_usr"] as? Int
            srcLat = fieldsData["src_lat"] as? Double
            srcLng = fieldsData["src_lng"] as? Double
        }
        if let userDetailsData = dictionary["user_details"] as? [String:Any]{
            name = userDetailsData["name"] as? String
            phone = userDetailsData["phone"] as? Int
            userId = userDetailsData["user_id"] as? String
        }
    }

}
