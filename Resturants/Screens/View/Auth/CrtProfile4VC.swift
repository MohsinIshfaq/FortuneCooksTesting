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
    
    //MARK: - PROPERTIES
    var db = Firestore.firestore()
    var checkvalidPsd: Bool        = false
    
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
            if txtPsd.text == txtConfrmPsd.text{
                if imgTrms.image == UIImage(systemName: "checkmark.square") && imgPrivacy.image == UIImage(systemName: "checkmark.square") {
                    signUp()
                }
                else{
                    self.showToast(message: "Please accept the terms and conditions", seconds: 2, clr: .red)
                }
            }
            else{
                self.showToast(message: "Password should be same", seconds: 2, clr: .red)
            }
        }
        else{
            self.showToast(message: "Password is not valid", seconds: 2, clr: .red)
        }
//        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile5VC") as? CrtProfile5VC
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func gestureTrms(_ gesture: UIButton){
        if imgTrms.image      == UIImage(systemName: "checkmark.square") {
            imgTrms.image      = UIImage(systemName: "square")
        }
        else{
            imgTrms.image      = UIImage(systemName: "checkmark.square")
        }
    }
    @IBAction func gesturePrivacy(_ gesture: UIButton){
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
        txtConfrmPsd.delegate                    = self
    }
}
//MARK: - Textfield Validation {}
extension CrtProfile4VC: UISearchTextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        validateTextField(updatedText)
        return true
    }
    func validateTextField(_ txtfld: String) {
        if txtfld.count >= 8 {
            updateValidationStatus(true, message: "8 characters done", image: img8Charac)
        } else {
            updateValidationStatus(false, message: "At least 8 characters required", image: img8Charac)
        }
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        updateValidationStatus(uppercasePredicate.evaluate(with: txtfld),
                                message: "Minimum 1 uppercase letter done",
                                image: img1Upper)
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        updateValidationStatus(lowercasePredicate.evaluate(with: txtfld),
                                message: "Minimum 1 lowercase letter done",
                                image: img1Lower)
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        updateValidationStatus(numberPredicate.evaluate(with: txtfld),
                                message: "Minimum 1 number done",
                                image: img1number)
        if uppercasePredicate.evaluate(with: txtfld) && lowercasePredicate.evaluate(with: txtfld) && numberPredicate.evaluate(with: txtfld) && txtfld.count >= 8 {
             checkvalidPsd = true
        }
    }
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
        Auth.auth().createUser(withEmail: UserManager.shared.selectedEmail, password: txtPsd.text!) { [weak self] response, error in
            guard let self = self else { return }
            self.stopAnimating()
            if let error = error {
                self.showToast(message: error.localizedDescription, seconds: 2, clr: .red)
                return
            }
            guard let user = response?.user else {
                self.showToast(message: "User registration failed", seconds: 2, clr: .red)
                return
            }
            user.sendEmailVerification { error in
                if let error = error {
                    print("Error sending verification email: \(error.localizedDescription)")
                    self.showAlertWith(title: "Error", message: "Error sending verification email: \(error.localizedDescription)")
                    return
                }
                print("Verification email sent successfully.")
                self.showAlertWith(title: "FortuneCooks", message: "Verification email sent successfully.")
            }
            var id = user.uid
            UserDefault.token = id
            UserDefault.isAuthenticated = true
            
            self.db.collection("Users").document("\(id)").setData(
                ["selectedCuisine"                : UserManager.shared.selectedCuisine,
                 "selectedEnvironment"            : UserManager.shared.selectedEnviorment,
                 "selectedFeatures"               : UserManager.shared.selectedFeature,
                 "accountType"                    : UserManager.shared.selectedAccountType,
                 "address"                        : "",
                 "bio"                            : "",
                 "city"                           : "",
                 "uid"                            : "\(UserDefault.token)",
                 "website"                        : "",
                 "zipcode"                        : "",
                 "coverUrl"                       : "",
                 "profileUrl"                     : "",
                 "followers"                      : [],
                 "followings"                     : [],
                 "timings"                        : [],
                 "tagPersons"                     : [],
                 "selectedTypeOfRegion"           : [],
                 "selectedMeals"                  : UserManager.shared.selectedMeals,
                 "selectedSpecialize"             : UserManager.shared.selectedSpecial,
                 "channelName"                    : UserManager.shared.selectedChannelNm,
                 "dateOfBirth"                    : UserManager.shared.selectedDOB,
                 "email"                          : UserManager.shared.selectedEmail,
                 "phoneNumber"                    : UserManager.shared.selectedPhone]
            ) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    self.showToast(message: error.localizedDescription, seconds: 2, clr: .red)
                } else {
                    print("Document successfully written!")
//                    let vc = Constants.auth.instantiateViewController(withIdentifier: "TabbarController") as? TabbarController
//                    self.navigationController?.pushViewController(vc!, animated: true)
                    self.SaveUserForOthers()
                }
            }
        }
    }
    
    //Saving user for to be tag or follow {}
    func SaveUserForOthers() {
        var db = Firestore.firestore()
        let data: [String: Any] = [
            "uid"              : UserDefault.token ,
            "img"              : "",
            "channelName"      : UserManager.shared.selectedChannelNm,
            "followers"        : "",
            "accountType"      : UserManager.shared.selectedAccountType,
            
        ]
        db.collection("userCollection").addDocument(data: data) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                self?.stopAnimating()
                self?.showToast(message: "Error adding document: \(error.localizedDescription)", seconds: 2, clr: .red)
            } else {
                self?.showToast(message: "Document added successfully.", seconds: 2, clr: .gray)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.popRoot()
                }
            }
        }
    }

}
