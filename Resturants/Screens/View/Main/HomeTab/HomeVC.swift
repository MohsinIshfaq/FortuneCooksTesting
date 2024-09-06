//
//  HomeVC.swift
//  Resturants
//
//  Created by shah on 03/02/2024.
//

import UIKit
import MobileCoreServices
import FirebaseFirestoreInternal

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
    var db = Firestore.firestore()
    
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
        fetchReels()
        fetchVideos()
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

//MARK: - GET Videos and swifts {}
extension HomeVC {
    func fetchVideos() {
    
        self.startAnimating()
        UserManager.shared.videosModel?.removeAll()
        let userToken = UserDefault.token
        let collectionPath = "Videos/\(UserDefault.token)/VideosData"
        let documentRef = db.collection(collectionPath)
        
        documentRef.getDocuments { (querySnapshot, error) in
            guard let document = querySnapshot?.documents else {
                print("no document")
                self.stopAnimating()
                return
            }
            UserManager.shared.videosModel = document.map  { (QueryDocumentSnapshot) -> ProfileVideosModel in
                
                let data         =  QueryDocumentSnapshot.data()
                
                let tagPersonsData = data["tagPersons"] as? [[String: Any]] ?? []
                let tagPersons = tagPersonsData.compactMap { dict -> UserTagModel? in
                    let uid = dict["uid"] as? String
                    let img = dict["img"] as? String
                    let channelName = dict["channelName"] as? String
                    let followers = dict["followers"] as? String
                    let accountType = dict["accountType"] as? String
                    return UserTagModel(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType)
                }
                let uid          = data["uid"] as? String ?? ""
                let id           = data["id"] as? String ?? ""
                let address      = data["address"] as? String ?? ""
                let zipcode      = data["zipcode"] as? String ?? ""
                let city         = data["city"] as? String ?? ""
                let title        = data["title"] as? String ?? ""
                let TagPersons   = tagPersons
                let description  = data["description"] as? String ?? ""
                let categories   = data["categories"] as? [String] ?? []
                let hashtages    = data["hashtages"] as? [String] ?? []
                let language     = data["language"] as? String ?? ""
                let videoUrl     = data["videoUrl"] as? String ?? ""
                let thumbnailUrl = data["thumbnailUrl"] as? String ?? ""
                let likes        = data["likes"] as? Bool ?? false
                let comments     = data["comments"] as? Bool ?? false
                let views        = data["views"] as? Bool ?? false
                let paidCollab   = data["paidCollab"] as? Bool ?? false
                let introVideos  = data["introVideos"] as? Bool ?? false
                
                return ProfileVideosModel(uid: uid, id: id, address: address, Zipcode: zipcode, city: city, Title: title, tagPersons: TagPersons, description: description, categories: categories, hashtages: hashtages, language: language, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, likes: likes, comments: comments, views: views, paidCollab: paidCollab, introVideos: introVideos)
            }
            self.stopAnimating()
        }
    }
    
    func fetchReels() {
        self.startAnimating()
        UserManager.shared.reelsModel?.removeAll()
        
        let collectionPath = "Swifts/\(UserDefault.token)/VideosData"
        
        // Reference to the collection and document for the user
        let documentRef = db.collection(collectionPath)
        
        documentRef.getDocuments { (querySnapshot, error) in
            self.stopAnimating()  // Ensure the animation stops if an error occurs
            
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No documents found.")
                return
            }
            for document in documents {
                let data = document.data()
                
                // Map the document data to ProfileVideosModel
                let tagPersonsData = data["tagPersons"] as? [[String: Any]] ?? []
                let tagPersons = tagPersonsData.compactMap { dict -> UserTagModel? in
                    let uid = dict["uid"] as? String
                    let img = dict["img"] as? String
                    let channelName = dict["channelName"] as? String
                    let followers = dict["followers"] as? String
                    let accountType = dict["accountType"] as? String
                    return UserTagModel(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType)
                }
                
                let uid          = data["uid"] as? String ?? ""
                let id           = data["id"] as? String ?? ""
                let address      = data["address"] as? String ?? ""
                let zipcode      = data["zipcode"] as? String ?? ""
                let city         = data["city"] as? String ?? ""
                let title        = data["title"] as? String ?? ""
                let TagPersons   = tagPersons
                let description  = data["description"] as? String ?? ""
                let categories   = data["categories"] as? [String] ?? []
                let hashtages    = data["hashtages"] as? [String] ?? []
                let language     = data["language"] as? String ?? ""
                let videoUrl     = data["videoUrl"] as? String ?? ""
                let thumbnailUrl = data["thumbnailUrl"] as? String ?? ""
                let likes        = data["likes"] as? Bool ?? false
                let comments     = data["comments"] as? Bool ?? false
                let views        = data["views"] as? Bool ?? false
                let paidCollab   = data["paidCollab"] as? Bool ?? false
                let introVideos  = data["introVideos"] as? Bool ?? false
                
                // Create a new ProfileVideosModel and add it to reelsModel
                let profileVideo = ProfileVideosModel(uid: uid, id: id, address: address, Zipcode: zipcode, city: city, Title: title, tagPersons: TagPersons, description: description, categories: categories, hashtages: hashtages, language: language, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, likes: likes, comments: comments, views: views, paidCollab: paidCollab, introVideos: introVideos)
                
                UserManager.shared.reelsModel?.append(profileVideo)
            }
        }
    }
}

