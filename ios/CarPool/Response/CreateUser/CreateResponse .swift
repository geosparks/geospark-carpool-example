
import Foundation


class UserResponse  : NSObject{

    var message : String!
    var status : Bool!
    var model : String!
    var pk : Int!
    var createdAt : String!
    var name : String!
    var phone : Int!
    var userId : String!

    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        status = dictionary["status"] as? Bool
        if let dataData = dictionary["data"] as? [String:Any]{
            model = dataData["model"] as? String
            pk = dataData["pk"] as? Int
            if let fieldsData = dataData["fields"] as? [String:Any]{
                createdAt = fieldsData["created_at"] as? String
                name = fieldsData["name"] as? String
//                phone = fieldsData["phone"] as? Int
                userId = fieldsData["user_id"] as? String
            }
        }
    }
}


