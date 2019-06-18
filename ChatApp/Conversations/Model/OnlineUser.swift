//
//  OnlineUser.swift
//  ChatApp
//
//  Created by Umer Jabbar on 19/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftyJSON


class OnlineUser : NSObject, NSCoding{
    
    var id : String!
    var image : String!
    var isConnected : Bool!
    var lastOnline : String!
    var name : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].stringValue
        image = json["image"].stringValue
        isConnected = json["isConnected"].boolValue
        lastOnline = json["lastOnline"].stringValue
        name = json["name"].stringValue
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
        if isConnected != nil{
            dictionary["isConnected"] = isConnected
        }
        if lastOnline != nil{
            dictionary["lastOnline"] = lastOnline
        }
        if name != nil{
            dictionary["name"] = name
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
        isConnected = aDecoder.decodeObject(forKey: "isConnected") as? Bool
        lastOnline = aDecoder.decodeObject(forKey: "lastOnline") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
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
        if isConnected != nil{
            aCoder.encode(isConnected, forKey: "isConnected")
        }
        if lastOnline != nil{
            aCoder.encode(lastOnline, forKey: "lastOnline")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        
    }
    
}
