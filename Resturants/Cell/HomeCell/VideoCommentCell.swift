//
//  VideoCommentCell.swift
//  Resturants
//
//  Created by Mohsin on 15/09/2024.
//

import UIKit

class VideoCommentCell: UITableViewCell {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnReply: UIButton!
    
    @IBOutlet weak var imgLikeOrDislike: UIImageView!
    var handler: (() -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(profileVideoModel: ProfileVideosModel?, arrayAllUsers: [UserModel], handler: (() -> ())? = nil) {
        self.handler = handler
        if let profileVideoModel = profileVideoModel {
            
            guard let comment = profileVideoModel.comments?.first else { return }
            
            let timestamp = comment.timestamp ?? 0
            lblComment.text = trim(comment.text)
            lblCommentCount.text = "\(comment.likes?.count ?? 0)"
            btnFavorite.isSelected = false
            if let user = arrayAllUsers.first(where: { $0.uid == comment.uid }) {
                lblName.text = "\(user.channelName) · \(getTimeStapToDate(timestamp))"
                let fadsf = comment.likes?.contains(trim(user.uid)) ?? false
                print("** commentLike: \(comment.likes)\t*\t\(user.uid) ==\(comment.likes?.contains(trim(user.uid)))\t\(btnFavorite.isSelected)")
                btnFavorite.isSelected = comment.likes?.contains(trim(user.uid)) ?? false
                print("** commentLike: \(comment.likes)\t*\t\(user.uid) ==\(comment.likes?.contains(trim(user.uid)))\t\(btnFavorite.isSelected)")
                DispatchQueue.main.async {
                    if let urlProfile1 = URL(string: user.profileUrl) {
                        self.imgImage.sd_setImage(with: urlProfile1)
                    }
                }
            }
            imgLikeOrDislike.image = UIImage(named: btnFavorite.isSelected ?  "imgHeartFill" : "imgHeartOutline")
        }
    }
    
    @IBAction func onClickLike(_ sender: UIButton) {
        imgLikeOrDislike.image = UIImage(named: btnFavorite.isSelected ?  "imgHeartOutline" : "imgHeartFill")
        handler?()
    }
}
