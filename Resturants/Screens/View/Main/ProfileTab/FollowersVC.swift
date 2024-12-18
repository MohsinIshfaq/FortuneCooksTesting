//
//  FollowersVC.swift
//  Resturants
//
//  Created by Coder Crew on 09/05/2024.
//

import UIKit
import FirebaseFirestoreInternal

class FollowersVC: UIViewController {
    
    //MARK: - IBOUtlets
    @IBOutlet weak var tblSelection: UITableView!
    @IBOutlet weak var txtSearch   : UITextField!
    @IBOutlet weak var vwFollowing : UIView!
    @IBOutlet weak var vwFollowers : UIView!
    
    //MARK: - Variables and Properties
    var isFollowers                  = false
//    var users: [UserTagModel]        = []
//    var selectedFollowers: [UserTagModel]  = []      //Users to be tag
//    var alreadyFollowersUsers: [TagUsers]  = []
    var alreadyFollowingsUsers: [TagUsers]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onLaod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeNavBackbuttonTitle()
    }
    
    @IBAction func ontapTabs(_ sender: UIButton) {
        if sender.tag == 0{
            vwFollowing.isHidden = false
            vwFollowers.isHidden = true
            isFollowers          = false
        }
        else{
            vwFollowing.isHidden = true
            vwFollowers.isHidden = false
            isFollowers          = true
        }
        tblSelection.reloadData()
    }
}
//MARK: - Custom Implementation {}
extension FollowersVC{
   
    func onLaod() {
        setupView()
        if !isFollowers{
            vwFollowing.isHidden = false
            vwFollowers.isHidden = true
        }
        else{
            vwFollowing.isHidden = true
            vwFollowers.isHidden = false
        }
        //getAllUsers()
    }
    
    func setupView(){
        
        tblSelection.register(TagUserTCell.nib, forCellReuseIdentifier: TagUserTCell.identifier)
        tblSelection.delegate   = self
        tblSelection.dataSource = self
    }
    
    @objc func ontapMore(_ sender: UIButton){
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "RemoveFollowerVC") as! RemoveFollowerVC
        self.present(vc, animated: true)
    }
    
//    //MARK: - i wanna mark already tag user as selected i have key of selected in users
//    func markSelectedAlreadyFollowersData() {
//        
//        for j in 0 ..< alreadyFollowersUsers.count {
//            for i in 0 ..< users.count{
//                if users[i].uid == alreadyFollowersUsers[j].uid {
//                    users[i].selected = 1
//                    self.selectedFollowers.append(users[i])
//                }
//            }
//        }
//        self.tblSelection.reloadData()
//    }
}

//MARK: - TableView {}
extension FollowersVC: UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alreadyFollowingsUsers.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagUserTCell.identifier) as? TagUserTCell
        cell?.btnFollow.isHidden = false
        cell?.imgSelected.isHidden = true
        cell?.btnMore.addTarget(self, action: #selector(ontapMore(_ :)), for: .touchUpInside)
        cell?.btnFollow.addTarget(self, action: #selector(ontapFollow(_ :)), for: .touchUpInside)
        cell?.btnFollow.tag = indexPath.row
        if isFollowers {
            cell?.btnFollow.backgroundColor             = .gray
            cell?.btnFollow.titleLabel?.textColor       = .white
            cell?.btnMore.isHidden                      = true
            cell?.btnFollow.isHidden                     = true
        }
        else{
            cell?.btnFollow.backgroundColor              = .ColorYellow
            cell?.btnFollow.titleLabel?.textColor        = .black
            cell?.btnMore.isHidden                       = true
            cell?.btnFollow.isHidden                     = true
            DispatchQueue.main.async {
                if let profileURL = self.alreadyFollowingsUsers[indexPath.row].img, let urlProfile1 = URL(string: profileURL) {
                    cell?.img.sd_setImage(with: urlProfile1)
                }
                cell?.lblFollowers.text = self.alreadyFollowingsUsers[indexPath.row].followers ?? "0 Followers"
                cell?.lblName.text      = self.alreadyFollowingsUsers[indexPath.row].channelName ?? ""
                cell?.lblType.text      = self.alreadyFollowingsUsers[indexPath.row].accountType ?? ""
            }
//            if self.users[indexPath.row].selected == 0 {
//                cell?.imgSelected.image  = UIImage(systemName: "circle")
//            }
//            else{
//                cell?.imgSelected.image  = UIImage(systemName: "checkmark.circle.fill")
//            }
        }
        cell?.tag = indexPath.row
        return cell!
        
    }
    
    @objc func ontapFollow(_ sender: UIButton){
//        if self.users[sender.tag].selected == 0 {
//            self.users[sender.tag].selected = 1
//            self.selectedFollowers.append(users[sender.tag])
//            print(self.selectedFollowers.count)
//        }
//        else{
//            self.users[sender.tag].selected = 0
//            self.selectedFollowers.remove(at: sender.tag)
//            print(self.selectedFollowers.count)
//        }
//        tblSelection.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - GET User Collection {}
//extension FollowersVC {
//    
//    func getAllUsers() {
//        let db = Firestore.firestore()
//        db.collection("userCollection").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error.localizedDescription)")
//                // Handle the error (e.g., show an alert to the user)
//            } else {
//                self.users.removeAll() // Clear any existing users
//                // Iterate over the documents in the snapshot
//                for document in querySnapshot!.documents {
//                    let data = document.data()
//                    let uid = data["uid"] as? String ?? ""
//                    if uid == UserDefault.token {
//                        continue
//                    }
//                    let img = data["img"] as? String ?? ""
//                    let channelName = data["channelName"] as? String ?? ""
//                    let followers = data["followers"] as? String ?? ""
//                    let accountType = data["accountType"] as? String ?? ""
//                    
//                    let user = UserTagModel(uid: uid, img: img, channelName: channelName, followers: followers, accountType: accountType, selected: 0)
//                    self.users.append(user)
//                    print(user)
//                }
//                self.markSelectedAlreadyFollowersData()
//            }
//        }
//    }
//    
//    func addFollowersList(_ userID: String, followesList: [UserTagModel]) {
//        self.startAnimating()
//        let db = Firestore.firestore()
//        let tagUserDictionaries = followesList.map { $0.toDictionary() }
//        db.collection("Users").document(userID).updateData([
//            "followers": tagUserDictionaries
//        ]) { [self] err in
//            if let err = err {
//                self.stopAnimating()
//                print("Error updating tagPersons: \(err)")
//            } else {
//                self.stopAnimating()
//                print("tagPersons successfully updated in Firestore")
//                self.dismiss(animated: true)
//            }
//        }
//    }
//}
