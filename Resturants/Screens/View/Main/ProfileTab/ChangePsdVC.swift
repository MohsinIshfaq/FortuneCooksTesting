//
//  ChangePsdVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class ChangePsdVC: UIViewController {

    //MARK: - OUtlets
    @IBOutlet weak var txtPsd       : UITextField!
    @IBOutlet weak var btnToglePsd  : UIButton!
    
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
    
}

//MARK: - Setup Profile {}
extension ChangePsdVC {
   
    func onload() {
        removeNavBackbuttonTitle()
    }
    
    func onAppear() {
        self.navigationItem.title = "Change Password"
    }
}
