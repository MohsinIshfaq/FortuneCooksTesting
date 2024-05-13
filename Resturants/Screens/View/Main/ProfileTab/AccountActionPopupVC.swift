//
//  AccountActionPopupVC.swift
//  Resturants
//
//  Created by Coder Crew on 13/05/2024.
//

import UIKit
protocol AccountReportDelete{
    func action(call : String)
}

class AccountActionPopupVC: UIViewController {

    var delegate: AccountReportDelete?  = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ontapReport(_ sender: UIButton) {
        self.dismiss(animated: true)
        delegate?.action(call: "Report")
    }
    
    @IBAction func ontapBlock(_ sender: UIButton) {
        self.dismiss(animated: true)
        delegate?.action(call: "Block")
    }

}
