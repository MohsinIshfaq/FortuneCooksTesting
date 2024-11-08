//
//  BlockUserPopUpVC.swift
//  Resturants
//
//  Created by Coder Crew on 13/05/2024.
//

import UIKit
import FirebaseFirestoreInternal

class BlockUserPopUpVC: UIViewController {

    var nonProfileModel : TagUsers?         = nil
    var profileModel    : UserProfileModel? = nil
    var newModel        : [UserTagModel]?   = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ontapCancel(_ snder: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapOK(_ sender: UIButton) {
        print(profileModel?.blockUsers ?? [])
        var data = profileModel?.blockUsers ?? []
        data.append(nonProfileModel!)
        print(nonProfileModel!)
        addBlockPeopleList(UserDefault.token, tagUser: data)
    }

}

extension BlockUserPopUpVC {
    func addBlockPeopleList(_ userID: String, tagUser: [TagUsers]) {
        self.startAnimating()
        let db = Firestore.firestore()
        let tagUserDictionaries = tagUser.map { $0.toDictionary() }
        db.collection("Users").document(userID).updateData([
            "blockUsers": tagUserDictionaries
        ]) { [self] err in
            if let err = err {
                self.stopAnimating()
                print("Error updating tagPersons: \(err)")
            } else {
                self.stopAnimating()
                print("tagPersons successfully updated in Firestore")
               // self.dismiss(animated: true)
                print( profileModel?.tagPersons?.count)
                print(UserManager.shared.ownerTagPeoples.count)
                if UserManager.shared.ownerTagPeoples.count != 0 {
                    for i in 0 ..< (UserManager.shared.ownerTagPeoples.count) {
                        if UserManager.shared.ownerTagPeoples[i].uid == nonProfileModel?.uid {
                            UserManager.shared.ownerTagPeoples.remove(at: i)
                            print( UserManager.shared.ownerTagPeoples.count)
                            addTagPeoplesList(UserDefault.token, tagUser: UserManager.shared.ownerTagPeoples)
                        }
                    }
                }
                else{
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func addTagPeoplesList(_ userID: String, tagUser: [TagUsers]) {
        self.startAnimating()
        let db = Firestore.firestore()
        let tagUserDictionaries = tagUser.map { $0.toDictionary() }
        db.collection("Users").document(userID).updateData([
            "tagPersons": tagUserDictionaries
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
}
