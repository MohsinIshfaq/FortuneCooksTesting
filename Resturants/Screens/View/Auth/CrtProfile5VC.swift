//
//  CrtProfile5VC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit

class CrtProfile5VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    

    @IBAction func ontapResend(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC
        self.present(vc!, animated: true)
    }

}
