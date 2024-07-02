//
//  ProfileVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit
import FirebaseFirestoreInternal
import AVFoundation
import Reachability
import FirebaseStorage


class ProfileVC: UIViewController {
     
    //MARK: - IBOUtlet
    @IBOutlet weak var vwVideo                 : UIView!
    @IBOutlet weak var vwSwift                 : UIView!
    @IBOutlet weak var vwCollection            : UIView!
    @IBOutlet weak var vwMenu                  : UIView!
    @IBOutlet weak var tblVideoHeightCons      : NSLayoutConstraint!
    @IBOutlet weak var tblVIdeos               : UITableView!
    @IBOutlet weak var stackVideos             : UIStackView!
    @IBOutlet weak var collectSwiftHeightCons  : NSLayoutConstraint!
    @IBOutlet weak var collectSwift            : UICollectionView!
    @IBOutlet weak var stackSwift              : UIStackView!
    @IBOutlet weak var stackCollection         : UIStackView!
    @IBOutlet weak var collectSwiftColl        : UICollectionView!
    @IBOutlet weak var tblVIdeosColl           : UITableView!
    @IBOutlet weak var tblVideosCollHeightCons : NSLayoutConstraint!
    @IBOutlet weak var stackMore               : UIStackView!
    @IBOutlet weak var tblMenu                 : UITableView!
    @IBOutlet weak var stackMenu               : UIStackView!
    @IBOutlet weak var tblMenuHeightCons       : NSLayoutConstraint!
    @IBOutlet weak var btnMore                 : UIButton!
    @IBOutlet weak var vwAddBio                : UIView!
    
