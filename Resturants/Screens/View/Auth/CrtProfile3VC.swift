//
//  CrtProfile3VC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit
import CountryPickerView
import Firebase

class CrtProfile3VC: UIViewController  {

    //MARK: - @IBOutlets
    @IBOutlet weak var txtEmailAddress:   UITextField!
    @IBOutlet weak var txtPhoneNumbr  :   UITextField!
    let cpv = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onlaod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    @IBAction func ontapNextStep(_ sender: UIButton){
        
        UserManager.shared.selectedPhone = cpv.selectedCountry.phoneCode + txtPhoneNumbr.text!
        UserManager.shared.selectedEmail = txtEmailAddress.text!
        if checkCredentials(txtEmailAddress.text!) {
            if "".validPhoneRegex(value: txtPhoneNumbr.text!){
                let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile4VC") as? CrtProfile4VC
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            else{
                self.showToast(message: "Phone number is not valid", seconds: 2.0, clr: .red)
            }
        }
        else{
            self.showToast(message: "Email is not valid", seconds: 2.0, clr: .red)
        }
    }
}
//MARK: - Setup Profile {}
extension CrtProfile3VC {
    
    func onlaod(){
        txtPhoneNumbr.leftView = cpv
        txtPhoneNumbr.leftViewMode = .always
        cpv.textColor = .white
        //self.navigationController?.removeBackground()
    }
    func checkCredentials(_  email: String) -> Bool{
        
        if "".isValidEmailRegex(email) {
            return true
        }
        else{
            return false
        }
    }
    func onAppear(){
        removeNavBackbuttonTitle()
        self.navigationItem.title  = "Create Email & Password"
        self.navigationController?.removeBackground()
    }
}

//MARK: - Setup Profile {}
extension CrtProfile3VC {
    
    func verifyPhoneNUmber() {
        self.startAnimating()
        PhoneAuthProvider.provider().verifyPhoneNumber("+923454085461", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.stopAnimating()
                // Handle error
                print("Error in verification: \(error.localizedDescription)")
                self.showToast(message: "Error in verification: \(error.localizedDescription)", seconds: 2, clr: .red)
                return
            }
            self.stopAnimating()
            print("\(verificationID)")
            // Verification code sent successfully
            // Save verification ID for later use
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            // Prompt user to enter the verification code
            // You can show UI to input the verification code here
        }
    }
}
