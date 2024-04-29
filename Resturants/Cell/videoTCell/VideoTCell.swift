//
//  VideoTCell.swift
//  Resturants
//
//  Created by Coder Crew on 23/04/2024.
//

import UIKit

class VideoTCell: UITableViewCell {

    //MARK: - IBOUtlets
    @IBOutlet weak var imgVideo     : UIImageView!
    @IBOutlet weak var lblDEscrip   : UILabel!
    @IBOutlet weak var lblDateViews : UILabel!
    @IBOutlet weak var lblName      : UILabel!
    
    //MARK: - Variables and Properties
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
