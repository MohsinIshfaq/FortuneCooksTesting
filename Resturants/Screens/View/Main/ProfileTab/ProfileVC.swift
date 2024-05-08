//
//  ProfileVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit


class ProfileVC: UIViewController {
    
    //MARK: - IBOUtlet
    @IBOutlet weak var vwVideo         : UIView!
    @IBOutlet weak var vwSwift         : UIView!
    @IBOutlet weak var vwCollection    : UIView!
    @IBOutlet weak var vwMenu          : UIView!
    
    @IBOutlet weak var tblVideoHeightCons : NSLayoutConstraint!
    @IBOutlet weak var tblVIdeos       : UITableView!
    @IBOutlet weak var stackVideos     : UIStackView!
    
    @IBOutlet weak var collectSwiftHeightCons : NSLayoutConstraint!
    @IBOutlet weak var collectSwift    : UICollectionView!
    @IBOutlet weak var stackSwift      : UIStackView!
    @IBOutlet weak var stackCollection : UIStackView!
    
    @IBOutlet weak var collectSwiftColl: UICollectionView!
    @IBOutlet weak var tblVIdeosColl   : UITableView!
    @IBOutlet weak var tblVideosCollHeightCons : NSLayoutConstraint!
    
    @IBOutlet weak var stackMore       : UIStackView!
    @IBOutlet weak var tblMenu         : UITableView!
    @IBOutlet weak var stackMenu       : UIStackView!
    @IBOutlet weak var tblMenuHeightCons : NSLayoutConstraint!
    
    
    //MARK: - Variables and Properties
    var arr: [String]   = ["" , "" , ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapSetting(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
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
}

//MARK: - TableVew {}
extension ProfileVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblVIdeos {
            if arr.count == 0 {
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
            if arr.count == 0 {
                return 1
            }
            else{
                tblVideoHeightCons.constant = CGFloat(300 + (arr.count * 105))
                return arr.count
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
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblVIdeos {
            if arr.count != 0 {
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
            if arr.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoPostTCell.identifier, for: indexPath) as! NoPostTCell
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: VideoTCell.identifier, for: indexPath) as! VideoTCell
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
    
}


//MARK: - collection view {}
extension ProfileVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectSwift {
            collectSwiftHeightCons.constant = 250 * 3
            return 6
        }
        else{
           return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectSwift {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftCCell.identifier, for: indexPath) as! SwiftCCell
            // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoPostCCell.identifier, for: indexPath) as! NoPostCCell
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftCCell.identifier, for: indexPath) as! SwiftCCell
            // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoPostCCell.identifier, for: indexPath) as! NoPostCCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
    
}
