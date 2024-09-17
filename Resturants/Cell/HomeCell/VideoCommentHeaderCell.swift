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
    
    func config(handler: (() -> ())? = nil) {
        self.handler = handler
    }
    
    @IBAction func ontapComments(_ sender: UIButton){
        handler?()
    }
    
}
