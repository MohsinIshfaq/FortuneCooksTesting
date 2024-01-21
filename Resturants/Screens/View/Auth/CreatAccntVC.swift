//
//  CreatAccntVC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit

class CreatAccntVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ontapNextStep(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile2VC") as? CrtProfile2VC
        self.navigationController?.pushViewController(vc!, animated: true)
    }


}
