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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    

    @IBAction func ontapResend(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC
        self.present(vc!, animated: true)
    }

}

//MARK: - Cutom Implementation {}
extension CrtProfile5VC {
    
    func onLoad() {
        
      //  setupView()
    }
    
    func onAppear() {
        removeNavBackbuttonTitle()
        self.navigationItem.title  = "Verificationx"
    }
}
