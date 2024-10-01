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
    @IBOutlet weak var imgPlayAndPause: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var lblLikesCount: UILabel!
    @IBOutlet weak var lblCommentsCount: UILabel!
    @IBOutlet weak var viewForThumbnail: UIView!
    @IBOutlet weak var viewForVideo: UIView!
    
    @IBOutlet var arrayForVideoIndicator: [UIView]!
    
    //MARK: - variables and Properties
    
    var db = Firestore.firestore()
    var videoPlayerController:AVPlayerViewController? = nil
    var player:AVPlayer!/*? = nil*/
    var playerLayer: AVPlayerLayer!
    var profileVideoModel: ProfileVideosModel? = nil
    var userProfileModel: UserProfileModel?   = nil
    var showLoading: Bool = true
    var isPlaying: Bool = true
    var isShowVideoIndicator: Bool = true
    var txtComment: UITextField? = nil
    var isCommentReply: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefault.token.isEmpty {
            onlaod()
        }
    }
    
    func pushForComments() {
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.profileVideoModel = self.profileVideoModel
        vc.userProfileModel = self.userProfileModel
        vc.arrayAllUsers = arrayAllUsers
        vc.handler = { [weak self] profileVideoModel in
            guard let self = self else { return }
            self.profileVideoModel = profileVideoModel
            fetchVideos()
            customTable.reloadData()
        }
        self.present(vc, animated: true)
    }
    
    @objc func ontapNavRight() {
        
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.delegate = self
        self.present(vc, animated: true)
    }
    @objc func ontapNavLFT() {}
    
    @IBAction func ontapPlayVideo(_ sender: UIButton) {
        viewForThumbnail.isHidden = true
        timeSlider.isHidden = false
        setupVideoPlayer()
//        let url = trim(profileVideoModel?.videoUrl)
//        guard let url = URL(string: url) else {
//            print("Invalid Video URL")
//            return
//        }
//        
        
//        
//        videoPlayer = AVPlayer(url: url)
//        
//        videoPlayerController = AVPlayerViewController()
//        videoPlayerController?.player = videoPlayer
//        
//        if let videoPlayerController = videoPlayerController {
//            addChild(videoPlayerController)
//            viewForVideo.addSubview(videoPlayerController.view)
//            
//            videoPlayerController.view.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                videoPlayerController.view.leadingAnchor.constraint(equalTo: viewForVideo.leadingAnchor),
//                videoPlayerController.view.trailingAnchor.constraint(equalTo: viewForVideo.trailingAnchor),
//                videoPlayerController.view.topAnchor.constraint(equalTo: viewForVideo.topAnchor),
//                videoPlayerController.view.bottomAnchor.constraint(equalTo: viewForVideo.bottomAnchor)
//            ])
//            videoPlayer?.play()
//        }
//        PlayVideo()
    }
    
    @IBAction func onClickPlayPause(_ sender: UIButton) {
        print("onClickPlayPause")
        if isPlaying {
            player.pause()
            imgPlayAndPause.image = UIImage(named: "imgPlay")
        } else {
            player.play()
            imgPlayAndPause.image = UIImage(named: "imgPause")
        }
        isPlaying.toggle()
    }
    
    @IBAction func onEditingChangeSlider(_ sender: UISlider) {
        let newTime = CMTimeMake(value: Int64(sender.value * 1000), timescale: 1000)
        currentTimeLabel.text = formatTime(from: newTime) + " / "
    }
    @IBAction func timeSliderChanged(_ sender: UISlider) {
        let newTime = CMTimeMake(value: Int64(sender.value * 1000), timescale: 1000)
        player.seek(to: newTime)
    }
    
    @IBAction func onClickMore(_ sender: UIButton) {
        
    }
    
    @IBAction func onClickFullScreen(_ sender: UIButton) {
        
    }
    
    @IBAction func ontapLike(_ sender: UIButton){
        let isLike = profileVideoModel?.likes?.contains(trim(userProfileModel?.uid)) ?? false
        imgHeart.image = isLike ? UIImage(systemName: "heart") : UIImage(named: "imgHeartFill")
        likeVideo()
    }
    @IBAction func ontapComments(_ sender: UIButton){
        pushForComments()
    }
    @IBAction func onTapTagPerson() {
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
        vc?.isFromHome = true
        if let arrayTagPerson = profileVideoModel?.tagPersons {
            vc?.selectedUser = arrayTagPerson
        }
        self.present(vc!, animated: true)
    }
    
    @IBAction func onClickVideo() {
        isShowVideoIndicator = !isShowVideoIndicator
        arrayForVideoIndicator.forEach({ $0.isHidden = !isShowVideoIndicator })
        timeSlider.isHidden = !isShowVideoIndicator
    }
    
    @IBAction func onClickSend() {
        if isCommentReply {
            submitReply()
        } else {
            submitComment()
        }
    }
    

}

