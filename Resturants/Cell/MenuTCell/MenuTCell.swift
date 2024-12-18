//
//  MenuTCell.swift
//  Resturants
//
//  Created by Coder Crew on 07/05/2024.
//

import UIKit

class MenuTCell: UITableViewCell {

    @IBOutlet weak var lblName     : UILabel!
    @IBOutlet weak var lblDescrip  : UILabel!
    @IBOutlet weak var lblPrice    : UILabel!
    @IBOutlet weak var imgMain     : UIImageView!
    
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
