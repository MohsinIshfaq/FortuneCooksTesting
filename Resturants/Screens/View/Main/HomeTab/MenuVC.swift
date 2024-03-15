//
//  MenuVC.swift
//  Resturants
//
//  Created by shah on 03/02/2024.
//

import UIKit
protocol MenuVCDelegate{
    func crtAccnt(pressed : String)
}

class MenuVC: UIViewController {

    var delegate: MenuVCDelegate? = nil
    @IBOutlet weak var btnCreateAccnt :UIView!
    @IBOutlet weak var btnLogout      :UIView!
    @IBOutlet weak var btnUpload      :UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefault.isAuthenticated {
            btnCreateAccnt.isHidden = true
            btnLogout.isHidden      = false
            btnUpload.isHidden      = false
        }
        else{
            btnCreateAccnt.isHidden = false
            btnLogout.isHidden      = true
            btnUpload.isHidden      = true
        }
    }
  
    @IBAction func ontapCrtAccnt(_ sender: UIButton){
        self.dismiss(animated: true)
        UserDefault.isAuthenticated = false
        delegate?.crtAccnt(pressed: "Auth")
        //NotificationCenter.default.post(name: NSNotification.Name("CrtAccnt"), object: nil)
    }
    
    @IBAction func ontapLogout(_ sender: UIButton){
        self.dismiss(animated: true)
        UserDefault.isAuthenticated = false
        delegate?.crtAccnt(pressed: "Auth")
        //NotificationCenter.default.post(name: NSNotification.Name("CrtAccnt"), object: nil)
    }
    
    @IBAction func ontapVideoRecording(_ sender: UIButton) {
        self.dismiss(animated: true)
        delegate?.crtAccnt(pressed: "VideoRecording")
    }

}
