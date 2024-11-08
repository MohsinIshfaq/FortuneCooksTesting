//
//  BlockedAccntVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/06/2024.
//

import UIKit
import FirebaseFirestoreInternal

class BlockedAccntVC: UIViewController {

    @IBOutlet weak var tblSelection: UITableView!
    
    var showTagUsers: Bool                = false
    var profileModel: UserProfileModel?   = nil
    var selectedBlockUsers: [TagUsers]    = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    
    @IBAction func ontapUnblock(_ sender: UIButton) {
        for i in 0 ..< (profileModel?.blockUsers?.count ?? 0) {
            if profileModel?.blockUsers?[i].selected == 0 {
                if var data = profileModel?.blockUsers?[i]{
                    self.selectedBlockUsers.append(data)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.addBlockPeopleList(UserDefault.token, tagUser: self.selectedBlockUsers)
        }
    }

}

//MARK: - Custom Implementation {}
extension BlockedAccntVC{
   
    func onLaod() {
        setupView()
        self.navigationItem.title = "Block Accounts"
        removeNavBackbuttonTitle()
    }
    
    func setupView(){
        tblSelection.register(TagUserTCell.nib, forCellReuseIdentifier: TagUserTCell.identifier)
        tblSelection.delegate   = self
        tblSelection.dataSource = self
    }
}

//MARK: - TableView {}
extension BlockedAccntVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileModel?.blockUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagUserTCell.identifier) as? TagUserTCell
        cell?.btnMore.isHidden         = true
        if showTagUsers {
            cell?.btnFollow.isHidden   = false
            cell?.imgSelected.isHidden = true
        }
        else {
            cell?.btnFollow.isHidden   = true
            DispatchQueue.main.async {
                if let profileURL = self.profileModel?.blockUsers?[indexPath.row].img, let urlProfile1 = URL(string: profileURL) {
                        cell?.img.sd_setImage(with: urlProfile1)
                    }
                cell?.lblFollowers.text = self.profileModel?.blockUsers?[indexPath.row].followers ?? "0 Followers"
                cell?.lblName.text      = self.profileModel?.blockUsers?[indexPath.row].channelName ?? ""
                cell?.lblType.text      = self.profileModel?.blockUsers?[indexPath.row].accountType ?? ""
            }
            if self.profileModel?.blockUsers?[indexPath.row].selected == 1 {
                cell?.imgSelected.image = UIImage(systemName: "circle.fill")
            }
            else {
                cell?.imgSelected.image = UIImage(systemName: "circle")
            }
            
        }
        return cell!
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.profileModel?.blockUsers?[indexPath.row].selected == 0 {
            self.profileModel?.blockUsers?[indexPath.row].selected = 1
        }
        else {
            self.profileModel?.blockUsers?[indexPath.row].selected = 0
        }
        tblSelection.reloadData()
    }
    
}

extension BlockedAccntVC {
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
                popRoot()
            }
        }
    }
}
