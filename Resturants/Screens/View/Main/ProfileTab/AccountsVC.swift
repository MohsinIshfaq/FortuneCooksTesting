//
//  AccountsVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class AccountsVC: UIViewController {

    
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapDeleteAccnt(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "DeleteAccntVC") as! DeleteAccntVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Setup Profile {}
extension AccountsVC {
   
    func onload() {
      
        removeNavBackbuttonTitle()
    }
    
    func onAppear() {
        self.navigationItem.title = "Accounts"
    }
}
