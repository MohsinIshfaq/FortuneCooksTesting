//
//  CommentsTCell.swift
//  Resturants
//
//  Created by Coder Crew on 03/09/2024.
//

import UIKit

class CommentRepliesCell: UITableViewCell {

    //MARK: - @IBOutlet -
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var btnHideReplies: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet var constrainForHideHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(replies: ReplyModel?, userProfileModel: UserProfileModel?, isLast: Bool) {
        if let replies {
            lblDetail.text = trim(replies.text)
            lblCount.text = trim(replies.likes?.count)
            constrainForHideHeight.isActive = !isLast
            
            if let userProfileModel, let likes = replies.likes {
                imgFavorite.image = likes.contains(trim(userProfileModel.uid)) ? UIImage(named: "imgHeartFill") : UIImage(systemName: "heart")?.withTintColor(UIColor.white, renderingMode: .alwaysTemplate)
            }
        }
        
    }
    
}
