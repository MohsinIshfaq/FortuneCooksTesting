//
//  CrtProfile4VC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class CrtProfile4VC: UIViewController {
    
     //MARK: - IBOUTLETS
    @IBOutlet weak var txtPsd       : UITextField!
    @IBOutlet weak var btnToglePsd  : UIButton!
    @IBOutlet weak var txtConfrmPsd : UITextField!
    @IBOutlet weak var btnTogleConPsd  : UIButton!
    @IBOutlet weak var img8Charac   : UIImageView!
    @IBOutlet weak var img1Upper    : UIImageView!
    @IBOutlet weak var img1Lower    : UIImageView!
    @IBOutlet weak var img1number   : UIImageView!
    
    @IBOutlet weak var imgTrms      : UIImageView!
    @IBOutlet weak var imgPrivacy   : UIImageView!
     var checkvalidPsd: Bool        = false
    
    //MARK: - PROPERTIES
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    @IBAction func ontapToglePsd(_ sender: UIButton){
        if txtPsd.isSecureTextEntry == false {

            txtPsd.isSecureTextEntry = true
            btnToglePsd.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        else if txtPsd.isSecureTextEntry == true {

            txtPsd.isSecureTextEntry = false
            btnToglePsd.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    @IBAction func ontapTogleConPsd(_ sender: UIButton){
        if txtConfrmPsd.isSecureTextEntry == false {

            txtConfrmPsd.isSecureTextEntry = true
            btnTogleConPsd.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        else if txtConfrmPsd.isSecureTextEntry == true {

            txtConfrmPsd.isSecureTextEntry = false
            btnTogleConPsd.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    @IBAction func ontapNextStep(_ sender: UIButton){
        
        if checkvalidPsd {
            signUp()
        }
        else{
            self.showToast(message: "Password is not valid", seconds: 2, clr: .red)
        }
//        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile5VC") as? CrtProfile5VC
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func gestureTrms(_ gesture:UITapGestureRecognizer){
        
        if imgTrms.image      == UIImage(systemName: "checkmark.square") {
            imgTrms.image      = UIImage(systemName: "square")
        }
        else{
            imgTrms.image      = UIImage(systemName: "checkmark.square")
        }
    }
    @objc func gesturePrivacy(_ gesture:UITapGestureRecognizer){
        
        if imgPrivacy.image      == UIImage(systemName: "checkmark.square") {
            imgPrivacy.image      = UIImage(systemName: "square")
        }
        else{
            imgPrivacy.image      = UIImage(systemName: "checkmark.square")
        }
    }

}

//MARK: - Cutom Implementation {}
extension CrtProfile4VC {
    
    func onLoad() {
      
        setupView()
    }
    
    func onAppear() {
        removeNavBackbuttonTitle()
        self.navigationItem.title  = "Create Email & Password"
    }
    
    func setupView() {
        
        txtPsd.delegate                          = self
    }
}
//MARK: - Textfield Validation {}
extension CrtProfile4VC: UISearchTextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the updated text field content
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Use your validation function here
        validateTextField(updatedText)
        // Return true to allow the text field to be updated
        return true
    }
    
    func validateTextField(_ txtfld: String) {
        // Check if the text field contains at least 8 characters
        if txtfld.count >= 8 {
            updateValidationStatus(true, message: "8 characters done", image: img8Charac)
        } else {
            updateValidationStatus(false, message: "At least 8 characters required", image: img8Charac)
        }

        // Check if the text field contains at least 1 uppercase letter
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        updateValidationStatus(uppercasePredicate.evaluate(with: txtfld),
                                message: "Minimum 1 uppercase letter done",
                                image: img1Upper)

        // Check if the text field contains at least 1 lowercase letter
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        updateValidationStatus(lowercasePredicate.evaluate(with: txtfld),
                                message: "Minimum 1 lowercase letter done",
                                image: img1Lower)

        // Check if the text field contains at least 1 number
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        updateValidationStatus(numberPredicate.evaluate(with: txtfld),
                                message: "Minimum 1 number done",
                                image: img1number)
        if uppercasePredicate.evaluate(with: txtfld) && lowercasePredicate.evaluate(with: txtfld) && numberPredicate.evaluate(with: txtfld) {
             checkvalidPsd = true
        }
    }

    // Helper function to update validation status
    func updateValidationStatus(_ isValid: Bool, message: String, image: UIImageView) {
        print(message)

        if isValid {
            image.image = UIImage(systemName: "checkmark.circle")
            image.tintColor = UIColor.ColorDarkGreen
        } else {
            image.image = UIImage(systemName: "multiply.circle")
            image.tintColor = .red
        }
    }
}

//MARK: - Call for  SignUP {}
extension CrtProfile4VC {
    
    func signUp() {
        
        self.startAnimating()
        Auth.auth().createUser(withEmail: UserManager.shared.selectedEmail, password: txtPsd.text!) { Response, error in
            self.stopAnimating()
            if error == nil {
                print("user successfully Registered")
                var id = Firebase.Auth.auth().currentUser?.uid ?? ""
                UserDefault.token = id
                UserDefault.isAuthenticated = true
                self.db.collection("Accounts").document("\(id)").setData(

                    ["Cuisine"       : UserManager.shared.selectedCuisine,
                     "Enviorment"    : UserManager.shared.selectedEnviorment,
                     "Feature"       : UserManager.shared.selectedFeature,
                     "AccountType"   : UserManager.shared.selectedAccountType,
                     "Meal"          : UserManager.shared.selectedMeals,
                     "Specailizaiton": UserManager.shared.selectedSpecial,
                     "ChannelName"   : UserManager.shared.selectedChannelNm,
                     "DOB"           : UserManager.shared.selectedDOB,
                     "Email"         : UserManager.shared.selectedEmail,
                     "PhoneNumber"   : UserManager.shared.selectedPhone]
                )
                { err in
                    if let err = err {
                        self.stopAnimating()
                        print("Error writing document: \(err)")
                        self.showToast(message: error?.localizedDescription ?? "", seconds: 2, clr: .red)
                    } else {
                        self.stopAnimating()
                        print("Document successfully written!")
                        let vc = Constants.TabControllerStoryBoard.instantiateViewController(withIdentifier: "TabbarController") as? TabbarController
                                self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }
            }
            else {
                self.stopAnimating()
                self.showToast(message: error?.localizedDescription ?? "", seconds: 2, clr: .red)
            }
            
        }
    }
}
