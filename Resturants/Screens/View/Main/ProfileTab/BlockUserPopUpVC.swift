//
//  BlockUserPopUpVC.swift
//  Resturants
//
//  Created by Coder Crew on 13/05/2024.
//

import UIKit

class BlockUserPopUpVC: UIViewController {

    var nonProfileModel : TagUsers?         = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ontapCancel(_ snder: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapOK(_ sender: UIButton) {
        
    }

}
