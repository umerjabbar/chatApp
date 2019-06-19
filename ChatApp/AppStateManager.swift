//
//  AppStateManager.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AppStateManager {
    
    static let shared = AppStateManager()
    
    var name = "\(UIDevice.current.name)"
    var id = "\(UIDevice.current.identifierForVendor?.uuidString ?? "123")"
    var image = "https://lakewangaryschool.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg"
    var email = ""
    var username = ""
    
}
