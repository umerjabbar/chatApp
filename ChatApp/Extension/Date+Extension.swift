//
//  Date+Extension.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

extension Date {
    
    
    func getString(to : String = "yyyy-MM-dd HH:mm:ss") -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = to
        return dateFormatterPrint.string(from: self)
    }
    
}
