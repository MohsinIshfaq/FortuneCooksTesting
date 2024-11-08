//
//  TagPeopleCCell.swift
//  Resturants
//
//  Created by Coder Crew on 06/04/2024.
//

import UIKit

class TagPeopleCCell: UICollectionViewCell {

    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var btnDismiss: UIButton!
    
    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
