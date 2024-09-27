//
//  writeCommentCell.swift
//  Resturants
//
//  Created by Mohsin on 15/09/2024.
//

import UIKit

class writeCommentCell: UITableViewCell {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var txtComment: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(userProfileModel: UserProfileModel?) {
        if let userProfileModel {
            DispatchQueue.main.async {
                if let profileURL = userProfileModel.profileUrl, let urlProfile1 = URL(string: profileURL) {
                    self.imgImage.sd_setImage(with: urlProfile1)
                }
            }
        }
    }
    
}
