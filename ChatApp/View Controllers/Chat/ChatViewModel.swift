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
    
    var currentUser = AppStateManager.shared
    var item : MessageHead!
    var messageList = [MyMessage]()
    
    var observers = [UInt]()
    
    
    let reference = Database.database().reference()
    var fireBaseRef = Database.database().reference().child("Chat/user1/user2/messages");
    var fireBaseRef2 = Database.database().reference().child("Chat/user2/user1/messages");
    
    weak var delegate : ChatResponseDelegate?
    
    
    
    func killAllObservers (){
        self.observers.forEach { (observer) in
            self.reference.removeObserver(withHandle: observer)
        }
    }
    
    func setup(){
        guard item != nil, item.id != nil, item.name != nil else {
            print("head or id or name is nil")
            return
        }
        self.fireBaseRef = self.reference.child("Chat/\(self.item.id!)/\(self.currentUser.id)/messages")
        self.fireBaseRef2 = self.reference.child("Chat/\(self.currentUser.id)/\(self.item.id!)/messages")
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
        
        self.fireBaseRef.child(key).setValue(message.toDictionary(), withCompletionBlock: { (error, ref) in
            //            self.notifyUser(message: message, currentOrder: currentOrder)
            self.delegate?.messageSent()
        })
        self.fireBaseRef2.child(key).setValue(message.toDictionary(), withCompletionBlock: { (error, ref) in
            //            self.notifyUser(message: message, currentOrder: currentOrder)
            self.delegate?.messageSent()
        })
        
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
        
        Database.database().reference().child("Users/\(self.item.id!)/ChatHeads/\(self.currentUser.id)").setValue(
            [
                "id" : "\(self.currentUser.id)",
                "name" : "\(self.currentUser.name)",
                "image" : "\(self.currentUser.image)",
                "message" : "\(message)",
                "time" : "\(Date().getString())",
                "otherUser" : "\(self.item.id!)",
                "chatType" : "individual",
            ]
        )
        Database.database().reference().child("Users/\(self.currentUser.id)/ChatHeads/\(self.item.id!)").setValue(
            [
                "id" : "\(self.item.id!)",
                "name" : "\(self.item.name!)",
                "image" : "\(self.item.image!)",
                "message" : "\(message)",
                "time" : "\(Date().getString())",
                "otherUser" : "\(self.currentUser.id)",
                "chatType" : "individual",
            ]
        )
        
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

    func getUserDict(users : [MyUser]) -> [String : MyUser]{
        var dictUsers = [String: MyUser]()
        users.forEach { (user) in
            dictUsers[user.id] = user
        }
        return dictUsers
    }
    
}
