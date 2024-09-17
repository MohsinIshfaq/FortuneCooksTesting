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

//Tag Users Model
struct UserTagModel {
    let uid: String?
    let img: String?
    let channelName: String?
    let followers: String?
    let accountType: String?
    var selected   : Int?
    
    func toDictionary() -> [String: Any] {
           return [
               "uid": uid ?? "",
               "img": img ?? "",
               "channelName": channelName ?? "",
               "followers": followers ?? "",
               "accountType": accountType ?? ""
           ]
       }
}


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
    var followers: [TagUsers]?
    var followings: [TagUsers]?
    var timings: [String]?
    var tagPersons: [TagUsers]?
    var blockUsers: [TagUsers]?
    var selectedTypeOfRegion: [String]?
    var selectedMeals: [String]?
    var selectedSpecialize: [String]?
    var channelName: String?
    var dateOfBirth: String?
    var email: String?
    var phoneNumber: String?
    var businessEmail: String?
    var businessphoneNumber: String?
    var isFoundedVisible: Bool?
}

struct TagUsers {
    let uid: String?
    let img: String?
    let channelName: String?
    let followers: String?
    let accountType: String?
    var selected   : Int?
    
    func toDictionary() -> [String: Any] {
           return [
               "uid": uid ?? "",
               "img": img ?? "",
               "channelName": channelName ?? "",
               "followers": followers ?? "",
               "accountType": accountType ?? ""
           ]
       }
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


struct ProfileVideosModel {
    let uid          : String?
    let id           : String?
    let address      : String?
    let Zipcode      : String?
    let city         : String?
    let Title        : String?
    let tagPersons   : [UserTagModel]?
    let description  : String?
    let categories   : [String]?
    let hashtages    : [String]?
    let language     : String?
    let thumbnailUrl : String?
    let videoUrl     : String?
    let likes        : Bool?
    let comments     : [CommentModel]?
    let views        : Bool?
    let paidCollab   : Bool?
    let introVideos  : Bool?
}

struct CommentModel {
    let id: String?
    let likes: [String]?
    let replies: [ReplyModel]?
    let text: String?
    let timestamp: Double?
    let uid: String?
}

struct ReplyModel {
    let id: String?
    let likes: [String]?
    let text: String?
    let timestamp: Double?
    let uid: String?
}

func parseCommentData(data: [String: Any]) -> CommentModel {
    let id = data["id"] as? String ?? ""
    let likes = data["likes"] as? [String] ?? []
    let repliesData = data["replies"] as? [[String: Any]] ?? []
    
    // Parse replies into an array of ReplyModel
    let replies = repliesData.map { replyData -> ReplyModel in
        let replyId = replyData["id"] as? String ?? ""
        let replyLikes = replyData["likes"] as? [String] ?? []
        let replyText = replyData["text"] as? String ?? ""
        let replyTimestamp = replyData["timestamp"] as? Double ?? 0.0
        let replyUid = replyData["uid"] as? String ?? ""
        
        return ReplyModel(id: replyId, likes: replyLikes, text: replyText, timestamp: replyTimestamp, uid: replyUid)
    }
    
    let text = data["text"] as? String ?? ""
    let timestamp = data["timestamp"] as? Double ?? 0.0
    let uid = data["uid"] as? String ?? ""
    
    return CommentModel(id: id, likes: likes, replies: replies, text: text, timestamp: timestamp, uid: uid)
}

struct UserFeedModel {
    let selectedAcountType : [String]?
    let selectedCuisine    : [String]?
    let selectedLanguages  : [String]?
    let selectedHashtags   : [String]?
}




import Foundation
import IGListKit

class Videos {
    private(set) var identifier   : String
    private(set) var uid           : String
    private(set) var address      : String
    private(set) var Zipcode      : String
    private(set) var city         : String
    private(set) var hashTagsModelList: [String]
    private(set) var Title        : String
    private(set) var description  : String
    private(set) var language     : String
    private(set) var ThumbnailUrl : String
    private(set) var videoUrl     : String

    init(identifier: String  , uid: String, address : String , Zipcode: String , city: String , hashTagsModelList: [String] , Title: String , description: String , language: String , ThumbnailUrl: String , videoUrl: String) {
        self.identifier   = identifier
        self.uid           = uid
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
