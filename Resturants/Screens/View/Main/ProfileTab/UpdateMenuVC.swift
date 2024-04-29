//
//  AccontVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class UpdateMenuVC: UIViewController {

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
extension UpdateMenuVC {
    
    func onload() {
        removeNavBackbuttonTitle()
        self.navigationItem.title = "Change account type"
    }
    
    func onAppear() {
    }
}
