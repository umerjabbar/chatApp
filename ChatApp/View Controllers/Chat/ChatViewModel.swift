//
//  ChatModelView.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SwiftyJSON
import MessageKit
import MapKit

class ChatViewModel : NSObject {
    
    var previousMessageLoadlimit : UInt = 100
    var previousMessageLoadRequest = false
    var previousDataReceived : Int?
    
    var currentUser : MyUser {
        get {
            let user = MyUser()
            user.id = AppStateManager.shared.id
            user.name = AppStateManager.shared.name
            user.image = AppStateManager.shared.image
            return user
        }
    }
    var item : MessageHead!
    var chatType = "group"
    var messageList = [MyMessage]()
    var users = [MyUser]()
    
    var observers = [UInt]()
    
    
    let reference = Database.database().reference()
    var fireBaseRef = Database.database().reference().child("Chat/sample/messages");
    var fireBaseRef2 = Database.database().reference().child("Chat/sample/messages");
    var fireBaseRefData = Database.database().reference().child("Chat/sample/data");
    var fireBaseRefData2 = Database.database().reference().child("Chat/sample/data");
    
    weak var delegate : ChatResponseDelegate?
    
    
    
    func killAllObservers (){
        self.observers.forEach { (observer) in
            self.reference.removeObserver(withHandle: observer)
        }
    }
    
    func setup(){
        if self.item == nil {
            let head = MessageHead()
            head.id = "sample"
            head.name = "Sample"
            head.image = "http://www.holosgen.com/wp-content/uploads/2018/12/1416428226Image-Placeholder-1416428226-7e2acf81995ad78a094f834d00a.jpg"
            head.chatType = "group"
            self.item = head
            self.chatType = "group"
        }
        
        
        if self.chatType == "individual" {
            self.fireBaseRef = self.reference.child("Chat/\(self.item.id!)/\(self.currentUser.id!)/messages")
            self.fireBaseRef2 = self.reference.child("Chat/\(self.currentUser.id!)/\(self.item.id!)/messages")
            self.fireBaseRefData = self.reference.child("Chat/\(self.item.id!)/\(self.currentUser.id!)/data")
            self.fireBaseRefData2 = self.reference.child("Chat/\(self.currentUser.id!)/\(self.item.id!)/data")
        }else if self.chatType == "group" {
            self.fireBaseRef = self.reference.child("Chat/\(self.item.id!)/messages")
            self.fireBaseRefData = self.reference.child("Chat/\(self.item.id!)/data")
        }
    }
    
    func onLoadEarlier() {
        if (self.messageList.count >= self.previousMessageLoadlimit && (self.previousDataReceived ??  Int(self.previousMessageLoadlimit) >=  self.previousMessageLoadlimit) && !self.previousMessageLoadRequest) {
            self.previousMessageLoadRequest = true
            guard let messageId = self.messageList.first?.messageId else{return}
            let observer = self.fireBaseRef.queryOrderedByKey().queryEnding(atValue: messageId).queryLimited(toFirst: self.previousMessageLoadlimit).observe(.value) { (snapshot) in
                guard let value = snapshot.value as? [String : Any] else{return}
                let values = value.map({ (key,val) -> Any in
                    return val
                })
                guard let jsonArray = JSON(rawValue: values) else{return}
                let messages = jsonArray.arrayValue.map({ Message(fromJson: $0)})
                var myMessages = messages.map({ (message) -> MyMessage in
                    return self.makeMyMessage(message: message)
                })
                myMessages.reverse()
                myMessages.append(contentsOf: self.messageList)
                self.messageList = myMessages

                self.delegate?.previousDataReceived()

                self.previousMessageLoadRequest = false
            }
            self.observers.append(observer)
        }
    }
    
    
    func observeNewMessage() {
        let observer = self.fireBaseRef.queryLimited(toLast: self.previousMessageLoadlimit).observe(.childAdded) { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else{return}
            let message = Message(fromJson: JSON(value))
            self.delegate?.newMessageReceived(message: self.makeMyMessage(message: message))
        }
        self.observers.append(observer)
    }
    
    func sendMessage(body : String, type : Int){
        
        guard let key = self.fireBaseRef.childByAutoId().key else{return}
        let message = Message(fromJson: JSON([:]))
        message.id = key
        message.body = body
        message.senderId = self.currentUser.id
        message.senderName = self.currentUser.name
        message.senderImage = self.currentUser.image
        message.time = Date().getString()
        message.type = type
        message.isRead = false
        message.isDelivered = true
        if self.chatType == "individual" {
            self.fireBaseRef.child(key).setValue(message.toDictionary(), withCompletionBlock: { (error, ref) in
                //            self.notifyUser(message: message, currentOrder: currentOrder)
                self.delegate?.messageSent()
            })
            self.fireBaseRef2.child(key).setValue(message.toDictionary(), withCompletionBlock: { (error, ref) in
                //            self.notifyUser(message: message, currentOrder: currentOrder)
                self.delegate?.messageSent()
            })
        }else if self.chatType == "group"{
            self.fireBaseRef.child(key).setValue(message.toDictionary(), withCompletionBlock: { (error, ref) in
                //            self.notifyUser(message: message, currentOrder: currentOrder)
                self.delegate?.messageSent()
            })
        }
        
        switch type {
        case 1:
            self.makeChatHeads(message: body)
        case 2:
            self.makeChatHeads(message: "sent a location")
        case 3:
            self.makeChatHeads(message: "sent an image")
        case 4:
            self.makeChatHeads(message: "sent an audio")
        default:
            print("something else is being called in message type")
        }
        
    }
    
