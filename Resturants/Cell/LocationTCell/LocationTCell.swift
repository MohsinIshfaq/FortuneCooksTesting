//
//  LocationTCell.swift
//  Resturants
//
//  Created by Coder Crew on 10/05/2024.
//

import UIKit

class LocationTCell: UITableViewCell {
    
    //MARK: - IBOUtlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLoc: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSchedule: UILabel!
    @IBOutlet weak var stackBtns: UIStackView!
    @IBOutlet weak var btnManangeInfo: UIButton!
    
    
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
