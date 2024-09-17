//
//  UserViewerCell.swift
//  Resturants
//
//  Created by Mohsin on 15/09/2024.
//

import UIKit

class UserViewerCell: UITableViewCell {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(userProfileModel: UserProfileModel?) {
        if let userProfileModel {
            DispatchQueue.main.async {
                if let profileURL = userProfileModel.profileUrl, let urlProfile1 = URL(string: profileURL) {
                    self.imgImage.sd_setImage(with: urlProfile1)
                }
            }
            let userName = trim(userProfileModel.channelName)
            let followers = trim(userProfileModel.followers?.count)
            let accountType = trim(userProfileModel.accountType)
            let attribTitle = NSMutableAttributedString(string: "\(userName)\n\(followers) Followers ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.Roboto.Regular(of: 14)])
            attribTitle.append(NSAttributedString(string: "( \(accountType) )", attributes: [.foregroundColor: UIColor.ColorBlue, .font: UIFont.Roboto.Regular(of: 14)]))
            lblTitle.attributedText = attribTitle
        }
        
    }
    
}
