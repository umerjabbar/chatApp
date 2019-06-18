//
//  File.swift
//  ChatApp
//
//  Created by MacAir on 18/06/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

extension String {
    
    public func format(to : String = "dd/MM/yyyy", from : String = "yyyy-MM-dd HH:mm:ss") -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = from
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = to
        if let date = dateFormatterGet.date(from: self){
            return dateFormatterPrint.string(from: date)
        }
        else {
            return "n/a"
        }
    }
    
    public func getDate(from : String = "yyyy-MM-dd HH:mm:ss") -> Date{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = from
        if let date = dateFormatterGet.date(from: self){
            return date
        }else{
            return Date()
        }
    }
    
}
