//
//  MenuDishTCell.swift
//  Resturants
//
//  Created by Coder Crew on 10/08/2024.
//

import UIKit

class MenuDishTCell: UITableViewCell {

    @IBOutlet weak var lblName      : UILabel!
    @IBOutlet weak var lblDescrip   : UILabel!
    @IBOutlet weak var lblSek       : UILabel!
    @IBOutlet weak var lblMostLiked : UILabel!
    @IBOutlet weak var imgDish      : UIImageView!
    @IBOutlet weak var btnEdit      : UIButton!
    
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