    @IBOutlet weak var lblChannelName          : UILabel!
    @IBOutlet weak var lblChannelType          : UILabel!
    @IBOutlet weak var lblEmail                : UILabel!
    @IBOutlet weak var lblWebLInk              : UILabel!
    @IBOutlet weak var lblAddress              : UILabel!
    @IBOutlet weak var lblMondayDuration       : UILabel!
    @IBOutlet weak var lblTuesdayDuration      : UILabel!
    @IBOutlet weak var lblWednesdayDuration    : UILabel!
    @IBOutlet weak var lblThursdayDuration     : UILabel!
    @IBOutlet weak var lblFridayDuration       : UILabel!
    @IBOutlet weak var lblSaturdayDuration     : UILabel!
    @IBOutlet weak var lblSundayDuration       : UILabel!
    @IBOutlet weak var lblFollowing            : UILabel!
    @IBOutlet weak var lblFollowers            : UILabel!
    @IBOutlet weak var imgCover                : UIImageView!
    @IBOutlet weak var imgProfile              : UIImageView!
    @IBOutlet weak var stackWeekTimes          : UIStackView!
    @IBOutlet weak var lblBio                  : UILabel!
    @IBOutlet weak var btnAddBio               : UIButton!
    @IBOutlet weak var lblTagPersons           : UILabel!
    @IBOutlet weak var btn3dots                : UIButton!
    @IBOutlet weak var vwCover                 : UIView!
    @IBOutlet weak var vwProfile               : UIView!
    @IBOutlet weak var btnSeeMore              : UIButton!
    
    
    //MARK: - Variables and Properties
    let reachability = try! Reachability()
    var arr: [String]   = ["" , "" , ""]
    var currentImage    : UIImage!
    var CurrentTagImg   : Int?
    var db = Firestore.firestore()
    var responseModel   : [ProfileVideosModel]? = []
    let itemsPerColumn  : Int = 2
    let itemHeight      : CGFloat = 250.0 // Example item height
    var selectedVideo   : ProfileVideosModel? = nil
    var player          : AVPlayer!
    var playerLayer     : AVPlayerLayer!
    var profileModel    : UserProfileModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    //MARK: IBActions {}
    @IBAction func ontapAddProfileImg(_ sender: UIButton){
        CurrentTagImg = sender.tag
        pickImg()
    }
    @IBAction func ontapMenuDots(_ sender: UIButton){
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AccountActionPopupVC") as! AccountActionPopupVC
        vc.delegate  = self
        self.present(vc, animated: true)
    }
    @IBAction func ontapOtherLoc(_ sender: UIButton) {
        
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "OtherLocVC") as! OtherLocVC
        self.present(vc, animated: true)
    }
    @IBAction func ontapSetting(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.hidesBottomBarWhenPushed = true
        vc.profileModel = self.profileModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ontapAddBio(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AddBioVC") as! AddBioVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ontappFollowers(_ sender: UIButton) {
        if sender.tag == 0 {
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
            vc.hidesBottomBarWhenPushed = true
            vc.isFollowers = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
            vc.hidesBottomBarWhenPushed = true
            vc.isFollowers = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func ontapTagPeople(_ sender: UIButton) {
        
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
        vc?.showTagUsers = true
        self.present(vc!, animated: true)
    }
    @IBAction func ontapTabPressed(_ sender: UIButton){
        if sender.tag      == 0 {
            vwVideo.isHidden         = false
            vwSwift.isHidden         = true
            vwCollection.isHidden    = true
            vwMenu.isHidden          = true
            stackVideos.isHidden     = false
            stackSwift.isHidden      = true
            stackCollection.isHidden = true
            stackMenu.isHidden       = true
        }
        else if sender.tag == 1 {
            vwVideo.isHidden         = true
            vwSwift.isHidden         = false
            vwCollection.isHidden    = true
            vwMenu.isHidden          = true
            stackVideos.isHidden     = true
            stackSwift.isHidden      = false
            stackCollection.isHidden = true
            stackMenu.isHidden       = true
        }
        else if sender.tag == 2 {
            vwVideo.isHidden         = true
            vwSwift.isHidden         = true
            vwCollection.isHidden    = false
            vwMenu.isHidden          = true
            stackVideos.isHidden     = true
            stackSwift.isHidden      = true
            stackCollection.isHidden = false
            stackMenu.isHidden       = true
        }
        else  {
            vwVideo.isHidden         = true
            vwSwift.isHidden         = true
            vwCollection.isHidden    = true
            vwMenu.isHidden          = false
            stackVideos.isHidden     = true
            stackSwift.isHidden      = true
            stackCollection.isHidden = true
            stackMenu.isHidden       = false
        }
    }
    @IBAction func ontapSeeMore(_ sender: UIButton){
        if stackMore.isHidden == true {
            stackMore.isHidden = false
            btnMore.setTitle("view less info", for: .normal)
        }
        else{
            stackMore.isHidden = true
            btnMore.setTitle("view more info", for: .normal)
        }
    }
}

//MARK: - Setup Profile {}
extension ProfileVC {
   
    func onload() {
        setupView()
    }
    
    func updateCoverUrlInModel(newCoverUrl: String) {
        if var model = self.profileModel {
            model.coverUrl = newCoverUrl
            self.profileModel = model
            self.setupProfile(user: model)
        }
    }
    
    func updateProfileUrlInModel(newProfileUrl: String) {
        if var model = self.profileModel {
            model.profileUrl = newProfileUrl
            self.profileModel = model
            self.setupProfile(user: model)
        }
    }
    
    func setupProfile(user: UserProfileModel) {
        
        lblChannelName.text = user.channelName ?? ""
        lblChannelType.text = "(" + (user.accountType ?? "") + ")"
        lblEmail.text       = user.email ?? ""
        lblWebLInk.text     = user.website ?? ""
        lblAddress.text     = user.address ?? ""
        lblFollowers.text   = "\(user.followers?.count ?? 0) Followers"
        lblFollowing.text   = "\(user.followings?.count ?? 0) Following"
        if UserDefault.token == user.uid {
            btn3dots.isHidden = true
        }
        else{
            btn3dots.isHidden = false
        }
        if user.tagPersons?.count != 0 {
            lblTagPersons.text = "\(user.tagPersons?.count ?? 0) person"
        }
        else{
            lblTagPersons.text = "0 person"
        }
        if user.bio == "" {
            btnAddBio.isHidden = false
            lblBio.isHidden    = true
            vwAddBio.isHidden  = false
        }
        else{
            lblBio.isHidden     = false
            btnAddBio.isHidden  = true
            vwAddBio.isHidden  = true
            lblBio.text         = user.bio ?? ""
        }
        if user.accountType == "Private person" || user.accountType == "Content Creator" {
            btnSeeMore.isUserInteractionEnabled = false
        }
        else{
            btnSeeMore.isUserInteractionEnabled = true
        }
        if !(user.timings?.isEmpty ?? true) {
          //  stackWeekTimes.isHidden    = false
            print("Monday                   \(user.timings?[0] ?? "")")
            lblMondayDuration.text     = user.timings?[0] ?? ""
            lblTuesdayDuration.text    = user.timings?[1] ?? ""
            lblWednesdayDuration.text  = user.timings?[2] ?? ""
            lblThursdayDuration.text   = user.timings?[3] ?? ""
            lblFridayDuration.text     = user.timings?[4] ?? ""
            lblSaturdayDuration.text   = user.timings?[5] ?? ""
            lblSundayDuration.text     = user.timings?[6] ?? ""
        }
        else{
          //  stackWeekTimes.isHidden = true
        }
        if user.coverUrl != "" {
            vwCover.isHidden = true
        }
        if user.profileUrl != "" {
            vwProfile.isHidden = true
        }
        DispatchQueue.main.async {
            if let coverURL = user.coverUrl, let urlCover1 = URL(string: coverURL) {
                self.imgCover.sd_setImage(with: urlCover1)
            }
        }
        DispatchQueue.main.async {
            if let profileURL = user.profileUrl, let urlProfile1 = URL(string: profileURL) {
                self.imgProfile.sd_setImage(with: urlProfile1)
            }
        }
        updateUserDocument()
    }
    
    func setupView() {
        tblVIdeos.register(VideoTCell.nib, forCellReuseIdentifier: VideoTCell.identifier)
        tblVIdeos.delegate            = self
        tblVIdeos.dataSource          = self
        
        tblVIdeos.register(NoPostTCell.nib, forCellReuseIdentifier: NoPostTCell.identifier)
        tblVIdeos.delegate            = self
        tblVIdeos.dataSource          = self
        
        tblVIdeos.register(VideosHeaderView.nib, forHeaderFooterViewReuseIdentifier: VideosHeaderView.identifier)
        
        collectSwift.register(SwiftCCell.nib, forCellWithReuseIdentifier: SwiftCCell.identifier)
        collectSwift.delegate        = self
        collectSwift.dataSource      = self
        
        collectSwiftColl.register(SwiftCCell.nib, forCellWithReuseIdentifier: SwiftCCell.identifier)
        collectSwiftColl.delegate   = self
        collectSwiftColl.dataSource = self
        
        tblVIdeosColl.register(VideoTCell.nib, forCellReuseIdentifier: VideoTCell.identifier)
        tblVIdeosColl.delegate     = self
        tblVIdeosColl.dataSource   = self
        
        tblMenu.register(MenuTCell.nib, forCellReuseIdentifier: MenuTCell.identifier)
        tblMenu.delegate           = self
        tblMenu.dataSource         = self
    }
    
    func onAppear() {
        
        vwVideo.isHidden         = false
        vwSwift.isHidden         = true
        vwCollection.isHidden    = true
        vwMenu.isHidden          = true
        stackVideos.isHidden     = false
        stackMenu.isHidden       = true
        
        if UserDefault.isAuthenticated {
            fetchDataFromFirestore()
            fetchUserData(userID: UserDefault.token) { user in
                self.stopAnimating()
                if let user = user {
                    // Use the user model as needed
                    self.setupProfile(user: user)
                    self.profileModel = user
                    print("User data: \(user)")
                } else {
                    print("Failed to fetch user data.")
                }
            }
        }
     
    }
    
    func updateCollectionViewHeight() {
        let numberOfItems = responseModel?.count ?? 0
        let numberOfRows = ceil(Double(numberOfItems) / Double(itemsPerColumn))
        let newHeight = numberOfRows * Double(itemHeight)
        collectSwiftHeightCons.constant = CGFloat(newHeight)
    }
    
    func setupAVPlayer(with url: URL , vw: UIView) -> AVPlayerLayer {

        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = vw.bounds
        playerLayer.videoGravity = .resizeAspectFill
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        return playerLayer
        //self.view.layer.addSublayer(playerLayer)
       //
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
            player.seek(to: .zero) {
                _ in self.player.play()
            }
        }
}

//MARK: - TableVew {}
extension ProfileVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblVIdeos {
            if (responseModel?.count ?? 0) == 0 {
                return 1
            }
            else{
                return 1
            }
        }
        if tableView == tblMenu {
          return 1
        }
        else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVIdeos {
            if (responseModel?.count ?? 0) == 0 {
                return 1
            }
            else{
                tblVideoHeightCons.constant = CGFloat(300 + ((responseModel?.count ?? 0) * 140))
                //return arr.count
                return responseModel?.count ?? 0
            }
        }
        if tableView == tblMenu {
            tblMenuHeightCons.constant = CGFloat(arr.count * 105)
            return arr.count
        }
        else{
            tblVideosCollHeightCons.constant = CGFloat(arr.count * 105)
            return arr.count
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "VideosHeaderView") as! VideosHeaderView
        if self.selectedVideo?.videoUrl ?? "" != ""{
            headerView.btnPlay.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            headerView.vwVideo.layer.addSublayer(setupAVPlayer(with: URL(string: self.selectedVideo?.videoUrl ?? "")!, vw: headerView.vwVideo))
            headerView.btnPlay.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
            headerView.lblTitle.text = self.selectedVideo?.description ?? ""
            headerView.lblViews.text = "3 October 2002 / 200 views"
            player.pause()
            
        }
        else if responseModel?.count != 0{
            headerView.btnPlay.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            headerView.vwVideo.layer.addSublayer(setupAVPlayer(with: URL(string: self.responseModel?[0].videoUrl ?? "")!, vw: headerView.vwVideo))
            headerView.btnPlay.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
            headerView.lblTitle.text = self.responseModel?[0].description ?? ""
            headerView.lblViews.text = "3/10/2002 / 200 views"
            player.pause()
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblVIdeos {
//            if self.selectedVideo?.videoUrl ?? "" != "" {
//                return 300
//            }
           // else{
                return 300
          //  }
        }
        if tableView == tblMenu {
            return 0
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVIdeos {
            if (responseModel?.count ?? 0) == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoPostTCell.identifier, for: indexPath) as! NoPostTCell
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: VideoTCell.identifier, for: indexPath) as! VideoTCell
                cell.lblDEscrip.text = responseModel?[indexPath.row].description ?? ""
                cell.lblName.text    = responseModel?[indexPath.row].Title ?? ""
                cell.lblDateViews.text    = "3 October 2002 / 200 views"
                DispatchQueue.main.async {
                    guard let url = self.responseModel?[indexPath.row].ThumbnailUrl else {
                        return
                    }
                    let url1 = URL(string: url)!
                    cell.imgVideo?.sd_setImage(with: url1)
                }
                return cell
            }
        }
        if tableView == tblMenu {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTCell.identifier, for: indexPath) as! MenuTCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoTCell.identifier, for: indexPath) as! VideoTCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblMenu {
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "MenuDetailPopupVC") as! MenuDetailPopupVC
            self.present(vc, animated: true)
        }
        else if tableView == tblVIdeos {
            self.selectedVideo = responseModel?[indexPath.row]
            tblVIdeos.reloadData()
        }
    }
    
    @objc func playButtonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            sender.tag = 1
            player.play()
        }
        else{
            sender.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            sender.tag = 0
            player.pause()
        }
    }
}

