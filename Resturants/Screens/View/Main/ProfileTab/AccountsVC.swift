//
//  AccountsVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit
import FirebaseFirestoreInternal

class AccountsVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var switchfounded: UISwitch!
    
    var profileModel: UserProfileModel?   = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapChangePsd(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "VerifyPasswordVC") as! VerifyPasswordVC
        vc.hidesBottomBarWhenPushed = true
        vc.profileModel = self.profileModel
        vc.isFromWhere  = "ChangePassword"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapDeleteAccnt(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "VerifyPasswordVC") as! VerifyPasswordVC
        vc.hidesBottomBarWhenPushed = true
        vc.profileModel = self.profileModel
        vc.isFromWhere  = "VerifyAndDeleteAccnt"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapSave(_ sender: UIButton){
        updateStatus(UserDefault.token)
    }
}

//MARK: - Setup Profile {}
extension AccountsVC {
    
    func onload() {
        
        removeNavBackbuttonTitle()
        setupProfileData()
        switchfounded.isOn = profileModel?.isFoundedVisible ?? false
    }
    
    func onAppear() {
        self.navigationItem.title = "Accounts"
    }
    
    func setupProfileData() {
        
        self.txtEmail.text = profileModel?.email ?? ""
        self.txtPhone.text = profileModel?.phoneNumber ?? ""
    }
}

//MARK: - Save Bio in Profile {}
extension AccountsVC {
    
    func updateStatus(_ userID: String) {
        print(switchfounded.isOn)
        self.startAnimating()
        let db = Firestore.firestore()
        db.collection("Users").document(userID).updateData([
            "isFoundedVisible": switchfounded.isOn
        ]) { err in
            if let err = err {
                self.stopAnimating()
                print("Error updating coverUrl: \(err)")
            } else {
                self.stopAnimating()
                print("Cover URL successfully updated in Firestore")
                self.popRoot()
            }
        }
    }
}
