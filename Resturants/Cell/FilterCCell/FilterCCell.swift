//
//  FilterCCell.swift
//  Resturants
//
//  Created by Coder Crew on 02/03/2024.
//

import UIKit

class FilterCCell: UICollectionViewCell {

    //MARK: - IBOUtlets
    @IBOutlet weak var effect_Imgvw   : UIImageView!
    @IBOutlet weak var lbl_effectName : UILabel!
    
    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
