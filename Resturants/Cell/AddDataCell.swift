//
//  AddDataCell.swift
//  Resturants
//
//  Created by shah on 30/01/2024.
//

import UIKit

class AddDataCell: UICollectionViewCell {

    //MARK: - IBOUTLETS
    @IBOutlet weak var lbl: UILabel!
    
    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
