//
//  BaseViewModel.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation

class BaseViewModel {
    
    func getErrorMessage(data: Any?) -> String {

        if let data : Data = data as? Data {

            let decoder = JSONDecoder()

            do {

//                let msg = try decoder.decode(Response_Model.self, from: data)
//                return msg.message ?? ""

            } catch {
                
                return "Something went wrong try again!"
                print(error.localizedDescription)
            }
        }
        return ""
    }
    
    //MARK: - Regex {}
    
    //MARK: - Email
    func isValidEmail(_ email: String) -> String {
        
        if email == "" {
            
            return "Email Field is empty"
        }
        else if email.isValidEmailRegex(email) == false {
            
            return "Email is not Valid"
        }
        else {
            
            return ""
        }
    }
    
    func isValidPassword(_ psd : String) -> String {
        
        if psd == "" {
            
            return "Password field is empty"
        }
        else if psd.count < 5{
            
            return "Password count should greater than 5 "
        }
        else {
            
            return ""
        }
    }
    
    func isValidPhoneNumber(_ number: String) -> String {
        
        if number == "" {
            
            return "Phone Number Field is empty"
        }
        else if number.validPhoneRegex(value: number) == false {
            
            return "Phone Number  is not Valid"
        }
        else {
            
            return ""
        }
    }
    
    func isValidString(string : String) -> String {
        
        if string == "" {
            
           return  "Name Field is Empty"
        }
        else if string.count < 3 {
           
            return  "Name count should be greater than 3"
        }
        
        else if string.isValidNameRegex == false {
            
            return "Special Character and Space is not Allowed in Name Field"
        }
        else {
            
            return ""
        }
    }
    
}
