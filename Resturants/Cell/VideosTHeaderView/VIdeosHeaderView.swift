//
//  VIdeosHeaderView.swift
//  Resturants
//
//  Created by Coder Crew on 29/04/2024.
//

import UIKit

class VideosHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var vwVideo   : UIView!
    @IBOutlet weak var lblTitle  : UILabel!
    @IBOutlet weak var lblViews  : UILabel!
    @IBOutlet weak var btnPlay   : UIButton!
    
    //MARK: - Variables and Properties
    static var identifier: String { return String(describing: self) }
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    
}
