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
    
    var isFromVideos = false     // to handle videos and swift when click upload in profile
    
    var reelsModel      : [ProfileVideosModel]? = []
    var videosModel     : [ProfileVideosModel]? = []
    
    var ownerProfileFollowing: [UserTagModel]  = []
    var ownerTagPeoples      : [TagUsers]      = []
    
    var totalTagPeople             : Int              = 0
    var finalURL                   : URL?             = nil
    var thumbnail                  : UIImage?         = nil
    var gothroughUploading         : Bool             = false
    
    var filteredCuisine            : [[String]]       = []
    var filteredEnviorment         : [[String]]       = []
    var filteredFeature            : [[String]]       = []
    var filteredMeals              : [[String]]       = []
    var filteredSpeacials          : [[String]]       = []
    var filteredContent            : [[String]]       = []
    var filteredAccntType          : [[String]]       = []
    
    let currencies = [
        "USD", // US Dollar
        "EUR", // Euro
        "JPY", // Japanese Yen
        "GBP", // British Pound
        "AUD", // Australian Dollar
        "CAD", // Canadian Dollar
        "CHF", // Swiss Franc
        "CNY", // Chinese Yuan
        "INR", // Indian Rupee
        "BRL", // Brazilian Real
        "RUB", // Russian Ruble
        "ZAR", // South African Rand
        "SGD", // Singapore Dollar
        "MXN", // Mexican Peso
        "HKD", // Hong Kong Dollar
        "KRW", // South Korean Won
        "TRY", // Turkish Lira
        "NOK", // Norwegian Krone
        "SEK", // Swedish Krona
        "NZD"  // New Zealand Dollar
    ]
    
    var arrReason                  : [String]         =
    ["I do not have time" ,
     "Health issue" ,
     "Too much advertising" ,
     "something else"]
    var arrTagPeoples                                 = [
        ["Breakfast" , "0"],
        ["Brunch" , "0"],
        ["Lunch" , "0"],
        ["Dinner" , "0"],
        ["Dessert" , "0"],
        ["Coffee" , "0"]]
    let arrlanguages                                  = [
        "Afrikaans",
        "Amharic",
        "Arabic",
        "Bengali",
        "Burmese",
        "Chinese",
        "Danish",
        "Dutch",
        "English",
        "Farsi",
        "Filipino",
        "Finnish",
        "French",
        "German",
        "Greek",
        "Hausa",
        "Hebrew",
        "Hindi",
        "Igbo",
        "Indonesian",
        "Italian",
        "Japanese",
        "Kazakh",
        "Khmer",
        "Korean",
        "Kurdish",
        "Kyrgyz",
        "Lao",
        "Malay",
        "Marathi",
        "Nepali",
        "Norwegian",
        "Pashto",
        "Persian",
        "Portuguese",
        "Punjabi",
        "Russian",
        "Sindhi",
        "Sinhala",
        "Spanish",
        "Swahili",
        "Swedish",
        "Tamil",
        "Telugu",
        "Thai",
        "Turkish",
        "Turkmen",
        "Urdu",
        "Uzbek",
        "Vietnamese",
        "Xhosa",
        "Yoruba",
        "Zulu"
    ]

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
    var arrAccntType                                  = [
       ["Private person","0"],
       ["Content Creator","0"],
       ["Restaurant","0"],
       ["Cafeteria","0"],
       ["Grocery_store","0"],
       ["Wholesaler","0"],
       ["Bakery","0"],
       ["Food_producer","0"],
       ["Beverage_manufacturer","0"],
       ["Food_truck","0"],
       ["Hotel","0"]
   ]
    var arrContent                                    = [
        ["Asmr", "0"],
        ["Family and friends", "0"],
        ["Content for kids", "0"],
        ["Eat and talk", "0"],
        ["Restaurants review", "0"],
        ["GRWM", "0"],
        ["Behind the-Scenes", "0"],
        ["Food Challenges and Contests", "0"],
        ["Collaborations with Influencers", "0"],
        ["Food History and Fun Facts", "0"],
        ["Home cooking snacks tips", "0"],
        ["Cooking quality food on a budget", "0"],
        ["Get to know us", "0"],
        ["Get to know me", "0"],
        ["Experiment", "0"],
        ["Food tourism", "0"],
        ["Video of food prep", "0"],
        ["Food critic", "0"],
        ["Take out", "0"],
        ["Couple goals", "0"],
        ["Halal diet", "0"],
        ["Kosher", "0"],
        ["Vegan", "0"],
        ["Vegetarian", "0"],
        ["Gluten free", "0"]]
    var arrCuisine                                    = [
        ["African", "0"],
        ["American", "0"],
        ["Asian", "0"],
        ["Brazilian", "0"],
        ["British", "0"],
        ["Chinese", "0"],
        ["Eastern European", "0"],
        ["Ethiopian", "0"],
        ["European", "0"],
        ["French", "0"],
        ["From the Mediterranean", "0"],
        ["Fusion/Crossover", "0"],
        ["German", "0"],
        ["Greek", "0"],
        ["Grilled", "0"],
        ["Indian", "0"],
        ["Italian", "0"],
        ["Japanese", "0"],
        ["Korean", "0"],
        ["Latin American", "0"],
        ["Lebanese", "0"],
        ["Mexican", "0"],
        ["Moroccan", "0"],
        ["Oriental", "0"],
        ["Pakistani", "0"],
        ["Persian", "0"],
        ["Peruvian", "0"],
        ["Portuguese", "0"],
        ["Scandinavian", "0"],
        ["Somali", "0"],
        ["Spanish", "0"],
        ["Steakhouse", "0"],
        ["Swedish", "0"],
        ["Swiss", "0"],
        ["Thai", "0"],
        ["Traditional food", "0"],
        ["Tunisian", "0"],
        ["Turkish", "0"]
    ]
    var arrEnviorment                                 = [
        ["After work", "0"],
        ["Bachelor & bachelorette party", "0"],
        ["Birthday", "0"],
        ["Breakfast", "0"],
        ["Brunch", "0"],
        ["Buffet", "0"],
        ["Business dinner", "0"],
        ["By the sea", "0"],
        ["By the water", "0"],
        ["Central location", "0"],
        ["Coffe", "0"],
        ["Dessert", "0"],
        ["Dinner", "0"],
        ["Dinner cruise", "0"],
        ["Fantastic view", "0"],
        ["Garden", "0"],
        ["Gastronomic", "0"],
        ["Groups", "0"],
        ["Hotel restaurant", "0"],
        ["Live music", "0"],
        ["Lunch", "0"],
        ["Modern food", "0"],
        ["On the beach", "0"],
        ["Outdoor seating", "0"],
        ["Raw food", "0"],
        ["Street food", "0"],
        ["Tavern", "0"],
        ["Traditional", "0"],
        ["Trendy", "0"],
        ["Wedding", "0"],
        ["Wine bar Meals", "0"],
        ["With family", "0"],
        ["With friends", "0"]
    ]
    var arrFeature                                    = [
        ["Accepts American Express", "0"],
        ["Accepts credit cards", "0"],
        ["Buffet", "0"],
        ["Card payment only", "0"],
        ["Cash only Specelize", "0"],
        ["Delivery", "0"],
        ["Dogs allowed", "0"],
        ["Free wifi", "0"],
        ["Gift cards available", "0"],
        ["Gluten-free options", "0"],
        ["Halal Options", "0"],
        ["Highchairs available", "0"],
        ["Kosher options", "0"],
        ["Outdoor seating", "0"],
        ["Reservations", "0"],
        ["Seating", "0"],
        ["Street parking", "0"],
        ["Takeout", "0"],
        ["Vegan options", "0"],
        ["Vegetarian options", "0"],
        ["Wheelchair accessible", "0"]
    ]
    var arrMeals                                      = [
        ["Breakfast" , "0"],
        ["Brunch" , "0"],
        ["Coffee" , "0"],
        ["Dinner" , "0"],
        ["Dessert" , "0"],
        ["Lunch" , "0"]
        ]
    var arrSpeacials                                  = [
        ["Halal Options" , "0"],
        ["Kosher options" , "0"],
        ["Gluten-free options" , "0"],
        ["Vegan options" , "0"],
        ["Vegetarian options" , "0"]]
    
    //MARK: - UpdateMenu
    var listCuisine                                    = [
        "African",
        "American",
        "Asian",
        "Brazilian",
        "British",
        "Chinese",
        "Eastern European",
        "Ethiopian",
        "European",
        "French",
        "From the Mediterranean",
        "Fusion/Crossover",
        "German",
        "Greek",
        "Grilled",
        "Indian",
        "Italian",
        "Japanese",
        "Korean",
        "Latin American",
        "Lebanese",
        "Mexican",
        "Moroccan",
        "Oriental",
        "Pakistani",
        "Persian",
        "Peruvian",
        "Portuguese",
        "Scandinavian",
        "Somali",
        "Spanish",
        "Steakhouse",
        "Swedish",
        "Swiss",
        "Thai",
        "Traditional food",
        "Tunisian",
        "Turkish"
    ]
    var listEnviorment                                  = [
        "After work",
        "Bachelor & bachelorette party",
        "Birthday",
        "Breakfast",
        "Brunch",
        "Buffet",
        "Business dinner",
        "By the sea",
        "By the water",
        "Central location",
        "Coffe",
        "Dessert",
        "Dinner",
        "Dinner cruise",
        "Fantastic view",
        "Garden",
        "Gastronomic",
        "Groups",
        "Hotel restaurant",
        "Live music",
        "Lunch",
        "Modern food",
        "On the beach",
        "Outdoor seating",
        "Raw food",
        "Street food",
        "Tavern",
        "Traditional",
        "Trendy",
        "Wedding",
        "Wine bar Meals",
        "With family",
        "With friends"
    ]
    var listMeals                                      = [
        "Breakfast" ,
        "Brunch" ,
        "Coffee" ,
        "Dinner" ,
        "Dessert" ,
        "Lunch"
        ]
    var listSpeacials                                  = [
        "Halal Options" ,
        "Kosher options" ,
        "Gluten-free options" ,
        "Vegan options" ,
        "Vegetarian options"]
    var listFeature                                    = [
        "Accepts American Express",
        "Accepts credit cards",
        "Buffet",
        "Card payment only",
        "Cash only Specelize",
        "Delivery",
        "Dogs allowed",
        "Free wifi",
        "Gift cards available",
        "Gluten-free options",
        "Halal Options",
        "Highchairs available",
        "Kosher options",
        "Outdoor seating",
        "Reservations",
        "Seating",
        "Street parking",
        "Takeout",
        "Vegan options",
        "Vegetarian options",
        "Wheelchair accessible"]
    
    //MARK: - DATA for Firestore
     var selectedContent           : [String]          = []
     var selectedFeedAccnt         : [String]          = []
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
    
    let arrHour                     : [String]         = ["00" , "01" , "02" , "03" , "04" , "05" , "06" , "07" , "08" , "09" , "10" , "11" , "12" , "13" , "14" , "15" , "16" , "17" , "18" , "19" , "20" , "21" , "22", "23"]
    let arrMints                     : [String]         = [ "00" , "01" , "02" , "03" , "04" , "05" , "06" , "07" , "08" , "09" , "10" , "11" , "12" , "13" , "14" , "15" , "16" , "17" , "18" , "19" , "20" , "21" , "22", "23" , "24" , "25" , "26" , "27" , "28" , "29" , "30" , "31" , "32" , "33" , "34" , "35" , "36" , "37" , "38" , "39" , "40" , "41" , "42" , "43" , "44" , "45" , "46" , "47" , "48" , "49" , "50" , "51" , "52" , "53" , "54" , "55" , "56" , "57" , "58" , "59"]
    
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
