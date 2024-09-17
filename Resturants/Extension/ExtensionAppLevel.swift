//
//  ExtensionAppLevel.swift
//  Resturants
//
//  Created by Mohsin on 16/09/2024.
//

import Foundation


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
