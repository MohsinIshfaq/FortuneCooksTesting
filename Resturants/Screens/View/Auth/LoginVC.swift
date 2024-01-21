//
//  LoginViewController.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit


class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func ontapLogin(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile1VC") as? CrtProfile1VC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func ontapCrtAccnt(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CreatAccntVC") as? CreatAccntVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
