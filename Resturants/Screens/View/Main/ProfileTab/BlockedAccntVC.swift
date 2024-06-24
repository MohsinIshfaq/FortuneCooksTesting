//
//  BlockedAccntVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/06/2024.
//

import UIKit

class BlockedAccntVC: UIViewController {

    @IBOutlet weak var tblSelection: UITableView!
    
    var showTagUsers: Bool           = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
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
        return UserManager.shared.arrTagPeoples.count
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
            if UserManager.shared.arrTagPeoples[indexPath.row][1] == "0" {
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
            if UserManager.shared.arrTagPeoples[indexPath.row][1] == "0" {
                UserManager.shared.arrTagPeoples[indexPath.row][1] = "1"
                UserManager.shared.totalTagPeople += 1
                print(UserManager.shared.totalTagPeople)
            }
            else{
                UserManager.shared.arrTagPeoples[indexPath.row][1] = "0"
                UserManager.shared.totalTagPeople -= 1
            }
            tableView.reloadData()
        }
    }
}
