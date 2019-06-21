//
//  Message.swift
//  Akhdmny
//
//  Created by Umer Jabbar on 17/09/2018.
//  Copyright © 2018 ZotionApps. All rights reserved.
//

import Foundation
import SwiftyJSON


class Message : NSObject, NSCoding{
    
    var body : String!
    var id : String!
    var isDelivered : Bool!
    var isRead : Bool!
    var senderId : String!
    var senderImage : String!
    var senderName : String!
    var time : String!
    var type : Int!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        body = json["body"].stringValue
        id = json["id"].stringValue
        isDelivered = json["isDelivered"].boolValue
        isRead = json["isRead"].boolValue
        senderId = json["senderId"].stringValue
        senderImage = json["senderImage"].stringValue
        senderName = json["senderName"].stringValue
        time = json["time"].stringValue
        type = json["type"].intValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if body != nil{
            dictionary["body"] = body
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isDelivered != nil{
            dictionary["isDelivered"] = isDelivered
        }
        if isRead != nil{
            dictionary["isRead"] = isRead
        }
        if senderId != nil{
            dictionary["senderId"] = senderId
        }
        if senderImage != nil{
            dictionary["senderImage"] = senderImage
        }
        if senderName != nil{
            dictionary["senderName"] = senderName
        }
        if time != nil{
            dictionary["time"] = time
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        body = aDecoder.decodeObject(forKey: "body") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isDelivered = aDecoder.decodeObject(forKey: "isDelivered") as? Bool
        isRead = aDecoder.decodeObject(forKey: "isRead") as? Bool
        senderId = aDecoder.decodeObject(forKey: "senderId") as? String
        senderImage = aDecoder.decodeObject(forKey: "senderImage") as? String
        senderName = aDecoder.decodeObject(forKey: "senderName") as? String
        time = aDecoder.decodeObject(forKey: "time") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if body != nil{
            aCoder.encode(body, forKey: "body")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isDelivered != nil{
            aCoder.encode(isDelivered, forKey: "isDelivered")
        }
        if isRead != nil{
            aCoder.encode(isRead, forKey: "isRead")
        }
        if senderId != nil{
            aCoder.encode(senderId, forKey: "senderId")
        }
        if senderImage != nil{
            aCoder.encode(senderImage, forKey: "senderImage")
        }
        if senderName != nil{
            aCoder.encode(senderName, forKey: "senderName")
        }
        if time != nil{
            aCoder.encode(time, forKey: "time")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        
    }
    
}
