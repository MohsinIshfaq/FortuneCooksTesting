//
//  AddOrRemoveCollectVC.swift
//  Resturants
//
//  Created by Coder Crew on 04/09/2024.
//

import UIKit
import FirebaseFirestoreInternal

class AddOrRemoveCollectVC: UIViewController {

    @IBOutlet weak var vwCOllections      : UICollectionView!
    
    
    let db                                = Firestore.firestore()
    var collections                       : [CollectionModel?]   = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onload()
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapSave(_ sender: UIButton) {
        
    }

}

//MARK: - Setup Profile {}
extension AddOrRemoveCollectVC {
    
    func onload() {
        getCollection()
        setupCell()
    }
    
    func setupCell() {
        vwCOllections.register(CollectionsCCell.nib, forCellWithReuseIdentifier: CollectionsCCell.identifier)
        vwCOllections.delegate   = self
        vwCOllections.dataSource = self
    }
}


//MARK: - Setup Collection {}
extension AddOrRemoveCollectVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionsCCell.identifier, for: indexPath) as? CollectionsCCell
        cell?.lblTitle.text = collections[indexPath.row]?.collectionName ?? ""
        cell?.vwBack.borderWidth  = 0.3
        cell?.vwBack.borderColor  = .white
        cell?.lblTitle.textColor  = .white
//        if collections[indexPath.row]?.selected ?? 0 == 1 {
//            cell?.vwBack.borderWidth  = 1
//            cell?.vwBack.borderColor  = .gray
//            cell?.lblTitle.textColor  = .ColorDarkBlue
//            cell?.imgCollection.image = UIImage(named: "SelectedCollection")
//        }
//        else{
//            cell?.vwBack.borderWidth  = 0
//            cell?.lblTitle.textColor  = .white
//            cell?.imgCollection.image = UIImage(named: "SavedCollection")
//        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        for i in 0 ..< self.collections.count {
//            self.collections[i]?.selected = 0
//        }
//        self.selectedIndex        = indexPath.row
//        self.collections[indexPath.row]?.selected = 1
//        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
    
}


//MARK: - Firebase call for collection {}
extension AddOrRemoveCollectVC {
    
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
    
}
