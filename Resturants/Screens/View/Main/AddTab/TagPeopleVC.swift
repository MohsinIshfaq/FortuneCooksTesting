//
//  TagPeopleVC.swift
//  Resturants
//
//  Created by Coder Crew on 05/04/2024.
//

import UIKit
protocol TagPeopleDelegate {
    func reload()
}

class TagPeopleVC: UIViewController , UISearchTextFieldDelegate{

    @IBOutlet weak var tblSelection: UITableView!
    @IBOutlet weak var txtSearch   : UITextField!
    @IBOutlet weak var btnSubmit   : UIButton!
    @IBOutlet weak var lblHeader   : UILabel!
    
    var delegate: TagPeopleDelegate? = nil
    var showTagUsers: Bool           = false
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func ontapDone(_ sender: UIButton){
        self.dismiss(animated: true)
        delegate?.reload()
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
        return UserManager.shared.arrTagPeoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagUserTCell.identifier) as? TagUserTCell
        if showTagUsers {
            cell?.btnFollow.isHidden = false
            cell?.imgSelected.isHidden = true
        }
        else {
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
