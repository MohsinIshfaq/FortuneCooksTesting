//
//  CommentsTCell.swift
//  Resturants
//
//  Created by Coder Crew on 03/09/2024.
//

import UIKit

class CommentsTCell: UITableViewCell {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgFavorite: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var lblReplies: UILabel!
    @IBOutlet weak var btnReplies: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var viewForReplies: UIView!
    
    //MARK: - Variables and Properties
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(comments: CommentModel?, userProfileModel: UserProfileModel?) {
        if let comments {
            lblDetail.text = trim(comments.text)
            lblReplies.text = trim(comments.replies?.count) + " replies"
            if let repliesCount = comments.replies, repliesCount.count > 0 {
                viewForReplies.isHidden = false
            } else {
                viewForReplies.isHidden = true
            }
            if let userProfileModel, let likes = comments.likes {
                imgFavorite.image = likes.contains(trim(userProfileModel.uid)) ? UIImage(named: "imgHeartFill") : UIImage(systemName: "heart")
                lblLikeCount.text = trim(likes.count)
            }
        }
        
    }
    
}
