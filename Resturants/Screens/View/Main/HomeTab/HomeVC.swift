//
//  HomeVC.swift
//  Resturants
//
//  Created by shah on 03/02/2024.
//

import UIKit
import MobileCoreServices
import FirebaseFirestoreInternal
import AVKit
import AVFoundation

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
    
    @IBOutlet weak var customTable: UITableView!
    @IBOutlet weak var imgImage: UIImageView!
    
    //MARK: - variables and Properties
    var db = Firestore.firestore()
    var profileVideoModel: ProfileVideosModel? = nil
    var profileModel: UserProfileModel?   = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !UserDefault.token.isEmpty {
            onlaod()
        }
    }
    
    @objc func ontapNavRight() {
        
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.delegate = self
        self.present(vc, animated: true)
    }
    @objc func ontapNavLFT() {}
    
    @IBAction func ontapVideo(_ sender: UIButton) {
        let url = trim(profileVideoModel?.videoUrl)
        let videoURL = URL(string: url)
        playVideo(url: videoURL!)
        
    }
    
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
        fetchUserData(userID: UserDefault.token) { user in
            self.stopAnimating()
            if let user = user {
                self.profileModel = user
                print("User data: \(user)")
                self.customTable.reloadData()
            } else {
                print("Failed to fetch user data.")
            }
        }
    }
    func onAppear(){
        
        
    }
    func configData() {
        self.profileVideoModel = UserManager.shared.reelsModel?.first
        DispatchQueue.main.async {
            let thumbnailUrl = trim(self.profileVideoModel?.thumbnailUrl)
            if let urlProfile1 = URL(string: thumbnailUrl) {
                self.imgImage.sd_setImage(with: urlProfile1, placeholderImage: UIImage(named: "Video 1"))
            }
        }
        self.customTable.reloadData()
    }
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        present(playerViewController, animated: true) {
            player.play()
        }
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
            if let error = error {
                print("\(#function)\t Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let document = querySnapshot?.documents else {
                print("\(#function)\t no document")
                self.stopAnimating()
                return
            }
            
            UserManager.shared.videosModel = document.map  { (QueryDocumentSnapshot) -> ProfileVideosModel in
                
                let data         =  QueryDocumentSnapshot.data()
                print("** data: \(data)")
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
                let commentsData = data["comments"] as? [[String: Any]] ?? []
                let comments = commentsData.map { parseCommentData(data: $0) }
                let views        = data["views"] as? Bool ?? false
                let paidCollab   = data["paidCollab"] as? Bool ?? false
                let introVideos  = data["introVideos"] as? Bool ?? false
                
                return ProfileVideosModel(uid: uid, id: id, address: address, Zipcode: zipcode, city: city, Title: title, tagPersons: TagPersons, description: description, categories: categories, hashtages: hashtages, language: language, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, likes: likes, comments: comments, views: views, paidCollab: paidCollab, introVideos: introVideos)
            }
            print("** MI videosModel: \(UserManager.shared.videosModel)")
            self.configData()
            
            self.stopAnimating()
        }
    }
    
    func fetchReels() {
        self.startAnimating()
        UserManager.shared.reelsModel?.removeAll()
        
        let collectionPath = "Swifts/\(UserDefault.token)/VideosData"
        
        // Reference to the collection and document for the user
        let documentRef = db.collection(collectionPath)
        
        documentRef.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            self.stopAnimating()  // Ensure the animation stops if an error occurs
            
            if let error = error {
                print("\(#function)\t Error getting documents: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("\(#function)\t No documents found.")
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
                let commentsData = data["comments"] as? [[String: Any]] ?? []
                let comments = commentsData.map { parseCommentData(data: $0) }
                let views        = data["views"] as? Bool ?? false
                let paidCollab   = data["paidCollab"] as? Bool ?? false
                let introVideos  = data["introVideos"] as? Bool ?? false
                
                // Create a new ProfileVideosModel and add it to reelsModel
                let profileVideo = ProfileVideosModel(uid: uid, id: id, address: address, Zipcode: zipcode, city: city, Title: title, tagPersons: TagPersons, description: description, categories: categories, hashtages: hashtages, language: language, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, likes: likes, comments: comments, views: views, paidCollab: paidCollab, introVideos: introVideos)
                
                UserManager.shared.reelsModel?.append(profileVideo)
                
            }
            print("** UserManager.shared.reelsModel: \(UserManager.shared.reelsModel)")
            self.configData()
        }
    }
    
    func fetchUserData(userID: String, completion: @escaping (UserProfileModel?) -> Void) {
        self.startAnimating()
        let db = Firestore.firestore()
        db.collection("Users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let tagPersonsData = data?["tagPersons"] as? [[String: Any]] ?? []
                            let tagPersons = tagPersonsData.compactMap { dict -> TagUsers? in
                                let uid = dict["uid"] as? String
                                let img = dict["img"] as? String
                                let channelName = dict["channelName"] as? String
                                let followers = dict["followers"] as? String
                                let accountType = dict["accountType"] as? String
                                return TagUsers(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType)
                            }
                let followersData = data?["followers"] as? [[String: Any]] ?? []
                            let followersdata = followersData.compactMap { dict -> TagUsers? in
                                let uid = dict["uid"] as? String
                                let img = dict["img"] as? String
                                let channelName = dict["channelName"] as? String
                                let followers = dict["followers"] as? String
                                let accountType = dict["accountType"] as? String
                                return TagUsers(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType)
                            }
                let followingData = data?["followings"] as? [[String: Any]] ?? []
                            let followingdata = followingData.compactMap { dict -> TagUsers? in
                                let uid = dict["uid"] as? String
                                let img = dict["img"] as? String
                                let channelName = dict["channelName"] as? String
                                let followers = dict["followers"] as? String
                                let accountType = dict["accountType"] as? String
                                return TagUsers(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType)
                            }
                let blockUsers = data?["blockUsers"] as? [[String: Any]] ?? []
                            let blocked = blockUsers.compactMap { dict -> TagUsers? in
                                let uid = dict["uid"] as? String
                                let img = dict["img"] as? String
                                let channelName = dict["channelName"] as? String
                                let followers = dict["followers"] as? String
                                let accountType = dict["accountType"] as? String
                                return TagUsers(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType)
                            }
                
                
                
                // Access each field using its key and map to the model
                let user = UserProfileModel(selectedCuisine: data?["selectedCuisine"] as? [String] ?? [],
                                            selectedEnvironment: data?["selectedEnvironment"] as? [String] ?? [],
                                            selectedFeatures: data?["selectedFeatures"] as? [String] ?? [],
                                            accountType: data?["accountType"] as? String ?? "",
                                            address: data?["address"] as? String ?? "",
                                            bio: data?["bio"] as? String ?? "",
                                            city: data?["city"] as? String ?? "",
                                            uid: data?["uid"] as? String ?? "",
                                            website: data?["website"] as? String ?? "",
                                            zipcode: data?["zipcode"] as? String ?? "",
                                            coverUrl: data?["coverUrl"] as? String ?? "",
                                            profileUrl: data?["profileUrl"] as? String ?? "",
                                            followers: followersdata,
                                            //isFoundedVisible: data?["isFoundedVisible"] as? Bool ?? false,
                                            followings: followingdata,
                                            timings: data?["timings"] as? [String] ?? [],
                                            tagPersons: tagPersons,
                                            blockUsers: blocked,
                                            selectedTypeOfRegion: data?["selectedTypeOfRegion"] as? [String] ?? [],
                                            selectedMeals: data?["selectedMeals"] as? [String] ?? [],
                                            selectedSpecialize: data?["selectedSpecialize"] as? [String] ?? [],
                                            channelName: data?["channelName"] as? String ?? "",
                                            dateOfBirth: data?["dateOfBirth"] as? String ?? "",
                                            email: data?["email"] as? String ?? "",
                                            phoneNumber: data?["phoneNumber"] as? String ?? "" ,
                                            businessEmail: data?["businessEmail"] as? String ?? "",
                                            businessphoneNumber: data?["businessNumber"] as? String ?? "",
                                            isFoundedVisible: data?["isFoundedVisible"] as? Bool ?? false)
                self.stopAnimating()
                completion(user)
            } else {
                self.stopAnimating()
                self.showToast(message: "Document does not exist: \(error?.localizedDescription ?? "Unknown error")", seconds: 2, clr: .red)
                print("Document does not exist: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 3
        } else if section == 3 {
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: VideoDetailCell = tableView.cell(for: indexPath)
            cell.config(profileVieosModel: profileVideoModel) { [weak self] type in
                guard let self = self else { return }
                if type == .People {
                    let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
//                    vc?.showTagUsers = true
//                    vc?.delegate     = self
//                    vc?.alreadyTagUsers = profileModel?.tagPersons ?? []
                    self.present(vc!, animated: true)
                } else if type == .ViewMore {
                    
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell: UserViewerCell = tableView.cell(for: indexPath)
            cell.config(userProfileModel: profileModel)
            return cell
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell: VideoCommentHeaderCell = tableView.cell(for: indexPath)
                cell.config { [weak self] in
                    guard let self = self else { return }
                    let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
                    vc.profileVideoModel = self.profileVideoModel
                    self.present(vc, animated: true)
                }
                return cell
            } else if indexPath.row == 1 {
                let cell: VideoCommentCell = tableView.cell(for: indexPath)
                return cell
            } else if indexPath.row == 2 {
                let cell: writeCommentCell = tableView.cell(for: indexPath)
                return cell
            }
        } else if indexPath.section == 3 {
            let cell: CategoryButtonCell = tableView.cell(for: indexPath)
            return cell
        }
        return .init(frame: .zero)
    }
}
