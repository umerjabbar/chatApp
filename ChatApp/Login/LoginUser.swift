//
//  LoginUser.swift
//  ChatApp
//
//  Created by MacAir on 19/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftyJSON


class LoginUser : NSObject, NSCoding{
    
    var email : String!
    var fbUserIdpw : String!
    var id : String!
    var isAdmin : String!
    var name : String!
    var nickname : String!
    var picture : String!
    var pw : String!
    var pwVerify : Bool!
    var surname : String!
    
    
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        email = json["email"].stringValue
        fbUserIdpw = json["fb_user_idpw"].stringValue
        id = json["id"].stringValue
        isAdmin = json["is_admin"].stringValue
        name = json["name"].stringValue
        nickname = json["nickname"].stringValue
        picture = json["picture"].stringValue
        pw = json["pw"].stringValue
        pwVerify = json["pw_verify"].boolValue
        surname = json["surname"].stringValue
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if email != nil{
            dictionary["email"] = email
        }
        if fbUserIdpw != nil{
            dictionary["fb_user_idpw"] = fbUserIdpw
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isAdmin != nil{
            dictionary["is_admin"] = isAdmin
        }
        if name != nil{
            dictionary["name"] = name
        }
        if nickname != nil{
            dictionary["nickname"] = nickname
        }
        if picture != nil{
            dictionary["picture"] = picture
        }
        if pw != nil{
            dictionary["pw"] = pw
        }
        if pwVerify != nil{
            dictionary["pw_verify"] = pwVerify
        }
        if surname != nil{
            dictionary["surname"] = surname
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        email = aDecoder.decodeObject(forKey: "email") as? String
        fbUserIdpw = aDecoder.decodeObject(forKey: "fb_user_idpw") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isAdmin = aDecoder.decodeObject(forKey: "is_admin") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        picture = aDecoder.decodeObject(forKey: "picture") as? String
        pw = aDecoder.decodeObject(forKey: "pw") as? String
        pwVerify = aDecoder.decodeObject(forKey: "pw_verify") as? Bool
        surname = aDecoder.decodeObject(forKey: "surname") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder)
    {
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if fbUserIdpw != nil{
            aCoder.encode(fbUserIdpw, forKey: "fb_user_idpw")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isAdmin != nil{
            aCoder.encode(isAdmin, forKey: "is_admin")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if nickname != nil{
            aCoder.encode(nickname, forKey: "nickname")
        }
        if picture != nil{
            aCoder.encode(picture, forKey: "picture")
        }
        if pw != nil{
            aCoder.encode(pw, forKey: "pw")
        }
        if pwVerify != nil{
            aCoder.encode(pwVerify, forKey: "pw_verify")
        }
        if surname != nil{
            aCoder.encode(surname, forKey: "surname")
        }
        
    }
    
}
