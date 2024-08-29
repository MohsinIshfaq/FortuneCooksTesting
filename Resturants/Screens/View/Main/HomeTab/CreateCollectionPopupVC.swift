//
//  CreateCollectionPopupVC.swift
//  Resturants
//
//  Created by Coder Crew on 29/08/2024.
//

import UIKit

class CreateCollectionPopupVC: UIViewController {

    
    @IBOutlet weak var vwAll              : UIView!
    @IBOutlet weak var vwMyFollowers      : UIView!
    @IBOutlet weak var vwOnlyMe           : UIView!
           
    @IBOutlet weak var lblAll             : UILabel!
    @IBOutlet weak var lblMyFollowers     : UILabel!
    @IBOutlet weak var lblOnlyMe          : UILabel!
    
    @IBOutlet weak var txtTitle           : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapDismiss(_ : UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func ontapTypeCollection(_ sender: UIButton) {
      
        if sender.tag == 0 {
            vwAll.backgroundColor         = .white
            vwMyFollowers.backgroundColor = .black
            vwOnlyMe.backgroundColor      = .black
            
            lblAll.textColor              = .black
            lblMyFollowers.textColor      = .white
            lblOnlyMe.textColor           = .white
        }
        else if sender.tag == 1 {
            vwAll.backgroundColor         = .black
            vwMyFollowers.backgroundColor = .white
            vwOnlyMe.backgroundColor      = .black
            
            lblAll.textColor              = .white
            lblMyFollowers.textColor      = .black
            lblOnlyMe.textColor           = .white
        }
        else{
            vwAll.backgroundColor         = .black
            vwMyFollowers.backgroundColor = .black
            vwOnlyMe.backgroundColor      = .white
                        
            lblAll.textColor              = .white
            lblMyFollowers.textColor      = .white
            lblOnlyMe.textColor           = .black
        }
    }

}

//MARK: - Setup Profile {}
extension CreateCollectionPopupVC {
    
    func onLoad() {
        
    }
    
    func onAppear() {
        vwAll.backgroundColor         = .white
        vwMyFollowers.backgroundColor = .black
        vwOnlyMe.backgroundColor      = .black
        
        lblAll.textColor              = .black
        lblMyFollowers.textColor      = .white
        lblOnlyMe.textColor           = .white
    }
}
