//
//  SettingsVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit
protocol UpdateUserProfileFrmSettingDelegate {
    func callAPI()
}

class SettingsVC: UIViewController {

    var profileModel                       : UserProfileModel? = nil
    var delegate                           : UpdateUserProfileFrmSettingDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapProfile(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "UpdateProfileVC") as! UpdateProfileVC
        vc.hidesBottomBarWhenPushed = true
        vc.profileModel = self.profileModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapFeed(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "FeedVC") as! FeedVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapNotifications(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapAccont(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AccountsVC") as! AccountsVC
        vc.hidesBottomBarWhenPushed = true
        vc.profileModel = self.profileModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapMenu(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ManageMenuVC") as! ManageMenuVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapBlockUsers(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "BlockedAccntVC") as! BlockedAccntVC
        vc.profileModel = self.profileModel
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapFeedBack(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "FeedBackVC") as! FeedBackVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func customButtonTapped() {
        // Handle button tap
        print("Custom button tapped!")
        delegate?.callAPI()
    }
}

//MARK: - Setup Profile {}
extension SettingsVC {
   
    func onload() {
      
        self.navigationItem.title = "Setting"
    }
    
    func onAppear() {
        hidesBottomBarWhenPushed = false
        hideNavBackButton()
        NavBackButton()
    }
    
    func NavBackButton() {
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        customButton.addTarget(self, action: #selector(customButtonTapped), for: .touchUpInside)
        customButton.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        let customBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customBarButtonItem
    }
}


