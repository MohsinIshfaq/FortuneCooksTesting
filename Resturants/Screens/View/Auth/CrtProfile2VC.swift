//
//  CrtProfile2VC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit

class CrtProfile2VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    @IBAction func ontapNextStep(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile3VC") as? CrtProfile3VC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
