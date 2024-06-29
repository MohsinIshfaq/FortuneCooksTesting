//
//  ChangePsdVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit
import FirebaseAuth

protocol verifyPasswordDelegate{
    func verified()
}
class VerifyPasswordVC: UIViewController {

    //MARK: - OUtlets
    @IBOutlet weak var txtPsd       : UITextField!
    @IBOutlet weak var btnToglePsd  : UIButton!
    @IBOutlet weak var img8Charac   : UIImageView!
    @IBOutlet weak var img1Upper    : UIImageView!
    @IBOutlet weak var img1Lower    : UIImageView!
    @IBOutlet weak var img1number   : UIImageView!
    
    var checkvalidPsd: Bool               = false
    var profileModel: UserProfileModel?   = nil
    var delegate: verifyPasswordDelegate? = nil
    
    var isFromWhere: String              = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapToglePsd(_ sender: UIButton){
        if txtPsd.isSecureTextEntry == false {
            txtPsd.isSecureTextEntry = true
            btnToglePsd.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        else if txtPsd.isSecureTextEntry == true {
            txtPsd.isSecureTextEntry = false
            btnToglePsd.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
    
    @IBAction func ontapNext(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "NewPsdVC") as! NewPsdVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapConfirm(_ sender: UIButton){
        if checkvalidPsd {
            verifyPassword()
        }
        else{
            self.showToast(message: "Password is not valid", seconds: 2, clr: .red)
        }
    }
    
}

//MARK: - Setup Profile {}
extension VerifyPasswordVC {
   
    func onload() {
        removeNavBackbuttonTitle()
        txtPsd.delegate                          = self
    }
    
    func onAppear() {
        if isFromWhere == "ChangePassword" {
            self.navigationItem.title = "Change Password"
        }
        else if isFromWhere == "JustVerifyPsd" || isFromWhere == "VerifyAndDeleteAccnt"{
            self.navigationItem.title = "Verify Password"
        }
    }
}

//MARK: - Password Validation {}
extension VerifyPasswordVC: UISearchTextFieldDelegate {
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

//MARK: - Verify Password {}
extension VerifyPasswordVC {
    
    func verifyPassword() {
        self.startAnimating()
        let credential = EmailAuthProvider.credential(withEmail: self.profileModel?.email ?? "", password: txtPsd.text!)
        Auth.auth().currentUser?.reauthenticate(with: credential) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                self?.stopAnimating()
                self?.showToast(message: "Re-authentication failed: \(error.localizedDescription)", seconds: 2, clr: .red)
            } else {
                self?.stopAnimating()
                if self?.isFromWhere == "ChangePassword"{
                    let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "NewPsdVC") as! NewPsdVC
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                else if self?.isFromWhere == "JustVerifyPsd"{
                    self?.delegate?.verified()
                }else if self?.isFromWhere == "VerifyAndDeleteAccnt" {
                    let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AccntDeleteReasonVC") as! AccntDeleteReasonVC
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
