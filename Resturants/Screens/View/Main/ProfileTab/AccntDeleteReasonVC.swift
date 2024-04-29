//
//  AccntDeleteReasonVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class AccntDeleteReasonVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
}

//MARK: - Setup Profile {}
extension AccntDeleteReasonVC {
   
    func onload() {
        removeNavBackbuttonTitle()
    }
    
    func onAppear() {
        self.navigationItem.title = "Delete my account"
    }
}
