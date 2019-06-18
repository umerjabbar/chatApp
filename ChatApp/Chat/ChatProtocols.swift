//
//  ChatDelegate.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

protocol ChatResponseDelegate : class {
    
    func previousDataReceived()
    func newMessageReceived(message : MyMessage)
    func messageSent()
    
}
