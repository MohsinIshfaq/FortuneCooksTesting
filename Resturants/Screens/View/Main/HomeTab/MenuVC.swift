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

    
    @IBOutlet weak var btnCreateAccnt : UIView!
    @IBOutlet weak var btnLogout      : UIView!
    @IBOutlet weak var btnUpload      : UIView!
    @IBOutlet weak var btnLogin       : UIView!
    
    var delegate: MenuVCDelegate?     = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefault.isAuthenticated {
            btnCreateAccnt.isHidden = true
            btnLogin.isHidden       = true
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
        delegate?.crtAccnt(pressed: "CrtAccnt")
        //NotificationCenter.default.post(name: NSNotification.Name("CrtAccnt"), object: nil)
    }
    
    
    @IBAction func ontapLogin(_ sender: UIButton){
        self.dismiss(animated: true)
        UserDefault.isAuthenticated = false
        delegate?.crtAccnt(pressed: "Login")
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
