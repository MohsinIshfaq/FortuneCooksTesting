//
//  VideoCommentHeaderCell.swift
//  Resturants
//
//  Created by Mohsin on 15/09/2024.
//

import UIKit

class VideoCommentHeaderCell: UITableViewCell {

    
    @IBOutlet weak var lblComments: UILabel!
    
    var handler: (() -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(profileVideoModel: ProfileVideosModel?, handler: (() -> ())? = nil) {
        self.handler = handler
        let commentCount = profileVideoModel?.comments?.count ?? 0
        let totalRepliesCount = profileVideoModel?.comments?.reduce(0) { $0 + ($1.replies?.count ?? 0) }  ?? 0
        let totalComment = commentCount + totalRepliesCount
        lblComments.text = "\(totalComment) Comments"
    }
    
    @IBAction func ontapComments(_ sender: UIButton){
        handler?()
    }
    
}
