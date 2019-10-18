
import Foundation


class NotificationHandler  : NSObject{

    var type : String!
    var trip_id:String!

    init(fromDictionary dictionary: [String:Any]){
        if let apsDict = dictionary["aps"] as? Dictionary<String,Any>{
            type = apsDict["notification_type"] as? String
            trip_id = apsDict["trip_id"] as? String
        }
    }

}
