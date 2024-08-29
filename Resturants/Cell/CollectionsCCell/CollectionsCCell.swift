//
//  CollectionsCCell.swift
//  Resturants
//
//  Created by Coder Crew on 29/08/2024.
//

import UIKit

class CollectionsCCell: UICollectionViewCell {

    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    //MARK: - IBOutlets
    @IBOutlet weak var imgCollection: UIImageView!
    @IBOutlet weak var lblTitle     : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
