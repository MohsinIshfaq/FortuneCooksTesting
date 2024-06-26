//
//  ProfileModel.swift
//  Resturants
//
//  Created by Coder Crew on 24/05/2024.
//

import Foundation


//["address": txtAddress.text! as String  ,
//        "Zipcode": txtZipCode.text! as String  ,
//        "city"   : txtCity.text! as String     ,
//        "hashTagsModelList": arrHastag         ,
//        "Title":   txtTitle.text! as String    ,
//        "description": txtView.text! as String ,
//        "categories": arrSelectedContent       ,
//        "language": txtLang.text! as String    ,
//        "ThumbnailUrl": "\(thumbnailURL)"      ,
//        "videoUrl"    : ""]

// Define the model
struct UserProfileModel {
    var selectedCuisine: [String]?
    var selectedEnvironment: [String]?
    var selectedFeatures: [String]?
    var accountType: String?
    var address: String?
    var bio: String?
    var city: String?
    var uid: String?
    var website: String?
    var zipcode: String?
    var coverUrl: String?
    var profileUrl: String?
    var followers: [String]?
    var followings: [String]?
    var timings: [String]?
    var tagPersons: [String]?
    var selectedTypeOfRegion: [String]?
    var selectedMeals: [String]?
    var selectedSpecialize: [String]?
    var channelName: String?
    var dateOfBirth: String?
    var email: String?
    var phoneNumber: String?
}


struct UploadVideosModel: Codable {
    
    let address      : String?
    let Zipcode      : String?
    let city         : String?
    let hashTagsModelList: [String]?
    let Title        : String?
    let description  : String?
    let language     : String?
    let ThumbnailUrl : String?
    let videoUrl     : String?
}


struct ProfileVideosModel:  Identifiable,Decodable {
    let id: String   = UUID().uuidString
    let address      : String?
    let Zipcode      : String?
    let city         : String?
    let hashTagsModelList: [String]?
    let Title        : String?
    let description  : String?
    let language     : String?
    let ThumbnailUrl : String?
    let videoUrl     : String?
}


import Foundation
import IGListKit

class Videos {
    private(set) var identifier   : String
    private(set) var address      : String
    private(set) var Zipcode      : String
    private(set) var city         : String
    private(set) var hashTagsModelList: [String]
    private(set) var Title        : String
    private(set) var description  : String
    private(set) var language     : String
    private(set) var ThumbnailUrl : String
    private(set) var videoUrl     : String

    init(identifier: String , address : String , Zipcode: String , city: String , hashTagsModelList: [String] , Title: String , description: String , language: String , ThumbnailUrl: String , videoUrl: String) {
        self.identifier   = identifier
        self.address      = address
        self.Zipcode      = Zipcode
        self.city         = city
        self.hashTagsModelList = hashTagsModelList
        self.Title        = Title
        self.description  = description
        self.language     = language
        self.ThumbnailUrl = ThumbnailUrl
        self.videoUrl     = videoUrl
        
    }
}
extension Videos: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return identifier as NSString
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? Videos else {
       return false
    }
    return self.identifier == object.identifier
  }
}
