//
//  TripHistory .swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 27, 2019

import Foundation


class TripHistory  : NSObject, NSCoding{

    var code : Int!
    var data : TripHistoryData!
    var msg : String!
    var status : Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? Int
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? Bool
        if let dataData = dictionary["data"] as? [String:Any]{
            data = TripHistoryData(fromDictionary: dataData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if msg != nil{
            dictionary["msg"] = msg
        }
        if status != nil{
            dictionary["status"] = status
        }
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        data = aDecoder.decodeObject(forKey: "data") as? TripHistoryData
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        status = aDecoder.decodeObject(forKey: "status") as? Bool
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if data != nil{
            aCoder.encode(data, forKey: "data")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}