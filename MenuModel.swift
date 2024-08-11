//
//  MenuModel.swift
//  Resturants
//
//  Created by Coder Crew on 10/08/2024.
//

import Foundation

struct RestaurantLocation {
    let id         : String
    let channalNm  : String
    let bio        : String
    let email      : String
    let website    : String
    let telephoneNumber: String
    let address    : String
    let zipCode    : String
    let City       : String
    let timings    : [String]?
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "channalNm": channalNm,
            "bio": bio,
            "email": email,
            "website": website,
            "telephoneNumber": telephoneNumber,
            "address": address,
            "zipCode": zipCode,
            "City": City,
            "timings": timings
            
        ]
    }
}

struct GroupsModel {
    let id         : String
    let groupName  : String
    var selected   : Int
    
    func toDictionary() -> [String: Any] {
        return [
            "uniqueID" : id,
            "groupName": groupName
        ]
    }
}
