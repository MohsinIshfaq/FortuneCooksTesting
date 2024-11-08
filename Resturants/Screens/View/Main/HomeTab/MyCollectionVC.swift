//
//  MyCollectionVC.swift
//  Resturants
//
//  Created by Coder Crew on 29/08/2024.
//

import UIKit
import FirebaseFirestoreInternal

class MyCollectionVC: UIViewController , CollectionActionsDelegate, ConfirmationAutionsDelegate, CollectionCreationDelegate, CollectionUpdateDelegate {
    
    func reloadForUpdateCollection() {
        self.dismiss(animated: true)
        getCollection()
    }
    func reloadCollection(model: CollectionModel) {
        self.collections.append(model)
        vwCOllections.reloadData()
    }
    func willDelete(_ condition: Bool) {
        if condition {
            self.dismiss(animated: true)
            deleteCollection(withId: collections[selectedIndex]?.id ?? "")
            collections.remove(at: selectedIndex)
            vwCOllections.reloadData()
        }
        else{
            self.dismiss(animated: true)
        }
    }
    func collectionAction(_ type: String) {
        if type == "Edit" {
            self.dismiss(animated: true)
            let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CreateCollectionPopupVC") as? CreateCollectionPopupVC
            vc?.selected_in    = self.selectedIndex
            vc?.delegateUpdate = self
            vc?.selected_Model = collections[selectedIndex]
            self.present(vc!, animated: true)
        }
        else{
            self.dismiss(animated: true)
            let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "ConfirmationActionVC") as? ConfirmationActionVC
            vc?.delegate = self
            self.present(vc!, animated: true)
        }
    }
    
    
    //MARK: - IBOUtlets
    @IBOutlet weak var stackAddCollection : UIStackView!
    @IBOutlet weak var vwCOllections      : UICollectionView!
    @IBOutlet weak var vwSwiftCollect     : UICollectionView!
    @IBOutlet weak var vwVideosCollect    : UITableView!
    @IBOutlet weak var vwAll              : UIView!
    @IBOutlet weak var vwVidos            : UIView!
    @IBOutlet weak var vwSwift            : UIView!
    @IBOutlet weak var lblAll             : UILabel!
    @IBOutlet weak var lblVidos           : UILabel!
    @IBOutlet weak var lblSwift           : UILabel!
    @IBOutlet weak var stackTypeCollect   : UIStackView!
    @IBOutlet weak var tblVideoHeightCons : NSLayoutConstraint!
    @IBOutlet weak var collectSwiftHeightCons: NSLayoutConstraint!
    @IBOutlet weak var scrollCollection   : UIScrollView!
    
    var selectedIndex                     = -1
    let db                                = Firestore.firestore()
    var collections                       : [CollectionModel?]    = []
    var collectionReelsModel              : [ProfileVideosModel]? = []
    let itemsPerColumn  : Int = 2
    let itemHeight      : CGFloat = 250.0 // Example item height
    
    
    //MARK: - Variables and Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    @IBAction func ontapAddCollection(_ : UIButton) {
        
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CreateCollectionPopupVC") as? CreateCollectionPopupVC
        vc?.delegate = self
        self.present(vc!, animated: true)
    }
    @objc func ontapMore(_ : UIButton) {
        
        if selectedIndex != -1 {
            let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CollectionsActionPopupVC") as? CollectionsActionPopupVC
            vc?.delegate = self
            self.present(vc!, animated: true)
        }
    }
    @objc func ontapAdd(_ : UIButton) {
        
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CreateCollectionPopupVC") as? CreateCollectionPopupVC
        vc?.delegate = self
        self.present(vc!, animated: true)
        //        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "AddOrRemoveCollectVC") as? AddOrRemoveCollectVC
        //        self.present(vc!, animated: true)
    }
    @IBAction func ontapTypeCollection(_ sender: UIButton) {
        
        if sender.tag == 0 {
            vwAll.backgroundColor   = .white
            vwVidos.backgroundColor = .black
            vwSwift.backgroundColor = .black
            
            lblAll.textColor        = .black
            lblVidos.textColor      = .white
            lblSwift.textColor      = .white
            vwSwiftCollect.isHidden  = false
            vwVideosCollect.isHidden = false
            if let layout = vwSwiftCollect.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
             
            }
            collectSwiftHeightCons.constant = CGFloat(250)
        }
        else if sender.tag == 1 {
            vwAll.backgroundColor   = .black
            vwVidos.backgroundColor = .white
            vwSwift.backgroundColor = .black
            
            lblAll.textColor        = .white
            lblVidos.textColor      = .black
            lblSwift.textColor      = .white
            vwSwiftCollect.isHidden  = true
            vwVideosCollect.isHidden = false
        }
        else{
            vwAll.backgroundColor   = .black
            vwVidos.backgroundColor = .black
            vwSwift.backgroundColor = .white
            
            lblAll.textColor        = .white
            lblVidos.textColor      = .white
            lblSwift.textColor      = .black
            vwSwiftCollect.isHidden  = false
            vwVideosCollect.isHidden = true
            if let layout = vwSwiftCollect.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
              
            }
            updateCollectionViewHeight()
            
        }
    }
    
}

