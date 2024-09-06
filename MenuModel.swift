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
    let locType    : String
    
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
            "timings": timings,
            "locType": locType
            
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


struct GroupsItemModel {
    let id         : String
    let title      : String
    let img        : String
    let descrip    : String
    let price      : String
    let currency   : String
    let mostLiked  : String
    
    func toDictionary() -> [String: Any] {
        return [
            "uniqueID"    : id,
            "title"       : title,
            "img"         : img,
            "description" : descrip,
            "price"       : price,
            "currency"    : currency,
            "mostLiked"   : mostLiked,
        ]
    }
}


struct CollectionModel {
    let collectionName  : String
    let id              : String
    var swiftIds        : [String]
    var videosIds       : [String]
    let visibility      : String
    var selected        : Int
   
    
    func toDictionary() -> [String: Any] {
        return [
            "collectionName" : collectionName,
            "id"             : id,
            "swiftIds"       : swiftIds,
            "videosIds"      : videosIds,
            "visibility"     : visibility
        ]
    }
}
