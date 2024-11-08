//
//  writeCommentCell.swift
//  Resturants
//
//  Created by Mohsin on 15/09/2024.
//

import UIKit

class writeCommentCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var txtComment: UITextField!
    
    
    var handler: (() -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(userProfileModel: UserProfileModel?, handler: (() -> ())? = nil) {
        self.handler = handler
        if let userProfileModel {
            DispatchQueue.main.async {
                if let profileURL = userProfileModel.profileUrl, let urlProfile1 = URL(string: profileURL) {
                    self.imgImage.sd_setImage(with: urlProfile1)
                }
            }
        }
    }
    
    @IBAction func onTypeEditingBegin(_ sender: UITextField) {
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    @IBAction func onTypeEditingEnd(_ sender: UITextField) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        let text = trim(txtComment.text)
        if !text.isEmpty {
            handler?()
        }
       return true
    }
    
}
