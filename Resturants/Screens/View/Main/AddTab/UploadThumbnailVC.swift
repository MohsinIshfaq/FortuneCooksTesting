//
//  UploadThumbnailVC.swift
//  Resturants
//
//  Created by Coder Crew on 27/03/2024.
//

import UIKit
import AVFoundation

class UploadThumbnailVC: UIViewController {

    @IBOutlet weak var imgPickFromVideo : UIImageView!
    @IBOutlet weak var imgPickOwn       : UIImageView!
    @IBOutlet weak var lblFromVideo     : UILabel!
    @IBOutlet weak var lblOwn           : UILabel!
    @IBOutlet weak var imgThumbnail     : UIImageView!
    
    
    private var thumImg     : UIImage?  = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func ontapSave(_ sender: UIButton){
        UserManager.shared.thumbnail  = thumImg
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        self.dismiss(animated: true)
    }

    @IBAction func ontapPickImg(_ sender: UIButton){
        
        if sender.tag == 0 {
            imgPickFromVideo.image  = UIImage(named: "selecPhoto")
            imgPickOwn.image        = UIImage(named: "unselecPhoto")
            lblFromVideo.textColor  = .ColorDarkBlue
            lblOwn.textColor        = .white
            if let url = UserManager.shared.finalURL {
                if let img = generateThumbnail(path: url) {
                    self.imgThumbnail.image  = img
                }
            }
        }
        else{
            imgPickOwn.image        = UIImage(named: "selecPhoto")
            imgPickFromVideo.image  = UIImage(named: "unselecPhoto")
            lblFromVideo.textColor  = .white
            lblOwn.textColor        = .ColorDarkBlue
        }
    }
}
extension UploadThumbnailVC {
    
}
