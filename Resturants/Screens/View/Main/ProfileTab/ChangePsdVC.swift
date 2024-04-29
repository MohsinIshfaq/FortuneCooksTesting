//
//  ChangePsdVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class ChangePsdVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
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
