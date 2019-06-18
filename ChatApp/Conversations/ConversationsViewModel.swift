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
    
    func offlineFunction() {
        let myConnectionsRef = Database.database().reference().child("users/connections");
        let connectedRef = Database.database().reference().child(".info/connected");
        connectedRef.observe(.value) { (snapshot) in
            guard let value = snapshot.value as? Bool, value else { return }
            let con = myConnectionsRef.child("\(AppStateManager.shared.id)")
                con.setValue([
                    "id": "\(AppStateManager.shared.id)",
                    "name": "\(AppStateManager.shared.name)",
                    "image": "\(AppStateManager.shared.image)",
                    "isConnected": true,
                    "lastOnline": Date().getString()
                    ]);
                con.onDisconnectSetValue([
                    "id": "\(AppStateManager.shared.id)",
                    "name": "\(AppStateManager.shared.name)",
                    "image": "\(AppStateManager.shared.image)",
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
            self.delegate?.onlineUsersReceived()
        }
    }
    
    
}