extension HomeVC {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = viewForVideo.bounds
    }
    
    // MARK: - Setup Video Player
    private func setupVideoPlayer() {
        guard let url = URL(string: trim(profileVideoModel?.videoUrl)) else {
            print("Invalid URL")
            return
        }
        
        player = AVPlayer(url: url)
        
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        viewForVideo.layer.addSublayer(playerLayer)
        playerLayer?.frame = viewForVideo.bounds
        player.play()
        addTimeObserver()
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            guard let self = self, let currentItem = self.player.currentItem else { return }
            
            let currentTime = currentItem.currentTime().seconds
            let duration = currentItem.duration.seconds
            
            if currentTime.isFinite && currentTime >= 0, duration.isFinite && duration > 0 {
                self.timeSlider.maximumValue = Float(duration)
                self.timeSlider.value = Float(currentTime)
                self.currentTimeLabel.text = "\(self.formatTime(from: currentItem.currentTime())) / "
                self.timeLabel.text = self.formatTime(from: currentItem.duration)
            } else {
                self.currentTimeLabel.text = "--:-- / "
                self.timeLabel.text = "--:--"
            }
        }
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        
        imgPlayAndPause.image = UIImage(named: "imgPlay")
        isPlaying = false
        timeSlider.value = timeSlider.maximumValue
        currentTimeLabel.text = formatTime(from: player.currentItem?.duration ?? CMTime.zero)
    }
    
    // MARK: - KVO for Duration
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
//                            totalTimeLabel.text = formatTime(from: player.currentItem?.duration ?? CMTime.zero)
        }
    }
    
    // MARK: - Time Slider Value Changed
    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
        let newTime = Double(sender.value)
        seekToTime(newTime: newTime)
    }
    
    // MARK: - Seek to Specific Time
    private func seekToTime(newTime: Double) {
        let time = CMTime(seconds: newTime, preferredTimescale: 1000)
        player.seek(to: time)
    }
    
    // MARK: - Format Time to String
    private func formatTime(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
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
                self.userProfileModel = user
                self.customTable.reloadData()
            } else {
                print("Failed to fetch user data.")
            }
        }
        fetchAllUsers { [weak self] arrayUser in
            guard let self = self else { return }
            arrayAllUsers = arrayUser
            customTable.reloadData()
        }
    }
    func onAppear(){
        
        
    }
    func configData() {
        self.profileVideoModel = UserManager.shared.videosModel?.first
        let isLike = profileVideoModel?.likes?.contains(trim(userProfileModel?.uid)) ?? false
        imgHeart.image = isLike ? UIImage(named: "imgHeartFill") : UIImage(systemName: "heart")
        lblLikesCount.text = trim(profileVideoModel?.likes?.count) + " Likes"
        let commentCount = profileVideoModel?.comments?.count ?? 0
        let totalRepliesCount = profileVideoModel?.comments?.reduce(0) { $0 + ($1.replies?.count ?? 0) }  ?? 0
        let totalComment = commentCount + totalRepliesCount
        lblCommentsCount.text = "\(totalComment) Comments"
        DispatchQueue.main.async {
            let thumbnailUrl = trim(self.profileVideoModel?.thumbnailUrl)
            if let urlProfile1 = URL(string: thumbnailUrl) {
                self.imgImage.sd_setImage(with: urlProfile1)
            }
        }
        showLoading = UserManager.shared.videosModel?.isEmpty ?? true
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
    
        if showLoading {
            self.startAnimating()
        }
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
                let hashtages    = data["hashTagsModelList"] as? [String] ?? []
                let language     = data["language"] as? String ?? ""
                let videoUrl     = data["videoUrl"] as? String ?? ""
                let thumbnailUrl = data["thumbnailUrl"] as? String ?? ""
                let likes = data["likes"] as? [String]
                let commentsData = data["commentList"] as? [[String: Any]] ?? []
                let comments = commentsData.map { parseCommentData(data: $0) }
                
                return ProfileVideosModel(uid: uid, id: id, address: address, Zipcode: zipcode, city: city, Title: title, tagPersons: TagPersons, description: description, categories: categories, hashtages: hashtages, language: language, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, likes: likes, comments: comments)
            }
            self.configData()
            
            self.stopAnimating()
        }
    }
    func fetchReels() {
        self.startAnimating()
        UserManager.shared.reelsModel?.removeAll()
        
        let collectionPath = "Swifts/\(UserDefault.token)/VideosData"

        let documentRef = db.collection(collectionPath)
        
        documentRef.getDocuments { (querySnapshot, error) in
            guard let document = querySnapshot?.documents else {
                print("No document")
                self.stopAnimating()
                return
            }
            
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
                let hashtages    = data["hashTagsModelList"] as? [String] ?? []
                let language     = data["language"] as? String ?? ""
                let videoUrl     = data["videoUrl"] as? String ?? ""
                let thumbnailUrl = data["thumbnailUrl"] as? String ?? ""
                let likes = data["likes"] as? [String]
                let commentsData = data["commentList"] as? [[String: Any]] ?? []
                let comments = commentsData.map { parseCommentData(data: $0) }

                let profileVideo = ProfileVideosModel(uid: uid, id: id, address: address, Zipcode: zipcode, city: city, Title: title, tagPersons: TagPersons, description: description, categories: categories, hashtages: hashtages, language: language, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, likes: likes, comments: comments)
                
                UserManager.shared.reelsModel?.append(profileVideo)
                
            }
            self.stopAnimating()
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
    
    func likeVideo() {
        let db = Firestore.firestore()
        let documentPath = "Videos/\(trim(profileVideoModel?.uid))/VideosData/\(trim(profileVideoModel?.id))"
        print("** documentPath: \(documentPath)")
        db.document(documentPath).getDocument { (document, error) in
            if let document = document, document.exists {
                
                var likes = document.data()?["likes"] as? [String] ?? []
                
                if likes.removeFirst(where: { $0 == trim(self.userProfileModel?.uid) }) == nil {
                    likes.append(trim(self.userProfileModel?.uid))
                }
                db.document(documentPath).updateData(["likes": likes]) { error in
                    if let error = error {
                        print("Error updating likes: \(error.localizedDescription)")
                    } else {
                        self.fetchVideos()
                        print("Successfully liked the video!")
                    }
                }
            } else {
                print("Document does not exist: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func likeCommentOrReply(commentId: String?, replyId: String?) {
        let db = Firestore.firestore()
        var documentPath = ""
        
        if let commentId = commentId {
            if let replyId = replyId {
                documentPath = "Videos/\(trim(profileVideoModel?.uid))/VideosData/\(trim(profileVideoModel?.id))/commentList/\(commentId)/replies/\(replyId)"
            } else {
                documentPath = "Videos/\(trim(profileVideoModel?.uid))/VideosData/\(trim(profileVideoModel?.id))/commentList/\(commentId)"
            }
        }
        
        print("** documentPath: \(documentPath)")
        
        startAnimating()
        
        db.document(documentPath).getDocument { (document, error) in
            if let document = document {
                print("** MI document: \(document.data())")
                if document.exists {
                    
                    var arrayLikes = document.data()?["likes"] as? [String] ?? []
                    
                    if arrayLikes.removeFirst(where: { $0 == trim(self.userProfileModel?.uid) }) == nil {
                        arrayLikes.append(trim(self.userProfileModel?.uid))
                    }
                    
                    db.document(documentPath).updateData(["likes": arrayLikes]) { error in
                        if let error = error {
                            self.stopAnimating()
                            print("Error updating likes: \(error.localizedDescription)")
                        } else {
                            self.fetchVideos()
                            print("Successfully liked/disliked the comment or reply!")
                        }
                    }
                } else {
                    self.stopAnimating()
                }
            } else {
                self.stopAnimating()
                print("Document does not exist: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func submitComment() {
        IQKeyboardManager.shared().resignFirstResponder()
        guard let userUID = userProfileModel?.uid, let videoID = profileVideoModel?.id, let videoOwnerUID = profileVideoModel?.uid else {
            print("Error: Missing user or video information.")
            return
        }
        
        let documentPath = "Videos/\(videoOwnerUID)/VideosData/\(videoID)"
        print("** documentPath: \(documentPath)")
        let newComment = CommentModel(
            id: uniqueID,
            likes: [],
            replies: [],
            text: trim(txtComment?.text),
            timestamp: Date().timeIntervalSince1970,
            uid: userUID
        )
        print("** newComment: \(newComment)")
        
        var currentComments = profileVideoModel?.comments ?? []
        
        currentComments.append(newComment)
        
        let arrayComment = currentComments.map { $0.toDictionary() }
        print("** documentPath: \(documentPath) commentsArray: \(arrayComment)")
        
        uploadComment(documentPath: documentPath, arrayComment: arrayComment) { [weak self] arrayComment in
            guard let self = self else { return }
            self.txtComment?.text = ""
            profileVideoModel?.comments = arrayComment
            self.configData()
        }
    }
    
    func submitReply() {
        IQKeyboardManager.shared().resignFirstResponder()
        guard
            let userUID = userProfileModel?.uid,
            let videoID = profileVideoModel?.id,
            let videoOwnerUID = profileVideoModel?.uid,
            let comments = profileVideoModel?.comments,
            comments.count > 0 else {
            print("Error: Missing user, video, or comment information.")
            return
        }

        let documentPath = "Videos/\(videoOwnerUID)/VideosData/\(videoID)"
        print("Document Path: \(documentPath)")

        let newReply = ReplyModel(
            id: uniqueID,
            likes: [],
            text: trim(txtComment?.text),
            timestamp: Date().timeIntervalSince1970,
            uid: userUID
        )
        print("New Reply: \(newReply)")

        var updatedComments = comments
        updatedComments[0].replies?.append(newReply)

        let commentsArray = updatedComments.map { $0.toDictionary() }
        print("Updated Comments Array: \(commentsArray)")
        
        uploadComment(documentPath: documentPath, arrayComment: commentsArray) { [weak self] arrayComments in
            guard let self = self else { return }

            self.txtComment?.text = ""
            self.profileVideoModel?.comments = arrayComments
            self.configData()
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
                    self.onTapTagPerson()
                } else if type == .ViewMore {
                    
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell: UserViewerCell = tableView.cell(for: indexPath)
            cell.config(userProfileModel: userProfileModel)
            return cell
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell: VideoCommentHeaderCell = tableView.cell(for: indexPath)
                cell.config(profileVideoModel: profileVideoModel) { [weak self] in
                    guard let self = self else { return }
                    self.pushForComments()
                }
                return cell
            } else if indexPath.row == 1 {
                let cell: VideoCommentCell = tableView.cell(for: indexPath)
                cell.config(profileVideoModel: profileVideoModel, arrayAllUsers: arrayAllUsers)
                cell.btnFavorite.addAction {
                    let documentPath = "Videos/\(trim(self.profileVideoModel?.uid))/VideosData/\(trim(self.profileVideoModel?.id))"
                    guard let comment = self.profileVideoModel?.comments?.first else { return }
                    likeOrDislikeComment(documentPath: documentPath, commentId: trim(comment.id), replyId: nil, userUID: trim(self.userProfileModel?.uid)) { arrayComment in
                        if let arrayComment {
                            self.profileVideoModel?.comments = arrayComment
                            self.customTable.reloadData()
                        }
                    }
                }
                cell.btnReply.addAction {
                    self.txtComment?.becomeFirstResponder()
                    self.isCommentReply = true
                }
                return cell
            } else if indexPath.row == 2 {
                let cell: writeCommentCell = tableView.cell(for: indexPath)
                cell.config(userProfileModel: userProfileModel, handler: onClickSend)
                self.txtComment = cell.txtComment
                return cell
            }
        } else if indexPath.section == 3 {
            let cell: CategoryButtonCell = tableView.cell(for: indexPath)
            return cell
        }
        return .init(frame: .zero)
    }
}
