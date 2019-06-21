//
//  MessageHead.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftyJSON


class MessageHead : NSObject, NSCoding{
    
    var id : String!
    var image : String!
    var message : String!
    var name : String!
    var otherUser : String!
    var time : String!
    var chatType: String!
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    override init(){
        super.init()
    }
    
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        image = json["image"].stringValue
        message = json["message"].stringValue
        name = json["name"].stringValue
        otherUser = json["otherUser"].stringValue
        time = json["time"].stringValue
        chatType = json["chatType"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if image != nil{
            dictionary["image"] = image
        }
        if message != nil{
            dictionary["message"] = message
        }
        if name != nil{
            dictionary["name"] = name
        }
        if otherUser != nil{
            dictionary["otherUser"] = otherUser
        }
        if time != nil{
            dictionary["time"] = time
        }
        if chatType != nil{
            dictionary["chatType"] = chatType
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        otherUser = aDecoder.decodeObject(forKey: "otherUser") as? String
        time = aDecoder.decodeObject(forKey: "time") as? String
        chatType = aDecoder.decodeObject(forKey: "chatType") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if otherUser != nil{
            aCoder.encode(otherUser, forKey: "otherUser")
        }
        if time != nil{
            aCoder.encode(time, forKey: "time")
        }
        if chatType != nil{
            aCoder.encode(chatType, forKey: "chatType")
        }
        
    }
    
}
