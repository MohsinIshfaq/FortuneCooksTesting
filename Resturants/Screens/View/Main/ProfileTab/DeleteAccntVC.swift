//
//  DeleteAccntVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class DeleteAccntVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapNext(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AccntDeleteReasonVC") as! AccntDeleteReasonVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - Setup Profile {}
extension DeleteAccntVC {
   
    func onload() {
        removeNavBackbuttonTitle()
    }
    
    func onAppear() {
        self.navigationItem.title = "Delete my account"
    }
}
