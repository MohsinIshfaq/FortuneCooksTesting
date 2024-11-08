//
//  ColorCCell.swift
//  Resturants
//
//  Created by Coder Crew on 24/03/2024.
//

import UIKit

class ColorCCell: UICollectionViewCell {

    //MARK: - IBOUtlets
    @IBOutlet weak var vwColor : UIView!
    
    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
