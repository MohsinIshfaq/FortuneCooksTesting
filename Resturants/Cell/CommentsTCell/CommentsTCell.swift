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
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnReply: UIButton!
    
    //MARK: - Variables and Properties
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(comments: CommentModel?) {
        if let comments {
            lblTitle.text = trim(comments.text)
            lblCount.text = trim(comments.likes?.count)
        }
        
    }
    
}
