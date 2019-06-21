//
//  ConversationProtocols.swift
//  ChatApp
//
//  Created by Umer Jabbar on 19/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

protocol ConversationsResponseDelegate : class {
    func onlineUsersReceived()
    func messageHeadsReceived()
}
