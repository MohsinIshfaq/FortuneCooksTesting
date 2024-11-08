//
//  CollectionsActionPopupVC.swift
//  Resturants
//
//  Created by Coder Crew on 29/08/2024.
//

import UIKit
protocol CollectionActionsDelegate {
    func collectionAction(_ type: String)
}

class CollectionsActionPopupVC: UIViewController {
    
    var delegate: CollectionActionsDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func ontapAction(_ sender: UIButton) {
        
        if sender.tag == 0 {
          
            delegate?.collectionAction("Edit")
        }
        else{
            delegate?.collectionAction("Delete")
        }
    }
}
