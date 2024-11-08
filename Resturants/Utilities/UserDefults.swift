//
//  UserDefults.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation

struct UserDefault {
    
    private struct key {
        
        static let isAuthenticated       = "IsAuthenticated"
        static let userToken             = "userToken"
    }
    
    static var token: String {
        
        get {
           
            return UserDefaults.standard.string(forKey: key.userToken) ?? ""
        }
        set{
           
            return UserDefaults.standard.set(newValue, forKey: key.userToken)
        }
    }
    
    static var isAuthenticated: Bool {
        
        get {
            
            return UserDefaults.standard.bool(forKey: key.isAuthenticated)
            
        }
        set {
            
            UserDefaults.standard.set(newValue, forKey: key.isAuthenticated)
            
        }
    }
}
