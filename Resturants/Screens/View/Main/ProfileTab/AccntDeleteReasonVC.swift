//
//  AccntDeleteReasonVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class AccntDeleteReasonVC: UIViewController {
    
    @IBOutlet weak var txtViewBio       : UITextView!
    @IBOutlet weak var txtReason        : UITextField!
    
    
    let placeholder                        = "Enter Issue..."
    let placeholderColor                   = UIColor.lightGray
    var users: [UserTagModel]              = []
    var channelName                        = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapAccnt(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtReason.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.arrReason {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    @IBAction func ontapDelete(_ sender: UIButton) {
        if txtReason.text == "" {
            self.showToast(message: "Kindly select a reason from the provided options.", seconds: 2, clr: .red)
        }
        else if txtViewBio.text != "" || txtViewBio.text != "Enter Issue..." {
            AccntDelete()
        }
        else{
            self.showToast(message: "Please describe your issue in detail.", seconds: 2, clr: .red)
        }
    }
    
}

//MARK: - Setup Profile {}
extension AccntDeleteReasonVC {
   
    func onload() {
        removeNavBackbuttonTitle()
        txtViewBio.delegate   = self
        setupPlaceholder()
    }
    
    func setupPlaceholder() {
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
    
    func onAppear() {
        self.navigationItem.title = "Delete my account"
    }
}

// MARK: - UITextViewDelegate {}
extension AccntDeleteReasonVC : UITextViewDelegate{
    
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
}

//MARK: - Firebase reason calling {}
extension AccntDeleteReasonVC {
    
    func AccntDelete() {
        self.startAnimating()
        var db = Firestore.firestore()
        let data: [String: Any] = [
            "reasonType": txtReason.text!,
            "reasonDescription": txtViewBio.text!
        ]

        db.collection("Reason").addDocument(data: data) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                self?.stopAnimating()
                self?.showToast(message: "Error adding document: \(error.localizedDescription)", seconds: 2, clr: .red)
            } else {
              //  self?.showToast(message: "Document added successfully.", seconds: 2, clr: .gray)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.getAllUsers()
                }
            }
        }

    }
    
    //Get User and Channel As name
    func getAllUsers() {
        self.startAnimating()
        let db = Firestore.firestore()
        db.collection("userCollection").getDocuments { (querySnapshot, error) in
            if let error = error {
                self.stopAnimating()
                self.showToast(message: "Error getting documents: \(error.localizedDescription)", seconds: 2, clr: .red)
                print("Error getting documents: \(error.localizedDescription)")
                // Handle the error (e.g., show an alert to the user)
            } else {
                self.stopAnimating()
                self.users.removeAll() // Clear any existing users
                // Iterate over the documents in the snapshot
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let uid = data["uid"] as? String ?? ""
                    let img = data["img"] as? String ?? ""
                    let channelName = data["channelName"] as? String ?? ""
                    let followers = data["followers"] as? String ?? ""
                    let accountType = data["accountType"] as? String ?? ""

                    if channelName == self.channelName {
                        // Remove the document if channelName matches
                        db.collection("userCollection").document(document.documentID).delete { error in
                            if let error = error {
                                print("Error removing document: \(error)")
                            } else {
                                print("Document successfully removed!")
                                self.deleteUserAccount()
                            }
                        }
                    } else {
//                        let user = UserTagModel(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType, selected: 0)
//                        self.users.append(user)
//                        print(user)
                    }
                }
            }
        }
    }
    
    func deleteUserAccount() {
           Auth.auth().currentUser?.delete { [weak self] error in
               guard let strongSelf = self else { return }
               if let error = error {
                   self?.stopAnimating()
                   self?.showToast(message: "Account deletion failed: \(error.localizedDescription)", seconds: 2, clr: .red)
               } else {
                   self?.stopAnimating()
                   self?.showToast(message: "Account deleted successfully.", seconds: 2, clr: .gray)
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                       UserDefault.isAuthenticated = false
                       UserDefault.token           = ""
                       self?.popRoot()
                       self?.tabBarController?.selectedIndex = 0
//                       if let loginVC = Constants.authStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
//                           let navController = UINavigationController(rootViewController: loginVC)
//                           navController.modalPresentationStyle = .overFullScreen
//                           self?.navigationController?.present(navController, animated: true) {
//                               if let createAccountVC = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CreatAccntVC") as? CreatAccntVC {
//                                   navController.pushViewController(createAccountVC, animated: true)
//                               }
//                           }
//                       }
                   }
               }
           }
       }
}
