//
//  FollowersVC.swift
//  Resturants
//
//  Created by Coder Crew on 09/05/2024.
//

import UIKit

class FollowersVC: UIViewController {
    
    @IBOutlet weak var tblSelection: UITableView!
    @IBOutlet weak var txtSearch   : UITextField!
    
    @IBOutlet weak var vwFollowing : UIView!
    @IBOutlet weak var vwFollowers : UIView!
    
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
        }
        else{
            vwFollowing.isHidden = true
            vwFollowers.isHidden = false
        }
    }
}
//MARK: - Custom Implementation {}
extension FollowersVC{
   
    func onLaod() {
        setupView()
        vwFollowing.isHidden = false
        vwFollowers.isHidden = true
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
}

//MARK: - TableView {}
extension FollowersVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.shared.arrTagPeoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagUserTCell.identifier) as? TagUserTCell
        cell?.btnFollow.isHidden = false
        cell?.imgSelected.isHidden = true
        cell?.btnMore.addTarget(self, action: #selector(ontapMore(_ :)), for: .touchUpInside)
        cell?.tag = indexPath.row
        return cell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
