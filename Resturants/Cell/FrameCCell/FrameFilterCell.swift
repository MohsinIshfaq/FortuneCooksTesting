//
//  FrameFilterCell.swift
//  Resturants
//
//  Created by Coder Crew on 06/03/2024.
//

import UIKit

class FrameFilterCell: UICollectionViewCell {

    //MARK: - IBOUtlets
    @IBOutlet weak var lblFilter : UILabel!
    @IBOutlet weak var btn       : UIButton!
    
    //MARK: - Identifier
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
