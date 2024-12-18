//
//  BaseStrings.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation
import UIKit

//MARK: - Base URLs
struct AppBaseStrings {
        
   static let APP_LIVE_URL                =   "https://dex.mywodipay.com"//"https://cash.taaply.co"//
}

//MARK: - End URls
struct EndUrls {
    
    static let customer_Validate_Email  =   "/api/v1/customer/validate-email"
}


extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
