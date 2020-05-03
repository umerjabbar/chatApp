//
//  Status.swift
//  MessageKit
//
//  Created by Umer Jabbar on 19/09/2018.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import Foundation

public struct Status {
    
    public let isRead: Bool
    
    
    public let isDelivered: Bool
    
    // MARK: - Intializers
    
    public init(isRead: Bool, isDelivered: Bool) {
        self.isRead = isRead
        self.isDelivered = isDelivered
    }
}


