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
    @IBOutlet weak var vwAll              : UIView!
    @IBOutlet weak var vwVidos            : UIView!
    @IBOutlet weak var vwSwift            : UIView!
    @IBOutlet weak var lblAll             : UILabel!
    @IBOutlet weak var lblVidos           : UILabel!
    @IBOutlet weak var lblSwift           : UILabel!
    @IBOutlet weak var stackTypeCollect   : UIStackView!
    
    var selectedIndex                     = -1
    let db                                = Firestore.firestore()
    var collections                       : [CollectionModel?]   = []
    
    
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
        }
        else if sender.tag == 1 {
            vwAll.backgroundColor   = .black
            vwVidos.backgroundColor = .white
            vwSwift.backgroundColor = .black
            
            lblAll.textColor        = .white
            lblVidos.textColor      = .black
            lblSwift.textColor      = .white
        }
        else{
            vwAll.backgroundColor   = .black
            vwVidos.backgroundColor = .black
            vwSwift.backgroundColor = .white
            
            lblAll.textColor        = .white
            lblVidos.textColor      = .white
            lblSwift.textColor      = .black
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
    }
    
    func setupCell() {
        vwCOllections.register(CollectionsCCell.nib, forCellWithReuseIdentifier: CollectionsCCell.identifier)
        vwCOllections.delegate   = self
        vwCOllections.dataSource = self
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
extension MyCollectionVC: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for i in 0 ..< self.collections.count {
            self.collections[i]?.selected = 0
        }
        self.selectedIndex        = indexPath.row
        self.collections[indexPath.row]?.selected = 1
        collectionView.reloadData()
    }
    
    
}

//MARK: - Firebase call for collection {}
extension MyCollectionVC {
    
    func getCollection() {
        collections.removeAll()
        self.startAnimating()
        let collectionPath = "Collections/WYCwmlT06AdWW8K56833NT0e9E12/UserCollections"
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
            self.vwCOllections.reloadData()
        }
    }
    
    func deleteCollection(withId id: String) {
        let collectionPath = "Collections/WYCwmlT06AdWW8K56833NT0e9E12/UserCollections"
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
