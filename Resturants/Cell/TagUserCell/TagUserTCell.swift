//
//  TagUserTCell.swift
//  Resturants
//
//  Created by Coder Crew on 05/04/2024.
//

import UIKit

class TagUserTCell: UITableViewCell {

    //MARK: - IBOUtlets
    @IBOutlet weak var lblName      : UILabel!
    @IBOutlet weak var img          : UIImageView!
    @IBOutlet weak var lblFollowers : UILabel!
    @IBOutlet weak var lblType      : UILabel!
    @IBOutlet weak var imgSelected  : UIImageView!
    
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
