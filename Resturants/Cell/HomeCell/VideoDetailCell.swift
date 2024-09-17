//
//  VideoDetailCell.swift
//  Resturants
//
//  Created by Mohsin on 14/09/2024.
//

import UIKit

enum VideoDetailButtonType {
    case People, ViewMore
}

class VideoDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTagPeople: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDateAndViews: UILabel!
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var lblHashTag: UILabel!
    
    var handler: ((VideoDetailButtonType) -> ())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(profileVieosModel: ProfileVideosModel?, handler: ((VideoDetailButtonType) -> ())? = nil) {
        self.handler = handler
        
        if let ProfileVideoData = profileVieosModel {
            lblLocation.text = trim(ProfileVideoData.address)
            lblTagPeople.text = "\(trim(ProfileVideoData.tagPersons?.count)) people"
            lblTitle.text = trim(ProfileVideoData.Title)
            
            if let hashtages = ProfileVideoData.hashtages {
                let strHashtags = hashtages.map { "#\($0)" }.joined(separator: " ")
                lblHashTag.text = strHashtags
            }
        }
    }
    
    @IBAction func ontapTagPeople(_ sender: UIButton) {
        handler?(.People)
        
    }
    
    
    @IBAction func ontapViewMore(_ sender: UIButton) {
        handler?(.People)
        
    }
    
}
