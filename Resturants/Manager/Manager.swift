//
//  Manager.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation
import UIKit

//MARK: - Class Manager
final class UserManager {
    
    static let shared     = UserManager()
    private init () {}
    
    var finalURL                   : URL?             = nil
    var thumbnail                  : UIImage?         = nil
    
    let arrAccnt                                      = [
       "Private person",
       "Content Creator",
       "Restaurant",
       "Cafeteria",
       "Grocery_store",
       "Wholesaler",
       "Bakery",
       "Food_producer",
       "Beverage_manufacturer",
       "Food_truck",
       "Hotel"
   ]
    var filteredCuisine            : [[String]]       = []
    var filteredEnviorment         : [[String]]       = []
    var filteredFeature            : [[String]]       = []
    var filteredMeals              : [[String]]       = []
    var filteredSpeacials          : [[String]]       = []
    
    var arrCuisine                                    = [["African" , "0"],
                                    ["American" , "0"],
                                    ["Asian" , "0"],
                                    ["Brazilian" , "0"],
                                    ["British" , "0"],
                                    ["Ethiopian" , "0"],
                                    ["European" , "0"],
                                    ["French" , "0"],
                                    ["From the Mediterranean" , "0"] ,
                                    ["Fusion/Crossover" , "0"],
                                    ["Greek" , "0"],
                                    ["Grilled" , "0"],
                                    [ "Indian" , "0"],
                                    ["Italian" , "0"],
                                    ["Japanese" , "0"],
                                    ["Chinese" , "0"],
                                    ["Korean" , "0"],
                                    [ "Latin American" , "0"],
                                    ["Lebanese" , "0"],
                                    ["Moroccan" , "0"],
                                    ["Mexican" , "0"],
                                    ["Oriental" , "0"],
                                    ["Pakistani" , "0"],
                                    ["Persian" , "0"],
                                    ["Peruvian" , "0"],
                                    ["Portuguese" , "0"],
                                    ["Swiss" , "0"],
                                    [ "Scandinavian" , "0"],
                                    ["Spanish" , "0"],
                                    ["Steakhouse" , "0"],
                                    [ "Swedish" , "0"],
                                    ["Somali" , "0"],
                                    ["Thai" , "0"],
                                    [ "Traditional food" , "0"],
                                    ["Tunisian" , "0"],
                                    ["Turkish" , "0"],
                                    ["German" , "0"],
                                    ["Eastern European" , "0"]]
    var arrEnviorment                                 = [["Business dinner" , "0"],
                                      [ "After work" , "0"],
                                      [ "Brunch" , "0"],
                                      ["Wedding" , "0"],
                                      ["Buffet" , "0"],
                                      ["Central location" , "0"],
                                      ["Fantastic view" , "0"],
                                      ["Birthday" , "0"],
                                      ["Gastronomic" , "0"],
                                      ["Groups" , "0"],
                                      ["Hotel restaurant" , "0"],
                                      ["Tavern" , "0"],
                                      ["Live music" , "0"],
                                      ["With family" , "0"],
                                      ["With friends" , "0"],
                                      ["Dinner cruise" , "0"],
                                      ["Modern food" , "0"],
                                      ["On the beach" , "0"],
                                      ["Raw food" , "0"],
                                      ["Street food" , "0"],
                                      ["Bachelor & bachelorette party" , "0"],
                                      ["Traditional" , "0"] ,
                                      ["Trendy" , "0"],
                                      ["Garden" , "0"],
                                      ["Outdoor seating" , "0"],
                                      ["By the sea" , "0"],
                                      ["By the water" , "0"],
                                      ["Wine bar Meals" , "0"] ,
                                      ["Breakfast" , "0"],
                                      ["Brunch" , "0"],
                                      ["Lunch" , "0"],
                                      ["Dinner" , "0"],
                                      ["Dessert" , "0"],
                                      ["Coffe" , "0"]]
    var arrFeature                                    = [["Seating" , "0"],
                                      ["Reservations" , "0"],
                                      ["Takeout" , "0"],
                                      ["Delivery" , "0"],
                                      ["Buffet" , "0"],
                                      ["Accepts credit cards" , "0"],
                                      ["Outdoor seating" , "0"],
                                      ["Wheelchair accessible" , "0"],
                                      ["Highchairs available" , "0"],
                                      ["Free wifi" , "0"],
                                      ["Street parking" , "0"],
                                      ["Accepts American Express" , "0"],
                                      ["Dogs allowed" , "0"],
                                      ["Gift cards available" , "0"],
                                      ["Card payment only" , "0"],
                                      ["Cash only Specelize" , "0"] ,
                                      ["Halal Options" , "0"] ,
                                      ["Kosher options" , "0"] ,
                                      ["Vegan options" , "0"],
                                      ["Vegetarian options" , "0"],
                                      ["Gluten-free options" , "0"]]
    var arrMeals                                      = [["Breakfast" , "0"],
                               ["Brunch" , "0"],
                               ["Lunch" , "0"],
                               ["Dinner" , "0"],
                               ["Dessert" , "0"],
                               ["Coffee" , "0"]]
    var arrSpeacials                                  = [["Halal Options" , "0"],
                               ["Kosher options" , "0"],
                               ["Vegan options" , "0"],
                               ["Vegetarian options" , "0"],
                               ["Gluten-free options" , "0"]]
    
    //MARK: - DATA for Firestore
     var selectedCuisine           : [String]          = []
     var selectedEnviorment        : [String]          = []
     var selectedFeature           : [String]          = []
     var selectedMeals             : [String]          = []
     var selectedSpecial           : [String]          = []
     var selectedAccountType       : String            = ""
     var selectedChannelNm         : String            = ""
     var selectedDOB               : String            = ""
     var selectedEmail             : String            = ""
     var selectedPhone             : String            = ""
    
    let filterDisplayNameList                          = [
        "Normal",
        "Chrome",
        "Fade",
        "Instant",
        "Mono",
        "Noir",
        "Process",
        "Tonal",
        "Transfer",
        "Tone",
        "Linear"
    ]
    let filterNameList                                 = [
        "No Filter",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
    var FakefilterNameList                             = [
        ["No Filter", 1],
        ["CIPhotoEffectChrome", 0],
        ["CIPhotoEffectFade", 0],
        ["CIPhotoEffectInstant", 0],
        ["CIPhotoEffectMono", 0],
        ["CIPhotoEffectNoir", 0],
        ["CIPhotoEffectProcess", 0],
        ["CIPhotoEffectTonal", 0],
        ["CIPhotoEffectTransfer", 0],
        ["CILinearToSRGBToneCurve", 0],
        ["CISRGBToneCurveToLinear", 0],
    ]
}


extension FileManager {
    func removeItemIfExisted(_ url:URL) -> Void {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            }
            catch {
                print("Failed to delete file")
            }
        }
    }
}
