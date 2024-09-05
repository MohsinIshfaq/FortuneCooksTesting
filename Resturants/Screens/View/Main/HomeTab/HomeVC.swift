//
//  HomeVC.swift
//  Resturants
//
//  Created by shah on 03/02/2024.
//

import UIKit
import MobileCoreServices

class HomeVC: UIViewController , MenuVCDelegate {
    func crtAccnt(pressed: String) {
        
        if pressed == "CrtAccnt" {
            if let loginVC = Constants.authStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                let navController = UINavigationController(rootViewController: loginVC)
                navController.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(navController, animated: true) {
                    if let createAccountVC = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CreatAccntVC") as? CreatAccntVC {
                        navController.pushViewController(createAccountVC, animated: true)
                    }
                }
            }
        }
        
        else if pressed == "Login" {
            let vc  = Constants.authStoryBoard.instantiateViewController(withIdentifier: "LoginNC") as? LoginNC
            vc?.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc!, animated: true)
        }
        else if pressed == "VideoRecording" {
            pickVideo()
        }
        else if pressed == "MyCollection"{
            let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "MyCollectionVC") as? MyCollectionVC
            vc?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    //MARK: - @IBOutlets
    
    //MARK: - variables and Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onlaod()
    }
    
    @objc func ontapNavRight() {
        
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.delegate = self
        self.present(vc, animated: true)
    }
    @objc func ontapNavLFT() {}
    
    @IBAction func ontapComments(_ sender: UIButton){
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        self.present(vc, animated: true)
    }

}

//MARK: - Custom Implementation {}
extension HomeVC {
    
    func onlaod(){
        
        setupViews()
    }
    func onAppear(){
        
        
    }
    func setupViews() {
        
        NavigationRightBtn()
        NavigationLeftBtn()
    }
    func NavigationRightBtn() {
        
        let myimage = UIImage(systemName: "line.3.horizontal")?.withRenderingMode(.automatic)
        var first = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(ontapNavRight))
        navigationItem.rightBarButtonItem = first
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    func NavigationLeftBtn() {
        let title = "FortuneCooks"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(ontapNavLFT))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
}

extension HomeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickVideo() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String] // This ensures only videos are shown
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let videoURL = info[.mediaURL] as? URL else {
            print("Error getting video URL")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UserManager.shared.finalURL  = videoURL
            let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "UplaodSwiftVC") as? UplaodSwiftVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

