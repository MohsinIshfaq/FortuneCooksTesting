//
//  ProfileVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK: - IBOUtlet
    @IBOutlet weak var vwVideo         : UIView!
    @IBOutlet weak var vwSwift         : UIView!
    @IBOutlet weak var vwCollection    : UIView!
    @IBOutlet weak var vwVideoContnr   : UIView!
    @IBOutlet weak var vwSwiftContnr   : UIView!
    @IBOutlet weak var vwCollectContnr : UIView!
    
    //MARK: - Variables and Properties
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapSetting(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ontapTabPressed(_ sender: UIButton){
        if sender.tag      == 0 {
            vwVideo.isHidden       = false
            vwSwift.isHidden       = true
            vwCollection.isHidden  = true
            vwVideoContnr.isHidden = false
            vwSwiftContnr.isHidden = true
        }
        else if sender.tag == 1 {
            vwVideo.isHidden       = true
            vwSwift.isHidden       = false
            vwCollection.isHidden  = true
            vwVideoContnr.isHidden = true
            vwSwiftContnr.isHidden = false
        }
        else{
            vwVideo.isHidden       = true
            vwSwift.isHidden       = true
            vwCollection.isHidden  = false
            vwVideoContnr.isHidden = false
            vwSwiftContnr.isHidden = false
        }
    }
}

//MARK: - Setup Profile {}
extension ProfileVC {
   
    func onload() {
       // self.navigationController?.removeBackground()
    }
    
    func onAppear() {
        
        vwVideo.isHidden         = false
        vwSwift.isHidden         = true
        vwCollection.isHidden    = true
        vwSwiftContnr.isHidden   = true
        vwCollectContnr.isHidden = true
        vwVideoContnr.isHidden   = false
    }
}

