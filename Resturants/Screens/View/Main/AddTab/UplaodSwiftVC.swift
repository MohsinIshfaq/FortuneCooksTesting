//
//  UplaodSwiftVC.swift
//  Resturants
//
//  Created by Coder Crew on 27/03/2024.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit
protocol ReloadDelegate {
    func reload(img : UIImage?)
}

class UplaodSwiftVC: UIViewController , ReloadDelegate {
    
    func reload(img: UIImage?) {
        imgThumbnail.image = img
       // if let img = img {
       // }
    }
    //MARK: - IBOUtlets
    @IBOutlet weak var txtAddress : UITextField!
    @IBOutlet weak var txtZipCode : UITextField!
    @IBOutlet weak var txtCity    : UITextField!
    @IBOutlet weak var txtTagPeople : UITextField!
    @IBOutlet weak var txtTitle   : UITextField!
    @IBOutlet weak var txtHastag  : UITextField!
    @IBOutlet weak var txtLang    : UITextField!
    
    @IBOutlet weak var btnThumbnail  : UIButton!
    @IBOutlet weak var imgThumbnail  : UIImageView!
    @IBOutlet weak var imgVideoThumb : UIImageView!
    
    //MARK: - Variables and Properties
    private var outputURL: URL?            = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapPickVideo(_ sender: UIButton){
        DispatchQueue.main.async {
            if let url = UserManager.shared.finalURL {
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.present(playerViewController, animated: true) {
                    player.play()
                }
            }
        }
    }
    
    @IBAction func ontapThumbnail(_ sender: UIButton){
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "UploadThumbnailVC") as? UploadThumbnailVC
        vc?.delegate  = self
        self.present(vc!, animated: true)
    }
}

//MARK: - Extension of setup Data{}
extension UplaodSwiftVC {
    func onLoad() {
        removeNavBackbuttonTitle()
        if let url = UserManager.shared.finalURL {
            if let img = generateThumbnail(path: url) {
                self.imgVideoThumb.image  = img
            }
        }
    }
    
    func onAppear() {
        self.showNavBar()
    }
}

extension UplaodSwiftVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
