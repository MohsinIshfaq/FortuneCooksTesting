//
//  SelectioTCell.swift
//  Resturants
//
//  Created by shah on 30/01/2024.
//

import UIKit

class SelectioTCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    
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
