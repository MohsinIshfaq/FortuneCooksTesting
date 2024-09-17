//
//  UIFont+Extension.swift
//  Resturants
//
//  Created by Mohsin on 15/09/2024.
//

import UIKit

extension UIFont {
    enum Roboto {
        static func Regular(of size:CGFloat) -> UIFont { return UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: size) }
//        static func Medium(of size:CGFloat) -> UIFont { return UIFont(name: "DMSans-Medium", size: size) ?? UIFont.systemFont(ofSize: size) }
//        static func Bold(of size:CGFloat) -> UIFont { return UIFont(name: "DMSans-Bold", size: size) ?? UIFont.systemFont(ofSize: size) }
    }
}