//MARK: - collection view {}
extension ProfileVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectSwift {
            //collectSwiftHeightCons.constant = 250 * 3
            updateCollectionViewHeight()
            return responseModel?.count ?? 0
        }
        else{
           return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectSwift {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftCCell.identifier, for: indexPath) as! SwiftCCell
            cell.lblDescrip.text = responseModel?[indexPath.row].description ?? ""
            cell.lblName.text    = responseModel?[indexPath.row].Title ?? ""
            DispatchQueue.main.async {
                guard let url = self.responseModel?[indexPath.row].ThumbnailUrl else {
                    return
                }
                let url1 = URL(string: url)!
                cell.imgMain?.sd_setImage(with: url1)
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftCCell.identifier, for: indexPath) as! SwiftCCell
            // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoPostCCell.identifier, for: indexPath) as! NoPostCCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectSwift {
            
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "SwiftVC") as? SwiftVC
            vc?.responseModel = self.responseModel
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 250)
    }
    
}

//MARK: - Protocol of AccountreportDelete
extension ProfileVC: AccountReportDelete {
    func action(call: String) {
        if call == "Report" {
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AccountReportVC") as! AccountReportVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "BlockUserPopUpVC") as! BlockUserPopUpVC
            self.present(vc, animated: true)
        }
    }
    
}

