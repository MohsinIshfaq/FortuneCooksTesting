//
//  ProfileVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit
import FirebaseFirestoreInternal
import AVFoundation


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
    @IBOutlet weak var imgProfile              : UIImageView!
    @IBOutlet weak var imgBig                  : UIImageView!
    
    
    //MARK: - Variables and Properties
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ontappFollowers(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
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
        }
        else{
            stackMore.isHidden = true
        }
    }
}

//MARK: - Setup Profile {}
extension ProfileVC {
   
    func onload() {
        setupView()
        fetchDataFromFirestore()
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
        return playerLayer
        //self.view.layer.addSublayer(playerLayer)
       // player.play()
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
                tblVideoHeightCons.constant = CGFloat(300 + ((responseModel?.count ?? 0) * 105))
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
            headerView.lblViews.text = "3/10/2002 / 200 views"
            player.pause()
            
        }
        return headerView
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
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblVIdeos {
            if self.selectedVideo?.videoUrl ?? "" != "" {
                return 300
            }
            else{
                return 0
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
            if (responseModel?.count ?? 0) == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoPostTCell.identifier, for: indexPath) as! NoPostTCell
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: VideoTCell.identifier, for: indexPath) as! VideoTCell
                cell.lblDEscrip.text = responseModel?[indexPath.row].description ?? ""
                cell.lblName.text    = responseModel?[indexPath.row].Title ?? ""
                cell.lblDateViews.text    = "3/10/2002 / 200 views"
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
        return 100
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
        return CGSize(width: 170, height: 250)
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
        }
        else {
            imgBig.image     = currentImage
        }
    }
}

//MARK: - Get Videos {}
extension ProfileVC {
    
    func fetchDataFromFirestore() {
    
        self.startAnimating()
        let userToken = UserDefaults.standard.string(forKey: "token") ?? "defaultToken1"
        let videosCollectionRef = db.collection("Videos").document(userToken).collection("VideosData")
        
        videosCollectionRef.addSnapshotListener { querysnap, error in
            self.stopAnimating()
            guard let document = querysnap?.documents else {
                print("no document")
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
            print(self.responseModel)
            self.collectSwift.reloadData()
            self.tblVIdeos.reloadData()
        }
    }
}

