//
//  MenuDetailPopupVC.swift
//  Resturants
//
//  Created by Coder Crew on 14/05/2024.
//

import UIKit

class MenuDetailPopupVC: UIViewController {

    @IBOutlet weak var imgMain    : UIImageView!
    @IBOutlet weak var lblName    : UILabel!
    @IBOutlet weak var lblPrice   : UILabel!
    @IBOutlet weak var lblDescrip : UILabel!
   
    
    var selectedItem: GroupsItemModel?      = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            if let profileURL = self.selectedItem?.img, let urlProfile1 = URL(string: profileURL) {
                self.imgMain.sd_setImage(with: urlProfile1)
            }
        }
        lblName.text = selectedItem?.title ?? ""
        lblDescrip.text = selectedItem?.descrip ?? ""
        lblPrice.text   = "\(selectedItem?.price ?? "") \(selectedItem?.currency ?? "")"
        
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        self.dismiss(animated: true)
    }


}
