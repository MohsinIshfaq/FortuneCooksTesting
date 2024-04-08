//
//  UploadSwift2VC.swift
//  Resturants
//
//  Created by Coder Crew on 06/04/2024.
//

import UIKit
import FirebaseStorage

class UploadSwift2VC: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var lblProgress   : UILabel!
    @IBOutlet weak var switchLike    : UISwitch!
    @IBOutlet weak var switchComment : UISwitch!
    @IBOutlet weak var switchViews   : UISwitch!
    @IBOutlet weak var switchPaid    : UISwitch!
    @IBOutlet weak var switchIntro   : UISwitch!
    @IBOutlet weak var vwPublic      : UIView!
    @IBOutlet weak var lblPublic     : UILabel!
    @IBOutlet weak var vwFollowers   : UIView!
    @IBOutlet weak var lblFollowers  : UILabel!
    @IBOutlet weak var vwOnlyMe      : UIView!
    @IBOutlet weak var lblOnlyMe     : UILabel!

    @IBOutlet weak var imgFavourites : UIImageView!
    @IBOutlet weak var imgPasta      : UIImageView!
    @IBOutlet weak var imgChicken    : UIImageView!
    
    //MARK: - Variables and Properties
    var uploadTask: StorageUploadTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func ontapVideoType(_ sender: UIButton){
        if sender.tag == 0{
            vwPublic.backgroundColor    = .white
            lblPublic.textColor         = .black
            vwFollowers.backgroundColor = .clear
            lblFollowers.textColor      = .white
            vwOnlyMe.backgroundColor    = .clear
            lblOnlyMe.textColor         = .white
        }
        else if sender.tag == 1{
            vwPublic.backgroundColor    = .clear
            lblPublic.textColor         = .white
            vwFollowers.backgroundColor = .white
            lblFollowers.textColor      = .black
            vwOnlyMe.backgroundColor    = .clear
            lblOnlyMe.textColor         = .white
        }
        else{
            vwPublic.backgroundColor    = .clear
            lblPublic.textColor         = .white
            vwFollowers.backgroundColor = .clear
            lblFollowers.textColor      = .white
            vwOnlyMe.backgroundColor    = .white
            lblOnlyMe.textColor         = .black
        }
    }
    
    @IBAction func ontapCollections(_ sender: UIButton){
        if sender.tag == 0{
            imgFavourites.image = UIImage(systemName: "bookmark.fill")
            imgPasta.image      = UIImage(systemName: "bookmark")
            imgChicken.image    = UIImage(systemName: "bookmark")
        }
        else if sender.tag == 1{
            imgFavourites.image = UIImage(systemName: "bookmark")
            imgPasta.image      = UIImage(systemName: "bookmark.fill")
            imgChicken.image    = UIImage(systemName: "bookmark")
        }
        else{
            imgFavourites.image = UIImage(systemName: "bookmark")
            imgPasta.image      = UIImage(systemName: "bookmark")
            imgChicken.image    = UIImage(systemName: "bookmark.fill")
            
        }
    }
    
    @IBAction func ontapPublishVideo(_ sender: UIButton){
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "UploadingVC") as! UploadingVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
