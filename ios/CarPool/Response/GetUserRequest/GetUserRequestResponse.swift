//
//  GetUserRequestResponse .swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 30, 2019

import Foundation


class GetUserRequestResponse : NSObject{

    var message : String!
    var status : Bool!
    var request : [GetUserRequestResponseRequest]!

    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        status = dictionary["status"] as? Bool
        if let dataData = dictionary["data"] as? [String:Any]{
            request = [GetUserRequestResponseRequest]()
            if let requestArray = dataData["request"] as? [[String:Any]]{
                for dic in requestArray{
                    let value = GetUserRequestResponseRequest(fromDictionary: dic)
                    request.append(value)
                }
            }
        }
    }

}