//MARK: - Setup Profile {}
extension MyCollectionVC {
    
    func onload() {
        getCollection()
    }
    
    func onAppear() {
        self.navigationItem.title  = "My Collections"
        removeNavBackbuttonTitle()
        NavigationRightBtn()
        setupCell()
        
        vwAll.backgroundColor   = .white
        vwVidos.backgroundColor = .black
        vwSwift.backgroundColor = .black

        lblAll.textColor        = .black
        lblVidos.textColor      = .white
        lblSwift.textColor      = .white
        
        if collections.count == 0 {
            scrollCollection.isHidden   = true
            stackAddCollection.isHidden = false
        }
        else{
            scrollCollection.isHidden   = false
            stackAddCollection.isHidden = true
        }
        getCollection()
    }
    
    func updateCollectionViewHeight() {
        let numberOfItems = UserManager.shared.reelsModel?.count ?? 0
        let numberOfRows = ceil(Double(numberOfItems) / Double(itemsPerColumn))
        let newHeight = numberOfRows * Double(itemHeight)
        collectSwiftHeightCons.constant = CGFloat(newHeight)
    }
    
    func setupCell() {
        vwCOllections.register(CollectionsCCell.nib, forCellWithReuseIdentifier: CollectionsCCell.identifier)
        vwCOllections.delegate    = self
        vwCOllections.dataSource  = self
        
        vwVideosCollect.register(VideoTCell.nib, forCellReuseIdentifier: VideoTCell.identifier)
        vwVideosCollect.delegate   = self
        vwVideosCollect.dataSource = self
        
        vwSwiftCollect.register(SwiftCCell.nib, forCellWithReuseIdentifier: SwiftCCell.identifier)
        vwSwiftCollect.delegate   = self
        vwSwiftCollect.dataSource = self
    }
    
