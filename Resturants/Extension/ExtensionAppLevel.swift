//
//  ExtensionAppLevel.swift
//  Resturants
//
//  Created by Mohsin on 16/09/2024.
//

import Foundation
import AVKit
@_exported import IQKeyboardManager

var arrayAllUsers: [UserModel] = []
var uniqueID: String {
    return UUID().uuidString
}

func trim(_ stringContent : Any?) -> String
{
    if let content = stringContent
    {
        return String(describing:content).trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    else
    {
        return ""
    }
}

func DLog(_ log: Any, terminator: String = "\n", _ details:Bool = true, file:String = #file, function:String = #function, line:Int = #line) {
    var log = log
    
    if details {
        var fileName = file
        if let wFile = file.components(separatedBy: "/").last {
            fileName = wFile.replacingOccurrences(of: ".swift", with: "")
        }
        
        let formatedfunction = function.replacingOccurrences(of: "()", with: "")
        
        log = "\(fileName) : \(formatedfunction) [L:\(line)] \(log)"
    }
    
    #if targetEnvironment(simulator)
        print(log, terminator: terminator)
    #else
        if let log = log as? String {
            NSLog("%@", log)
        }
    #endif
}

func getTimeStapToDate(_ timestamp: TimeInterval) -> String {
    let currentDate = Date()
    let timestampDate = Date(timeIntervalSince1970: timestamp)
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: timestampDate, to: currentDate)

    if let year = components.year, year >= 1 {
        return year == 1 ? "1 year ago" : "\(year) years ago"
    } else if let month = components.month, month >= 1 {
        return month == 1 ? "1 month ago" : "\(month) months ago"
    } else if let week = components.weekOfYear, week >= 1 {
        return week == 1 ? "1 week ago" : "\(week) weeks ago"
    } else if let day = components.day, day >= 2 {
        return "\(day) days ago"
    } else if let day = components.day, day == 1 {
        return "Yesterday"
    } else {
        return "Today"
    }
}

func formatTime(from time: CMTime) -> String {
    let totalSeconds = CMTimeGetSeconds(time)
    let hours = Int(totalSeconds / 3600)
    let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
    let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
    
    if hours > 0 {
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    } else {
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
