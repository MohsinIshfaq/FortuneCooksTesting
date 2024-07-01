//
//  TagPeopleVC.swift
//  Resturants
//
//  Created by Coder Crew on 05/04/2024.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth
protocol TagPeopleDelegate {
    func reload(data: [UserTagModel?])
}

class TagPeopleVC: UIViewController , UISearchTextFieldDelegate{

    @IBOutlet weak var tblSelection: UITableView!
    @IBOutlet weak var txtSearch   : UITextField!
    @IBOutlet weak var btnSubmit   : UIButton!
    @IBOutlet weak var lblHeader   : UILabel!
    
    var delegate: TagPeopleDelegate? = nil
    var showTagUsers: Bool           = false
    var users: [UserTagModel?] = []
    var selectedUser: [UserTagModel] = []      //Users to be tag
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllUsers()
    }

    @IBAction func ontapDone(_ sender: UIButton){
        self.dismiss(animated: true)
        delegate?.reload(data: selectedUser)
    }
    
    @IBAction func ontapDismis(_ sender: UIButton){
        self.dismiss(animated: true)
    }
}

//MARK: - Custom Implementation {}
extension TagPeopleVC{
   
    func onLaod() {
        setupView()
        if showTagUsers{
            lblHeader.textAlignment = .left
            txtSearch.isHidden      = true
            lblHeader.text          = "People Taged"
        }
        else{
            lblHeader.textAlignment = .center
            txtSearch.isHidden      = false
            lblHeader.text          = "Tag Persons"
        }
    }
    
    func setupView(){
        
        tblSelection.register(TagUserTCell.nib, forCellReuseIdentifier: TagUserTCell.identifier)
        tblSelection.delegate   = self
        tblSelection.dataSource = self
    }
}

//MARK: - Search TextField {}
extension TagPeopleVC: UITextFieldDelegate {
    @objc func textFieldDidEndChange(_ textField: UITextField) {
        print(txtSearch.text!)
        tblSelection.reloadData()
    }
    
}

//MARK: - TableView {}
extension TagPeopleVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count ?? 0
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
                if let profileURL = self.users[indexPath.row]?.img, let urlProfile1 = URL(string: profileURL) {
                        cell?.img.sd_setImage(with: urlProfile1)
                    }
                cell?.lblFollowers.text = self.users[indexPath.row]?.followers ?? "0 Followers"
                cell?.lblName.text      = self.users[indexPath.row]?.channelName ?? ""
                cell?.lblType.text      = self.users[indexPath.row]?.accountType ?? ""
            }
            if self.users[indexPath.row]?.selected == 0 {
                cell?.imgSelected.image  = UIImage(systemName: "circle")
            }
            else{
                cell?.imgSelected.image  = UIImage(systemName: "checkmark.circle.fill")
            }
        }
        return cell!
            
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !showTagUsers {
            if self.users[indexPath.row]?.selected == 0 {
                self.users[indexPath.row]?.selected = 1
               // self.selectedUser.append(contentsOf: users[indexPath.row])
            }
            else{
                self.users[indexPath.row]?.selected = 0
            }
            tableView.reloadData()
        }
    }
}

//MARK: - GET User Collection {}
extension TagPeopleVC {
    
    func getAllUsers() {
           let db = Firestore.firestore()
           db.collection("userCollection").getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error getting documents: \(error.localizedDescription)")
                   // Handle the error (e.g., show an alert to the user)
               } else {
                   self.users.removeAll() // Clear any existing users
                   // Iterate over the documents in the snapshot
                   for document in querySnapshot!.documents {
                       let data = document.data()
                       let uid = data["uid"] as? String ?? ""
                       if uid == UserDefault.token {
                           continue
                       }
                       let img = data["img"] as? String ?? ""
                       let channelName = data["channelName"] as? String ?? ""
                       let followers = data["followers"] as? String ?? ""
                       let accountType = data["accountType"] as? String ?? ""

                       let user = UserTagModel(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType, selected: 0)
                       self.users.append(user)
                       print(user)
                   }
                   self.tblSelection.reloadData()
               }
           }
       }

}