    func NavigationRightBtn() {
        
        let moreImg = UIImage(named: "More")?.withRenderingMode(.automatic)
        var moreBtn = UIBarButtonItem(image: moreImg, style: .plain, target: self, action: #selector(ontapMore))
        
        let editImg = UIImage(systemName: "plus")?.withRenderingMode(.automatic)
        var editBtn = UIBarButtonItem(image: editImg, style: .plain, target: self, action: #selector(ontapAdd))
        navigationItem.rightBarButtonItems = [moreBtn , editBtn]
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}

//MARK: - Setup Collection {}
extension MyCollectionVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  collectionView == vwCOllections {
            return collections.count
        }
        else {
            return collectionReelsModel?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == vwCOllections {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionsCCell.identifier, for: indexPath) as? CollectionsCCell
            cell?.lblTitle.text = collections[indexPath.row]?.collectionName ?? ""
            if collections[indexPath.row]?.selected ?? 0 == 1 {
                cell?.vwBack.borderWidth  = 1
                cell?.vwBack.borderColor  = .ColorDarkBlue
                cell?.lblTitle.textColor  = .ColorDarkBlue
                cell?.imgCollection.image = UIImage(named: "SelectedCollection")
            }
            else{
                cell?.vwBack.borderWidth  = 0
                cell?.lblTitle.textColor  = .white
                cell?.imgCollection.image = UIImage(named: "SavedCollection")
            }
            return cell!
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftCCell.identifier, for: indexPath) as! SwiftCCell
            //cell.lblDescrip.text = reelsModel?[indexPath.row].description ?? ""
            cell.lblName.text    = collectionReelsModel?[indexPath.row].Title ?? ""
            DispatchQueue.main.async {
                guard let url = self.collectionReelsModel?[indexPath.row].thumbnailUrl else {
                    return
                }
                let url1 = URL(string: url)!
                cell.imgMain?.sd_setImage(with: url1)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionReelsModel?.removeAll()
        if collectionView == vwCOllections {
            for i in 0 ..< self.collections.count {
                self.collections[i]?.selected = 0
            }
            self.selectedIndex        = indexPath.row
            self.collections[indexPath.row]?.selected = 1
            collectionView.reloadData()
            
            if let reelsModel = UserManager.shared.reelsModel, !reelsModel.isEmpty {
                // Get the collection for the specific indexPath.row
                let collection = collections[indexPath.row]
                
                // Loop over all swiftIds in the collection at indexPath.row
                for arr in 0 ..< (collection?.swiftIds.count ?? 0) {
                    let swiftId = collection?.swiftIds[arr]
                    let reelsUid = reelsModel[arr].uid
                    
                    // Compare swiftId with reelsUid
                    if swiftId == reelsUid {
                        // Append the corresponding reelsModel element if a match is found
                        self.collectionReelsModel?.append(reelsModel[arr])
                    }
                }
            }



            vwSwiftCollect.reloadData()
            scrollCollection.isHidden   = false
            stackAddCollection.isHidden = true
        }
        else{
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == vwCOllections {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionsCCell.identifier, for: indexPath) as! CollectionsCCell
            if let users = collections[indexPath.row]{
                cell.lblTitle.text = users.collectionName
            }
            let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)
            let fittingSize = cell.contentView.systemLayoutSizeFitting(targetSize,
                                                                           withHorizontalFittingPriority: .fittingSizeLevel,
                                                                           verticalFittingPriority: .required)
            return CGSize(width: 120, height: 40)
        }
        else{
            return CGSize(width: (vwSwiftCollect.frame.size.width / 2) - 10, height: 300)
        }
    }
    
    
}

//MARK: - Setup TableView {}
extension MyCollectionVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tblVideoHeightCons.constant = CGFloat(300 + ((UserManager.shared.videosModel?.count ?? 0) * 140))
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTCell.identifier, for: indexPath) as! VideoTCell
        cell.lblDEscrip.text = UserManager.shared.videosModel?[indexPath.row].description ?? ""
        cell.lblName.text    = UserManager.shared.videosModel?[indexPath.row].Title ?? ""
        cell.lblDateViews.text    = "3 October 2002 / 200 views"
        DispatchQueue.main.async {
            guard let url = UserManager.shared.videosModel?[indexPath.row].thumbnailUrl else {
                return
            }
            let url1 = URL(string: url)!
            cell.imgVideo?.sd_setImage(with: url1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

//MARK: - Firebase call for collection {}
extension MyCollectionVC {
    
    func getCollection() {
        collections.removeAll()
        self.startAnimating()
        let collectionPath = "Collections/\(UserDefault.token)/UserCollections"
        db.collection(collectionPath).getDocuments { (querySnapshot, error) in
            self.stopAnimating() // Ensure animation stops whether there's an error or not
            
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
                let id                    = data["id"] as? String ?? ""
                let collectionName        = data["collectionName"] as? String ?? ""
                let swiftIds              = data["swiftIds"] as? [String] ?? []
                let videosIds             = data["videosIds"] as? [String] ?? []
                let visibility            = data["visibility"] as? String ?? ""
                self.collections.append(CollectionModel(collectionName: collectionName, id: id, swiftIds: swiftIds, videosIds: videosIds, visibility: visibility, selected: 0))
            }
            print(self.collections)
            if self.collections.count != 0 {
                self.stackAddCollection.isHidden = true
            }
            else{
                self.stackAddCollection.isHidden = false
            }
            self.vwCOllections.reloadData()
            self.vwSwiftCollect.reloadData()
        }
    }
    
    func deleteCollection(withId id: String) {
        let collectionPath = "Collections/\(UserDefault.token)/UserCollections"
        let documentRef = db.collection(collectionPath).document(id)
        
        documentRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document successfully deleted")
            }
        }
    }
}
