//
//  AccountsVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class AccountsVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
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
}

//MARK: - Setup Profile {}
extension AccountsVC {
    
    func onload() {
        
        removeNavBackbuttonTitle()
        setupProfileData()
    }
    
    func onAppear() {
        self.navigationItem.title = "Accounts"
    }
    
    func setupProfileData() {
        
        self.txtEmail.text = profileModel?.email ?? ""
        self.txtPhone.text = profileModel?.phoneNumber ?? ""
    }
}