//MARK: - Protocol Image Picker {}
extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickImg() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        if CurrentTagImg == 0 {
            imgProfile.image = currentImage
            uploadProfileImg(currentImage, userID: UserDefault.token)
           
        }
        else {
            imgCover.image   = currentImage
            uploadCoverImg(currentImage, userID: UserDefault.token)
        }
    }
}

//MARK: - Get Videos / profile / change cover / change profile {}
extension ProfileVC {
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
                                            followers: data?["followers"] as? [String] ?? [],
                                            followings: data?["followings"] as? [String] ?? [],
                                            timings: data?["timings"] as? [String] ?? [],
                                            tagPersons: tagPersons,
                                            selectedTypeOfRegion: data?["selectedTypeOfRegion"] as? [String] ?? [],
                                            selectedMeals: data?["selectedMeals"] as? [String] ?? [],
                                            selectedSpecialize: data?["selectedSpecialize"] as? [String] ?? [],
                                            channelName: data?["channelName"] as? String ?? "",
                                            dateOfBirth: data?["dateOfBirth"] as? String ?? "",
                                            email: data?["email"] as? String ?? "",
                                            phoneNumber: data?["phoneNumber"] as? String ?? "")
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
    func fetchDataFromFirestore() {
    
        self.startAnimating()
        let userToken = UserDefaults.standard.string(forKey: "token") ?? "defaultToken1"
        let videosCollectionRef = db.collection("Videos").document(userToken).collection("VideosData")
        
        videosCollectionRef.addSnapshotListener { querysnap, error in
            guard let document = querysnap?.documents else {
                print("no document")
                self.stopAnimating()
                return
            }
            self.responseModel = document.map  { (QueryDocumentSnapshot) -> ProfileVideosModel in
                
                let data         =  QueryDocumentSnapshot.data()
                let address      = data["address"] as? String ?? ""
                let ZipCode      = data["Zipcode"] as? String ?? ""
                let city         = data["city"] as? String ?? ""
                let hashTagsList = data["hashTagsModelList"] as? [String] ?? []
                let Title        = data["Title"] as? String ?? ""
                let description  = data["description"] as? String ?? ""
                let language     = data["language"] as? String ?? ""
                let ThumbnailUrl = data["ThumbnailUrl"] as? String ?? ""
                let videoUrl     = data["videoUrl"] as? String ?? ""
                return ProfileVideosModel(address: address, Zipcode: ZipCode, city: city, hashTagsModelList: hashTagsList, Title: Title, description: description, language: language, ThumbnailUrl: ThumbnailUrl, videoUrl: videoUrl)
            }
            self.stopAnimating()
            print(self.responseModel)
            self.collectSwift.reloadData()
            self.tblVIdeos.reloadData()
        }
    }
    func uploadCoverImg(_ img: UIImage, userID: String) {
        self.startAnimating()
        if reachability.isReachable {
            let uniqueID = UUID().uuidString
            let storageRef = Storage.storage().reference().child("covers/\(uniqueID).png") // Store in "covers" directory
            guard let imgData = img.pngData() else {
                self.stopAnimating()
                print("Error: Could not convert image to PNG data")
                return
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            storageRef.putData(imgData, metadata: metadata) { metadata, error in
                self.stopAnimating() // Stop animating when upload is finished
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                // Successfully uploaded the image
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let downloadURL = url else {
                        print("Error: Download URL is nil")
                        return
                    }
                    
                    print("Download success, URL: \(downloadURL.absoluteString)")
                    // Update the user's coverUrl in Firestore
                    let db = Firestore.firestore()
                    db.collection("Users").document(userID).updateData([
                        "coverUrl": downloadURL.absoluteString
                    ]) { err in
                        if let err = err {
                            print("Error updating coverUrl: \(err)")
                        } else {
                            print("Cover URL successfully updated in Firestore")
                            self.updateCoverUrlInModel(newCoverUrl: downloadURL.absoluteString)
                        }
                    }
                }
            }
        } else {
            self.showToast(message: "Internet connection is off.", seconds: 2, clr: .red)
        }
    }
    func uploadProfileImg(_ img: UIImage, userID: String) {
        self.startAnimating()
        if reachability.isReachable {
            let uniqueID = UUID().uuidString
            let storageRef = Storage.storage().reference().child("profiles/\(uniqueID).png") // Store in "covers" directory
            guard let imgData = img.pngData() else {
                self.stopAnimating()
                print("Error: Could not convert image to PNG data")
                return
            }
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            
            storageRef.putData(imgData, metadata: metadata) { metadata, error in
                self.stopAnimating() // Stop animating when upload is finished
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                // Successfully uploaded the image
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let downloadURL = url else {
                        print("Error: Download URL is nil")
                        return
                    }
                    
                    print("Download success, URL: \(downloadURL.absoluteString)")
                    // Update the user's coverUrl in Firestore
                    let db = Firestore.firestore()
                    db.collection("Users").document(userID).updateData([
                        "profileUrl": downloadURL.absoluteString
                    ]) { err in
                        if let err = err {
                            print("Error updating coverUrl: \(err)")
                        } else {
                            print("Cover URL successfully updated in Firestore")
                            self.updateProfileUrlInModel(newProfileUrl: downloadURL.absoluteString)
                        }
                    }
                }
            }
        } else {
            self.showToast(message: "Internet connection is off.", seconds: 2, clr: .red)
        }
    }
    
    //update user in userCollection for data shoudl be updated everytime. if user change profile
    func updateUserDocument() {
        let db = Firestore.firestore()
        let userToken = UserDefault.token
        
        db.collection("userCollection").whereField("uid", isEqualTo: userToken).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    let documentID = document.documentID
                    // New data to update the document
                    let updatedData: [String: Any] = [
                        "img": self.profileModel?.profileUrl ?? "",
                    ]
                    db.collection("userCollection").document(documentID).updateData(updatedData) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                }
            }
        }
    }
}

