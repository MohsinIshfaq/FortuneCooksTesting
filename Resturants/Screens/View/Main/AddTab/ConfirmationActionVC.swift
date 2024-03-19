//
//  ConfirmationActionVC.swift
//  Resturants
//
//  Created by Coder Crew on 18/03/2024.
//

import UIKit
protocol ConfirmationAutionsDelegate {
    func willDelete(_ condition: Bool)
}
class ConfirmationActionVC: UIViewController {

    //MARK: - IBOUtlets
    
    //MARK: - variables and Properties
    var delegate: ConfirmationAutionsDelegate?  = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ontapAction(_ sender: UIButton){
        if sender.tag == 0 {
            delegate?.willDelete(false)
        }
        else{
            delegate?.willDelete(true)
        }
    }
}
