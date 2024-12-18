//
//  SwiftCCell.swift
//  Resturants
//
//  Created by Coder Crew on 23/04/2024.
//

import UIKit

class SwiftCCell: UICollectionViewCell {

    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lblDescrip : UILabel!
    @IBOutlet weak var lblName    : UILabel!
    @IBOutlet weak var imgMain    : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
