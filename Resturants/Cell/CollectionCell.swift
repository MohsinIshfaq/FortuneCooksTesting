//
//  CollectionCell.swift
//  Resturants
//
//  Created by shah on 30/01/2024.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    //MARK: - IBOUTLETS
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}
