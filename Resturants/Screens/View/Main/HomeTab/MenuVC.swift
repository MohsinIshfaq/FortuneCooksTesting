//
//  MenuVC.swift
//  Resturants
//
//  Created by shah on 03/02/2024.
//

import UIKit
protocol MenuVCDelegate{
  func crtAccnt()
}

class MenuVC: UIViewController {

    var delegate: MenuVCDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @IBAction func ontapCrtAccnt(_ sender: UIButton){
        self.dismiss(animated: true)
        delegate?.crtAccnt()
    }

}
