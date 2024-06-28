//
//  AddBioVC.swift
//  Resturants
//
//  Created by Coder Crew on 23/06/2024.
//

import UIKit
import FirebaseFirestoreInternal

class AddBioVC: UIViewController {

    @IBOutlet weak var txtViewBio       : UITextView!
    
    let placeholder                        = "Enter Bio..."
    let placeholderColor                   = UIColor.lightGray
    var profileModel    : UserProfileModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapSave(_ sender: UIButton) {
        addBio(UserDefault.token)
    }
}

//MARK: - Custom Implementation {}
extension AddBioVC{
   
    func onLaod() {
        txtViewBio.delegate   = self
        setupPlaceholder()
        self.navigationItem.title = "Add Bio"
        removeNavBackbuttonTitle()
    }
    
    func setupPlaceholder() {
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
    
    func onAppear() {
    }
    
}

// MARK: - UITextViewDelegate {}
extension AddBioVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text      = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }
    
    func updateCoverUrlInModel(bio: String) {
        if var model = self.profileModel {
            model.coverUrl = bio
            self.profileModel = model
        }
    }

}

//MARK: - Save Bio in Profile {}
extension AddBioVC {
    
    func addBio(_ userID: String) {
        
        let db = Firestore.firestore()
        db.collection("Users").document(userID).updateData([
            "bio": txtViewBio.text!
        ]) { err in
            if let err = err {
                print("Error updating coverUrl: \(err)")
            } else {
                print("Cover URL successfully updated in Firestore")
                self.updateCoverUrlInModel(bio: self.txtViewBio.text!)
            }
        }
    }
}
