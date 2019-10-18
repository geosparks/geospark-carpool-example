//
//  GetUserRootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 30, 2019

import Foundation


class GetUserProviderResponse : NSObject{

    var message : String!
    var status : Bool!
    var providers : [GetUserProvider]!

    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        status = dictionary["status"] as? Bool
        if let dataData = dictionary["data"] as? [String:Any]{
            providers = [GetUserProvider]()
            if let providerArray = dataData["provider"] as? [[String:Any]]{
                for dic in providerArray{
                    let value = GetUserProvider(fromDictionary: dic)
                    providers.append(value)
                }
            }
        }
    }

}
