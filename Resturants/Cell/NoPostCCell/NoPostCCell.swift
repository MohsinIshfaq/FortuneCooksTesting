//
//  NoPostCCell.swift
//  Resturants
//
//  Created by Coder Crew on 29/04/2024.
//

import UIKit

class NoPostCCell: UICollectionViewCell {

    @IBOutlet weak var btnPost: UIButton!
    
    //MARK: - Variables and Properties
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
