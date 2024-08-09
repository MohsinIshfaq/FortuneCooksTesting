//
//  MenuCCell.swift
//  Resturants
//
//  Created by Coder Crew on 08/08/2024.
//

import UIKit

class MenuCCell: UICollectionViewCell {

    @IBOutlet weak var lbl    : UILabel!
    @IBOutlet weak var vwBack : UIView!
    
    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
