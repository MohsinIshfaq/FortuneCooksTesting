//
//  CreateCollectionPopupVC.swift
//  Resturants
//
//  Created by Coder Crew on 29/08/2024.
//

import UIKit
import FirebaseFirestoreInternal

protocol CollectionCreationDelegate {
    
    func reloadCollection(model: CollectionModel)
}

protocol CollectionUpdateDelegate {
    
    func reloadForUpdateCollection()
}


class CreateCollectionPopupVC: UIViewController {

    
    @IBOutlet weak var vwAll              : UIView!
    @IBOutlet weak var vwMyFollowers      : UIView!
    @IBOutlet weak var vwOnlyMe           : UIView!
           
    @IBOutlet weak var lblAll             : UILabel!
    @IBOutlet weak var lblMyFollowers     : UILabel!
    @IBOutlet weak var lblOnlyMe          : UILabel!
    @IBOutlet weak var lblTop             : UILabel!
    @IBOutlet weak var btnCreate          : UIButton!
    
    @IBOutlet weak var txtTitle           : UITextField!
    
    var visibility                       = "All"
    var delegate                         : CollectionCreationDelegate? = nil
    var delegateUpdate                   : CollectionUpdateDelegate?   = nil
    var selected_in                      : Int   = -1
    var selected_Model                   : CollectionModel? = nil
    let db                               = Firestore.firestore()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapDismiss(_ : UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func ontapTypeCollection(_ sender: UIButton) {
      
        if sender.tag == 0 {
            vwAll.backgroundColor         = .white
            vwMyFollowers.backgroundColor = .black
            vwOnlyMe.backgroundColor      = .black
            
            lblAll.textColor              = .black
            lblMyFollowers.textColor      = .white
            lblOnlyMe.textColor           = .white
            visibility                    = "All"
        }
        else if sender.tag == 1 {
            vwAll.backgroundColor         = .black
            vwMyFollowers.backgroundColor = .white
            vwOnlyMe.backgroundColor      = .black
            
            lblAll.textColor              = .white
            lblMyFollowers.textColor      = .black
            lblOnlyMe.textColor           = .white
            visibility                    = "My Followers"
        }
        else{
            vwAll.backgroundColor         = .black
            vwMyFollowers.backgroundColor = .black
            vwOnlyMe.backgroundColor      = .white
                        
            lblAll.textColor              = .white
            lblMyFollowers.textColor      = .white
            lblOnlyMe.textColor           = .black
            visibility                    = "Only me"
        }
    }
    
    @IBAction func ontapCrtCollection(_ sender: UIButton) {
        
        if txtTitle.text != "" {
            if sender.currentTitle == "Create Collection" {
                addCollection()
            }
            else{
                var model = CollectionModel(collectionName: txtTitle.text!, id: selected_Model?.id ?? "", swiftIds: [], videosIds: [], visibility: visibility, selected: 0)
                updateCollection(for: model)
            }
        }
        else{
            self.showToast(message: "Please add group name", seconds: 2, clr: .red)
        }
    }

}

//MARK: - Setup Profile {}
extension CreateCollectionPopupVC {
    
    func onLoad() {
        
        if selected_Model != nil {
            txtTitle.text = selected_Model?.collectionName ?? ""
            if selected_Model?.visibility == "All" {
                vwAll.backgroundColor         = .white
                vwMyFollowers.backgroundColor = .black
                vwOnlyMe.backgroundColor      = .black
                
                lblAll.textColor              = .black
                lblMyFollowers.textColor      = .white
                lblOnlyMe.textColor           = .white
                visibility                    = "All"
            }
            else  if selected_Model?.visibility == "My Followers" {
                vwAll.backgroundColor         = .black
                vwMyFollowers.backgroundColor = .white
                vwOnlyMe.backgroundColor      = .black
                
                lblAll.textColor              = .white
                lblMyFollowers.textColor      = .black
                lblOnlyMe.textColor           = .white
                visibility                    = "My Followers"
            }
            else{
                vwAll.backgroundColor         = .black
                vwMyFollowers.backgroundColor = .black
                vwOnlyMe.backgroundColor      = .white
                
                lblAll.textColor              = .white
                lblMyFollowers.textColor      = .white
                lblOnlyMe.textColor           = .black
                visibility                    = "Only me"
            }
            lblTop.text    = "Update Collection"
            btnCreate.setTitle("Update Collection", for: .normal)
        }
        else{
            lblTop.text    = "Create Collection"
            btnCreate.setTitle("Create Collection", for: .normal)
        }
    }
    
    func onAppear() {
        vwAll.backgroundColor         = .white
        vwMyFollowers.backgroundColor = .black
        vwOnlyMe.backgroundColor      = .black
        
        lblAll.textColor              = .black
        lblMyFollowers.textColor      = .white
        lblOnlyMe.textColor           = .white
    }
}

extension CreateCollectionPopupVC {
    
    func addCollection() {
        self.startAnimating()
        let uniqueID = UUID().uuidString
        let collection = CollectionModel(collectionName: txtTitle.text!, id: uniqueID, swiftIds: [], videosIds: [], visibility: self.visibility, selected: 0)
        
        let collectionPath = "Collections/\(UserDefault.token)/UserCollections"
        db.collection(collectionPath).addDocument(data: collection.toDictionary()) { error in
            if let error = error {
                print("Error saving location: \(error.localizedDescription)")
            } else {
                self.stopAnimating()
                self.dismiss(animated: true)
                self.delegate?.reloadCollection(model: collection)
                
            }
        }
    }
    
    func updateCollection(for selectedModel: CollectionModel) {
        let collectionPath = "Collections/\(UserDefault.token)/UserCollections"
        
        db.collection(collectionPath).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No documents found.")
                return
            }
            
            // Iterate over the documents to find the one with the matching id
            for document in documents {
                let data = document.data()
                let id = data["id"] as? String ?? ""
                
                // Check if the document id matches the selected model's id
                if id == selectedModel.id {
                    // Update the document
                    let documentRef = document.reference
                    let updatedData = selectedModel.toDictionary()
                    
                    documentRef.updateData(updatedData) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Document successfully updated")
                            self.delegateUpdate?.reloadForUpdateCollection()
                        }
                    }
                }
            }
        }
    }



}
