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


class ProfileVC: BaseClass , UpdateUserProfileFrmSettingDelegate{
    func callAPI() {
        popup()
    }
    
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
    @IBOutlet weak var vwCollect               : UICollectionView!
    
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
    
    @IBOutlet weak var btnSettings             : UIButton!
    @IBOutlet weak var btnFollow               : UIButton!
    @IBOutlet weak var lblFounded              : UILabel!
    @IBOutlet weak var lblPhoneNumbr           : UILabel!
    @IBOutlet weak var lblCurrnetDay           : UILabel!
    
    @IBOutlet weak var vwPhone             : UIView!
    @IBOutlet weak var vwWeb               : UIView!
    @IBOutlet weak var vwEmail             : UIView!
    @IBOutlet weak var vwAddress           : UIView!
    
    //MARK: - Variables and Properties
    let reachability = try! Reachability()
    var arr: [String]   = ["" , "" , ""]
    var currentImage    : UIImage!
    var CurrentTagImg   : Int?
    var db = Firestore.firestore()
    var responseModel   : [ProfileVideosModel]? = []
    var reelsModel      : [ProfileVideosModel]? = []
    var videosModel     : [ProfileVideosModel]? = []
    let itemsPerColumn  : Int = 2
    let itemHeight      : CGFloat = 305.0 // Example item height
    var selectedVideo   : ProfileVideosModel? = nil
    var player          : AVPlayer!
    var playerLayer     : AVPlayerLayer!
    var profileModel    : UserProfileModel? = nil
    var isNonOwner      : Bool              = false  //non authenticated user come here by tag users section
    var nonProfileModel : TagUsers?         = nil
    var isfirstTime     : Bool              = false
    var groups: [GroupsModel]               = []
    var groupItems: [GroupsItemModel?]      = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefault.isAuthenticated {
            let vc  = Constants.authStoryBoard.instantiateViewController(withIdentifier: "LoginNC") as? LoginNC
            vc?.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc!, animated: true)
        }
        else{
            onload()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserDefault.isAuthenticated {
            let vc  = Constants.authStoryBoard.instantiateViewController(withIdentifier: "LoginNC") as? LoginNC
            vc?.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(vc!, animated: true)
        }
        else{
            onAppear()
        }
    }
    
    //MARK: IBActions {}
    @IBAction func ontapAddProfileImg(_ sender: UIButton){
        CurrentTagImg = sender.tag
        pickImg()
    }
    @IBAction func ontapWeb(_ sender: UIButton) {
        
        self.showAlertCOmpletion2Options(withTitle: "FortuneCooks", message: "You are about to leave the app and visit an external website. Do you wish to continue?") { status in
            if status{
                guard var website = self.profileModel?.website else {
                    return
                }
                // Add "https://" if the URL does not already have a scheme
                if !website.lowercased().hasPrefix("http://") && !website.lowercased().hasPrefix("https://") {
                    website = "https://\(website)"
                }

                guard let url = URL(string: website) else {
                    return
                }

                // Check if the device can open the URL
                if UIApplication.shared.canOpenURL(url) {
                    // Open the URL in the default web browser
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Handle the case where the device cannot open the URL
                    print("Cannot open website URL")
                }
            }
        }
    }
    @IBAction func ontapEmail(_ sender: UIButton) {
        self.showAlertCOmpletion2Options(withTitle: "FortuneCooks", message: "You are about to leave the app and visit an external email. Do you wish to continue?") { status in
            guard let email = self.profileModel?.businessEmail else {
                return
            }
            let mailto = "mailto:\(email)"
            if let mailURL = URL(string: mailto) {
                // Check if the device can open the mailto URL
                if UIApplication.shared.canOpenURL(mailURL) {
                    // Open the mailto URL to compose an email
                    UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
                } else {
                    // Handle the case where the device cannot open the mailto URL
                    print("Cannot open mail client")
                }
            } else {
                // Handle the case where the mailto URL could not be created
                print("Invalid email address URL")
            }
        }
    }
    @IBAction func ontapAddress(_ sender: UIButton) {
        self.showAlertCOmpletion2Options(withTitle: "FortuneCooks", message: "You are about to leave the app and visit an external mapz. Do you wish to continue?") { status in
            guard let address = self.profileModel?.address else {
                return
            }
            
            let query = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let mapsURLString = "http://maps.apple.com/?q=\(query ?? "")"
            if let mapsURL = URL(string: mapsURLString) {
                if UIApplication.shared.canOpenURL(mapsURL) {
                    // Open the address in the Maps app
                    UIApplication.shared.open(mapsURL, options: [:], completionHandler: nil)
                } else {
                    // Handle the case where the device cannot open the maps URL
                    print("Cannot open Maps app")
                }
            } else {
                // Handle the case where the maps URL could not be created
                print("Invalid address URL")
            }
        }
    }
    @IBAction func ontapNumber(_ sender: UIButton) {
        guard let number = self.profileModel?.businessphoneNumber else {
            // Handle the case where the phone number is not available
            return
        }
        // Create a URL with the "tel" scheme
        if let phoneURL = URL(string: "tel://\(number)") {
            // Check if the device can open the URL
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                print("Device cannot make phone calls")
            }
        } else {
            print("Invalid phone number URL")
        }
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
        sender.isEnabled = false
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = self
        vc.profileModel = self.profileModel
        self.navigationController?.pushViewController(vc, animated: true)
        // Perform the action
        performAction {
            sender.isEnabled = true
        }
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
            vc.alreadyFollowingsUsers = profileModel?.followings ?? []
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
            vc.hidesBottomBarWhenPushed = true
            vc.isFollowers = true
            vc.alreadyFollowingsUsers = profileModel?.followers ?? []
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func ontapFollow(_ sender: UIButton) {
        
        if btnFollow.titleLabel?.text == "Follow" {
            var model = UserManager.shared.ownerProfileFollowing
            model.append(UserTagModel(uid: nonProfileModel?.uid ?? "", img: nonProfileModel?.img ?? "", channelName: nonProfileModel?.channelName ?? "", followers: nonProfileModel?.followers ?? "", accountType: nonProfileModel?.accountType ?? ""))
          //  addFollowersPeoplesList(nonProfileModel?.uid ?? "", tagUser: model)
            addFollowingPeoplesList(UserDefault.token, tagUser: model)
            btnFollow.setTitle("Following", for: .normal)
        }
        else {
            for i in 0 ..< (UserManager.shared.ownerProfileFollowing.count ?? 0) {
                print(UserManager.shared.ownerProfileFollowing[i])
                if UserManager.shared.ownerProfileFollowing[i].uid == nonProfileModel?.uid {
                    UserManager.shared.ownerProfileFollowing.remove(at: i)
                    var model = UserManager.shared.ownerProfileFollowing
                    addFollowingPeoplesList(UserDefault.token, tagUser: model)
                }
            }
            btnFollow.setTitle("Follow", for: .normal)
        }
    }
    @IBAction func ontapTagPeople(_ sender: UIButton) {
        
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
        vc?.showTagUsers = true
        vc?.delegate     = self
        vc?.alreadyTagUsers = profileModel?.tagPersons ?? []
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
        if UserDefault.isAuthenticated {
            setupView()
            fetchUserData(userID: isNonOwner ? nonProfileModel?.uid ?? "" : UserDefault.token) { user in
                self.stopAnimating()
                if let user = user {
                    // Use the user model as needed
                    self.setupProfile(user: user)
                    self.profileModel = user
                    self.fetchVideosFromFirestore()
                    print("User data: \(user)")
                } else {
                    print("Failed to fetch user data.")
                }
            }
        }
        else{
            showAlertCOmpletion(withTitle: "", message: "Access to the profile screen is restricted due to authentication requirements.") { status in
                if status {
                    self.tabBarController?.selectedIndex = 0
                }
            }
        }
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
        
        vwCollect.register(MenuCCell.nib, forCellWithReuseIdentifier: MenuCCell.identifier)
        vwCollect.delegate   = self
        vwCollect.dataSource = self
    }
    func onAppear() {
        if isfirstTime {
            if UserDefault.isAuthenticated {
                fetchUserData(userID: isNonOwner ? nonProfileModel?.uid ?? "" : UserDefault.token) { user in
                    self.stopAnimating()
                    if let user = user {
                        // Use the user model as needed
                        self.setupProfile(user: user)
                        self.profileModel = user
                        if  UserManager.shared.gothroughUploading {
                             self.fetchVideosFromFirestore()
                        }
                        print("User data: \(user)")
                    } else {
                        print("Failed to fetch user data.")
                    }
                }
            }
            else{
                showAlertCOmpletion(withTitle: "", message: "Access to the profile screen is restricted due to authentication requirements.") { status in
                    if status {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            }
        }
        if UserDefault.isAuthenticated {
            getMenuGroup(id: "821ACC7A-D858-47B3-9E71-187DC482CE21")
        }
        vwVideo.isHidden         = false
        vwSwift.isHidden         = true
        vwCollection.isHidden    = true
        vwMenu.isHidden          = true
        stackVideos.isHidden     = false
        stackMenu.isHidden       = true
        
        vwVideo.isHidden         = false
        vwSwift.isHidden         = true
        vwCollection.isHidden    = true
        vwMenu.isHidden          = true
        stackVideos.isHidden     = false
        stackSwift.isHidden      = true
        stackCollection.isHidden = true
        stackMenu.isHidden       = true
        
        hidesBottomBarWhenPushed = false
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
        if user.timings?.count != 0 {
            var range = user.timings?[getCurrentDayOfWeek().1]
            lblCurrnetDay.text  = "Opening Hours (\(getCurrentDayOfWeek().0)) \(isRestaurantOpen(timeRange:range ?? "") ? "Open" : "Closed")"
        }
        else{
            lblCurrnetDay.text  = "Opening Hours (\(getCurrentDayOfWeek().0)) Closed"
        }
        lblChannelName.text = user.channelName ?? ""
        lblChannelType.text = "(" + (user.accountType ?? "") + ")"
        lblEmail.text       = user.businessEmail != nil ?? "" ? "Email: \(user.businessEmail ?? "")" : ""
        if user.businessphoneNumber == "" {
            vwPhone.isHidden = true
        }
        else{
            vwPhone.isHidden = false
        }
        
        if user.website == "" {
            vwWeb.isHidden = true
        }
        else{
            vwWeb.isHidden = false
        }
        
        if user.businessEmail == "" {
            vwEmail.isHidden = true
        }
        else{
            vwEmail.isHidden = false
        }
        if user.address == "" {
            vwAddress.isHidden = true
        }
        else{
            vwAddress.isHidden = false
        }
        lblPhoneNumbr.text  = user.businessphoneNumber != nil ?? "" ? "Phone Number: \(user.businessphoneNumber ?? "")" : ""
        lblWebLInk.text     = user.website != nil ?? "" ? "Website: \(user.website ?? "")" : ""
        lblAddress.text     = "\(user.address ?? "") \(user.zipcode ?? "") \(user.city ?? "")"
        lblFollowers.text   = "\(user.followers?.count ?? 0) Followers"
        lblFollowing.text   = "\(user.followings?.count ?? 0) Following"
        lblFounded.text     = "Founded: \(user.dateOfBirth ?? "")"
        if user.isFoundedVisible ?? false {
            lblFounded.isHidden = false
        }
        else{
            lblFounded.isHidden = true
        }
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
            btnSeeMore.isHidden                 = true
        }
        else{
            btnSeeMore.isUserInteractionEnabled = true
            btnSeeMore.isHidden                 = false
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
            vwCover.isHidden =  true
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
        
        if isNonOwner { //Means you have visited another person profile you can change image of another profile
            btnFollow.isHidden   = false
            btnSettings.isHidden = true
            vwCover.isHidden     = true
            vwProfile.isHidden   = true
            for i in 0 ..< (UserManager.shared.ownerProfileFollowing.count ?? 0) {
                print(UserManager.shared.ownerProfileFollowing[i])
                if UserManager.shared.ownerProfileFollowing[i].uid == nonProfileModel?.uid {
                    btnFollow.setTitle("Following", for: .normal)
                    btnFollow.tintColor = UIColor.gray
                }
                else{
                    btnFollow.setTitle("Follow", for: .normal)
                    btnFollow.tintColor = UIColor.ColorLightGreen
                }
            }
        }
        else{
            btnFollow.isHidden   = true
            btnSettings.isHidden = false
            UserManager.shared.ownerProfileFollowing.removeAll()
            for i in 0 ..< (user.followings?.count ?? 0){
                UserManager.shared.ownerProfileFollowing.append(UserTagModel(uid: user.followings?[i].uid ?? "", img: user.followings?[i].img ?? "", channelName: user.followings?[i].channelName ?? "", followers: user.followings?[i].followers ?? "", accountType: user.followings?[i].accountType ?? ""))
            }
            print(UserManager.shared.ownerTagPeoples.count ?? 0)
            UserManager.shared.ownerTagPeoples.removeAll()
            for i in 0 ..< (user.tagPersons?.count ?? 0){
                UserManager.shared.ownerTagPeoples.append(TagUsers(uid: user.tagPersons?[i].uid ?? "", img: user.tagPersons?[i].img ?? "", channelName: user.tagPersons?[i].channelName ?? "", followers: user.tagPersons?[i].followers ?? "", accountType: user.tagPersons?[i].accountType ?? ""))
            }
            updateUserDocument()   //updating profile data of tag list to be updated user profile always
        }
    }
    func reelsAndVideosCollectionMaking() {
        self.reelsModel?.removeAll()
        self.videosModel?.removeAll()
        for i in 0 ..< (self.responseModel?.count ?? 0) {
            if var url  = URL(string: self.responseModel?[i].videoUrl ?? "") {
                if isReel(url: url) {
                    if var data = self.responseModel?[i] {
                        self.reelsModel?.append(data)
                    }
                }
                else{
                    if var data = self.responseModel?[i] {
                        self.videosModel?.append(data)
                    }
                }
            }
        }
        self.collectSwift.reloadData()
        self.tblVIdeos.reloadData()
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
    @objc func ontapUplaod(_ sender: UIButton) {
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "CameraNC") as? CameraNC
        vc?.modalPresentationStyle = .overFullScreen
        self.present(vc!, animated: true)
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
            if (videosModel?.count ?? 0) == 0 {
                return 1
            }
            else{
                tblVideoHeightCons.constant = CGFloat(300 + ((videosModel?.count ?? 0) * 140))
                return videosModel?.count ?? 0
            }
        }
        if tableView == tblMenu {
            tblMenuHeightCons.constant = CGFloat(groupItems.count * 170)
            return groupItems.count
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
        else if videosModel?.count != 0{
            headerView.btnPlay.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            headerView.vwVideo.layer.addSublayer(setupAVPlayer(with: URL(string: self.videosModel?[0].videoUrl ?? "")!, vw: headerView.vwVideo))
            headerView.btnPlay.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
            headerView.lblTitle.text = self.videosModel?[0].description ?? ""
            headerView.lblViews.text = "3/10/2002 / 200 views"
            player.pause()
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblVIdeos {
            if videosModel?.count != 0 {
                return 300
            }
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
            if (videosModel?.count ?? 0) == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoPostTCell.identifier, for: indexPath) as! NoPostTCell
               // cell.btnPost.isHidden = true
                cell.btnPost.addTarget(self, action: #selector(ontapUplaod), for: .touchUpInside)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: VideoTCell.identifier, for: indexPath) as! VideoTCell
                cell.lblDEscrip.text = videosModel?[indexPath.row].description ?? ""
                cell.lblName.text    = videosModel?[indexPath.row].Title ?? ""
                cell.lblDateViews.text    = "3 October 2002 / 200 views"
                DispatchQueue.main.async {
                    guard let url = self.videosModel?[indexPath.row].thumbnailUrl else {
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
            DispatchQueue.main.async {
                if let profileURL = self.groupItems[indexPath.row]?.img, let urlProfile1 = URL(string: profileURL) {
                    cell.imgMain.sd_setImage(with: urlProfile1)
                }
            }
            cell.lblName.text    = groupItems[indexPath.row]?.title ?? ""
            cell.lblDescrip.text = groupItems[indexPath.row]?.descrip ?? ""
            cell.lblPrice.text   = "\(groupItems[indexPath.row]?.price ?? "") \(groupItems[indexPath.row]?.currency ?? "")"
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
            vc.selectedItem = groupItems[indexPath.row]
            self.present(vc, animated: true)
        }
        else if tableView == tblVIdeos {
            self.selectedVideo = videosModel?[indexPath.row]
            tblVIdeos.reloadData()
        }
        else{
            
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
            return reelsModel?.count ?? 0
        }
        else if collectionView == vwCollect {
            return groups.count
        }
        else{
           return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectSwift {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftCCell.identifier, for: indexPath) as! SwiftCCell
            //cell.lblDescrip.text = reelsModel?[indexPath.row].description ?? ""
            cell.lblName.text    = reelsModel?[indexPath.row].Title ?? ""
            DispatchQueue.main.async {
                guard let url = self.reelsModel?[indexPath.row].thumbnailUrl else {
                    return
                }
                let url1 = URL(string: url)!
                cell.imgMain?.sd_setImage(with: url1)
            }
            return cell
        }
        else if collectionView == vwCollect {
            let cell  = vwCollect.dequeueReusableCell(withReuseIdentifier: MenuCCell.identifier, for: indexPath) as! MenuCCell
            cell.vwBack.isHidden = false
            cell.lbl.text = groups[indexPath.row].groupName
            if groups[indexPath.row].selected == 0 {
                cell.vwBack.backgroundColor = UIColor.ColorDarkBlack
                cell.lbl.textColor          = UIColor.white
            }
            else{
                cell.vwBack.backgroundColor = UIColor.white
                cell.lbl.textColor          = UIColor.black
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftCCell.identifier, for: indexPath) as! SwiftCCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectSwift {
            
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "SwiftVC") as? SwiftVC
            vc?.responseModel = self.reelsModel
            vc?.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else if collectionView == vwCollect {
            groupItems.removeAll()
            for i in 0..<groups.count {
                groups[i].selected = 0
            }
            
            // Set the selected element to 1
            groups[indexPath.row].selected = 1
//            selectedMenuIndex = indexPath.row
//            self.selectedUniqueID = groups[indexPath.row].id
//            self.fetchGroupItems()
            self.fetchGroupItems(selectedId: groups[indexPath.row].id)
            
            // Reload the collection view to reflect the changes (optional)
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        return  collectionView != vwCollect ? CGSize(width: (collectionView.frame.size.width / 2) - 10, height: 300) : CGSize(width: 100, height: 40)
        
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
    func fetchVideosFromFirestore() {
    
        self.startAnimating()
        let userToken = UserDefault.token
        let collectionRef = db.collection("Videos&Swifts")
        
        collectionRef.getDocuments { (querySnapshot, error) in
            guard let document = querySnapshot?.documents else {
                print("no document")
                self.stopAnimating()
                return
            }
            self.responseModel = document.map  { (QueryDocumentSnapshot) -> ProfileVideosModel in
                
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
                
                return ProfileVideosModel(uid: uid, address: address, Zipcode: zipcode, city: city, Title: title, tagPersons: TagPersons, description: description, categories: categories, hashtages: hashtages, language: language, thumbnailUrl: thumbnailUrl, videoUrl: videoUrl, likes: likes, comments: comments, views: views, paidCollab: paidCollab, introVideos: introVideos)
            }
            self.stopAnimating()
            print(self.responseModel)
            self.isfirstTime = true
            self.reelsAndVideosCollectionMaking()
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
    func addFollowingPeoplesList(_ userID: String, tagUser: [UserTagModel]) {
        self.startAnimating()
        let db = Firestore.firestore()
        let tagUserDictionaries = tagUser.map { $0.toDictionary() }
        db.collection("Users").document(userID).updateData([
            "followings": tagUserDictionaries
        ]) { [self] err in
            if let err = err {
                self.stopAnimating()
                print("Error updating tagPersons: \(err)")
            } else {
                self.stopAnimating()
                print("tagPersons successfully updated in Firestore")
                self.dismiss(animated: true)
            }
        }
    }
    func addFollowersPeoplesList(_ userID: String, tagUser: [UserTagModel]) {
        self.startAnimating()
        let db = Firestore.firestore()
        let tagUserDictionaries = tagUser.map { $0.toDictionary() }
        db.collection("Users").document(userID).updateData([
            "followers": tagUserDictionaries
        ]) { [self] err in
            if let err = err {
                self.stopAnimating()
                print("Error updating tagPersons: \(err)")
            } else {
                self.stopAnimating()
                print("tagPersons successfully updated in Firestore")
                self.dismiss(animated: true)
            }
        }
    }
    
    func getMenuGroup(id: String) {
        self.groups.removeAll()
        let db = Firestore.firestore()
        self.startAnimating()
        
        db.collection("groupsNames").document(id).getDocument { (document, error) in
            self.stopAnimating()
            if let error = error {
                print("Error retrieving document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                let groupsData = data?["groups"] as? [[String: Any]] ?? []
                
                for groupData in groupsData {
                    let uniqueID = groupData["uniqueID"] as? String ?? ""
                    let groupName = groupData["groupName"] as? String ?? ""
                    self.groups.append(GroupsModel(id: uniqueID, groupName: groupName, selected: 0))
                }
                self.vwCollect.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func fetchGroupItems(selectedId: String) {
        self.startAnimating()
        let db = Firestore.firestore()
        
        let collectionPath = "group_Items/\(selectedId)/Items"
        db.collection(collectionPath).getDocuments { (querySnapshot, error) in
            self.stopAnimating()
            
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                // If documents exist, process them
                for document in documents {
                    let data = document.data()
                    let id           = data["uniqueID"] as? String ?? ""
                    let title        = data["title"] as? String ?? ""
                    let img          = data["img"] as? String ?? ""
                    let description  = data["description"] as? String ?? ""
                    let price        = data["price"] as? String ?? ""
                    let currency     = data["currency"] as? String ?? ""
                    let mostLiked    = data["mostLiked"] as? String ?? ""
                    
                    self.groupItems.append(GroupsItemModel(id: id, title: title, img: img, descrip: description, price: price, currency: currency, mostLiked: mostLiked))
                }
                self.tblMenu.reloadData()
            } else {
                // No documents exist in the collection
                print("No items found for this group.")
            }
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
//MARK: - call back delegate to be show another person profile {}
extension ProfileVC: TagPeopleDelegate {
    func selectedUser(data: TagUsers) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(identifier: "ProfileVC") as? ProfileVC
        vc?.nonProfileModel = data
        vc?.isNonOwner      = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
//MARK: - Protocol of AccountreportDelete
extension ProfileVC: AccountActionPopupDelegate {
    func action(call: String) {
        if call == "Report" {
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AccountReportVC") as! AccountReportVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "BlockUserPopUpVC") as! BlockUserPopUpVC
            vc.nonProfileModel = self.nonProfileModel
            vc.profileModel    = self.profileModel
            self.present(vc, animated: true)
        }
    }
    
}

