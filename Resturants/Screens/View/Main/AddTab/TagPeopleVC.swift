//
//  TagPeopleVC.swift
//  Resturants
//
//  Created by Coder Crew on 05/04/2024.
//

import UIKit

class TagPeopleVC: UIViewController , UISearchTextFieldDelegate{

    @IBOutlet weak var tblSelection: UITableView!
    @IBOutlet weak var txtSearch   : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func ontapDone(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapDismis(_ sender: UIButton){
        self.dismiss(animated: true)
    }
}

//MARK: - Custom Implementation {}
extension TagPeopleVC{
   
    func onLaod() {
        setupView()
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
        if UserManager.shared.arrTagPeoples[indexPath.row][1] == "0" {
            cell?.imgSelected.image  = UIImage(systemName: "circle")
        }
        else{
            cell?.imgSelected.image  = UIImage(systemName: "circle.fill")
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if UserManager.shared.arrTagPeoples[indexPath.row][1] == "0" {
            UserManager.shared.arrTagPeoples[indexPath.row][1] = "1"
        }
        else{
            UserManager.shared.arrTagPeoples[indexPath.row][1] = "0"
        }
        tableView.reloadData()
    }
}