    func makeChatHeads(message: String){
        
        if self.chatType == "individual" {
            Database.database().reference().child("Users/\(self.item.id!)/ChatHeads/\(self.currentUser.id!)").setValue(
                [
                    "id" : "\(self.currentUser.id!)",
                    "name" : "\(self.currentUser.name!)",
                    "image" : "\(self.currentUser.image!)",
                    "message" : "\(message)",
                    "time" : "\(Date().getString())",
                    "otherUser" : "\(self.item.id!)",
                    "chatType" : "individual",
                ]
            )
            Database.database().reference().child("Users/\(self.currentUser.id!)/ChatHeads/\(self.item.id!)").setValue(
                [
                    "id" : "\(self.item.id!)",
                    "name" : "\(self.item.name!)",
                    "image" : "\(self.item.image!)",
                    "message" : "\(message)",
                    "time" : "\(Date().getString())",
                    "otherUser" : "\(self.currentUser.id!)",
                    "chatType" : "individual",
                ]
            )
        }
        
    }
    
    
    func makeMyMessage(message : Message) -> MyMessage{
        let body = message.body ?? "unknown"
        let sender = Sender(id: message.senderId, displayName: message.senderName)
        let id = message.id ?? "qwe"
        let date = message.time.getDate()
        let status = Status(isRead: message.isRead, isDelivered: message.isDelivered)
        
        switch message.type {
        case 1:
            return MyMessage(text: body, sender: sender, messageId: id, date: date, status : status)
        case 2:
            let coordinates = body.split(separator: ",")
            let latitude = Double("\(coordinates.first ?? "0.0")") ?? 0.0
            let longitude = Double("\(coordinates.last ?? "0.0")") ?? 0.0
            return MyMessage(location: CLLocation(latitude: latitude, longitude: longitude), sender: sender, messageId: id, date: date, status : status)
        case 3:
            let url = URL(string: body)!
            return MyMessage(imageUrl: url, sender: sender, messageId: id, date: date, status: status)
        case 4:
            let url = URL(string: body)!
            return MyMessage(audioUrl: url, sender: sender, messageId: id, date: date, status: status)
        default:
            return MyMessage(text: body, sender: sender, messageId: id, date: date, status : status)
        }
        
    }
    
}


// Goup Chat Functions
extension ChatViewModel {
    
    func createGroup(name: String, image: String, users: [MyUser]){
        guard let key = self.reference.child("Chat").childByAutoId().key else{return}
        self.reference.child("Chat/\(key)/data").child("info").setValue([
            "id" : key,
            "name" : name,
            "image" : image,
            "createdAt" : Date().getString(),
            ])
        self.reference.child("Chat/\(key)/data").child("users").setValue(self.getUserDict(users: users))
        users.forEach { (user) in
            self.makeGroupChatHeadsFirstTime(id: key, name: name, image: image, userId: user.id)
        }
    }
    
    func makeGroupChatHeadsFirstTime(id: String, name: String, image: String, userId : String){
        self.users.forEach { (user) in
            Database.database().reference().child("Users/\(userId)/ChatHeads/\(id)").setValue(
                [
                    "id" : "\(id)",
                    "name" : "\(name)",
                    "image" : "\(image)",
                    "message" : "",
                    "time" : "\(Date().getString())",
                    "otherUser" : "\(user.id!)",
                    "chatType" : "group",
                ]
            )
        }
    }
    
    func makeGroupChatHeads(message: String){
        self.users.forEach { (user) in
            Database.database().reference().child("Users/\(user.id!)/ChatHeads/\(self.item.id!)").setValue(
                [
                    "id" : "\(self.item.id!)",
                    "name" : "\(self.item.name!)",
                    "image" : "\(self.item.image!)",
                    "message" : "\(message)",
                    "time" : "\(Date().getString())",
                    "otherUser" : "\(user.id!)",
                    "chatType" : "group",
                ]
            )
        }
    }
    
    func getUsers() {
        self.fireBaseRefData.child("users").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else{return}
            let values = value.map({ (key,val) -> Any in
                return val
            })
            guard let jsonArray = JSON(rawValue: values) else{return}
            self.users = jsonArray.arrayValue.map({ MyUser(fromJson: $0)})
        }
        
    }
    
    func addUserToGroup(user: MyUser){
        self.reference.child("Chat/\(self.item.id!)/data").child("users").child(user.id).setValue(user.toDictionary())
        Database.database().reference().child("Users/\(user.id!)/ChatHeads/\(self.item.id!)").setValue(
            [
                "id" : "\(self.item.id!)",
                "name" : "\(self.item.name!)",
                "image" : "\(self.item.image!)",
                "message" : "",
                "time" : "\(Date().getString())",
                "otherUser" : "\(user.id!)",
                "chatType" : "group",
            ]
        )
    }
    
    func removeUserToGroup(user: MyUser){
        self.reference.child("Chat/\(self.item.id!)/data").child("users").child(user.id).removeValue()
        Database.database().reference().child("Users/\(user.id!)/ChatHeads/\(self.item.id!)").removeValue()
    }
    
    func getUserDict(users : [MyUser]) -> [String : MyUser]{
        var dictUsers = [String: MyUser]()
        users.forEach { (user) in
            dictUsers[user.id] = user
        }
        return dictUsers
    }
    
}
