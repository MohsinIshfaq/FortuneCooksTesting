//
//  NoPostTCell.swift
//  Resturants
//
//  Created by Coder Crew on 29/04/2024.
//

import UIKit

class NoPostTCell: UITableViewCell {

    @IBOutlet weak var btnPost: UIButton!
    
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
