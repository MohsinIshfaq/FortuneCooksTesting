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

class CreateCollectionPopupVC: UIViewController {

    
    @IBOutlet weak var vwAll              : UIView!
    @IBOutlet weak var vwMyFollowers      : UIView!
    @IBOutlet weak var vwOnlyMe           : UIView!
           
    @IBOutlet weak var lblAll             : UILabel!
    @IBOutlet weak var lblMyFollowers     : UILabel!
    @IBOutlet weak var lblOnlyMe          : UILabel!
    @IBOutlet weak var lblTop             : UILabel!
    
    @IBOutlet weak var txtTitle           : UITextField!
    
    var visibility                       = "All"
    var delegate                         : CollectionCreationDelegate? = nil
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
            addCollection()
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
        }
        else{
            lblTop.text    = "Create Collection"
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
        
        let collectionPath = "Collections/WYCwmlT06AdWW8K56833NT0e9E12/UserCollections"
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
    
    func updateCollection(withId id: String, updatedData: [String: Any]) {
        let collectionPath = "Collections/WYCwmlT06AdWW8K56833NT0e9E12/UserCollections"
        let documentRef = db.collection(collectionPath).document(id)
        
        documentRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated")
            }
        }
    }

}
