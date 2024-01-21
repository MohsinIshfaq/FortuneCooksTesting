//
//  String+extension.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation
import UIKit
//MARK: - Regex for User Name
extension String {
    
    var isValidNameRegex : Bool {
        let userNameRegEx = "^[a-z0-9_-]{1,13}$"
        
        let userNameChecker = NSPredicate(format:"SELF MATCHES[c] %@", userNameRegEx)
        return userNameChecker.evaluate(with: self)
    }
    
    func isValidEmailRegex(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validPhoneRegex(value: String) -> Bool {
        let PHONE_REGEX = "^(\\+?\\d{1,3}\\s?)?0?\\d{1,12}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    func utcToLocal(dateStr: String , utcFormate:String , localFormate:String ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = utcFormate
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = localFormate
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func AmountStringComma(amount:String , new:String) -> String {
        
        var a = amount + new
        let strReplace = a.replacingOccurrences(of: ",", with: "", options: .literal, range: nil)// change "txtField" your textfield's object
        var b =  Int(strReplace) ?? 0
        return  delimiter(a: b)
    }
    
    func delimiter(a:Int)->String {
        
        let bigNumber = a
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle =  .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: bigNumber)) ?? ""
        return formattedNumber
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

