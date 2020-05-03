//
//  ConversationsViewModel.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

class ConversationsViewModel: NSObject {
    
    weak var delegate : ConversationsResponseDelegate?
    
    var onlineUsers = [OnlineUser]()
    var messageHeads = [MessageHead]()
    
    var currentUser = AppStateManager.shared
    
    func offlineFunction() {
        let myConnectionsRef = Database.database().reference().child("users/connections");
        let connectedRef = Database.database().reference().child(".info/connected");
        connectedRef.observe(.value) { (snapshot) in
            guard let value = snapshot.value as? Bool, value else { return }
            let con = myConnectionsRef.child("\(self.currentUser.id)")
                con.setValue([
                    "id": "\(self.currentUser.id)",
                    "name": "\(self.currentUser.name)",
                    "image": "\(self.currentUser.image)",
                    "isConnected": true,
                    "lastOnline": Date().getString()
                    ]);
                con.onDisconnectSetValue([
                    "id": "\(self.currentUser.id)",
                    "name": "\(self.currentUser.name)",
                    "image": "\(self.currentUser.image)",
                    "isConnected": false,
                    "lastOnline": Date().getString()
                    ])
        }
    }
    
    func getOnlineUsers(){
        let myConnectionsRef = Database.database().reference().child("users/connections");
        myConnectionsRef.observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else{return}
            let values = value.map({ (key,val) -> Any in
                return val
            })
            guard let jsonArray = JSON(rawValue: values) else{return}
            self.onlineUsers = jsonArray.arrayValue.map({ OnlineUser(fromJson: $0)})
            self.onlineUsers.sort(by: { (item1, item2) -> Bool in
                return item1.isConnected
            })
            self.onlineUsers = self.onlineUsers.filter({ (user) -> Bool in
                return user.id != self.currentUser.id
            })
            self.delegate?.onlineUsersReceived()
        }
    }
    
    func getMessageHeads(){
        let myConnectionsRef = Database.database().reference().child("Users/\(self.currentUser.id)/ChatHeads");
        myConnectionsRef.observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else{return}
            let values = value.map({ (key,val) -> Any in
                return val
            })
            guard let jsonArray = JSON(rawValue: values) else{return}
            self.messageHeads = jsonArray.arrayValue.map({ MessageHead(fromJson: $0)})
            self.messageHeads.reverse()
            self.delegate?.messageHeadsReceived()
        }
    }

}
