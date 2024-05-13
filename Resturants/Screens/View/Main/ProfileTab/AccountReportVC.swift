//
//  AccountReportVC.swift
//  Resturants
//
//  Created by Coder Crew on 13/05/2024.
//

import UIKit

class AccountReportVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
}

//MARK: - setup Profile {}
extension AccountReportVC {
    
    func onLoad() {
        
    }
    
    func onAppear() {
       
        removeNavBackbuttonTitle()
    }
}
