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
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnReply: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
