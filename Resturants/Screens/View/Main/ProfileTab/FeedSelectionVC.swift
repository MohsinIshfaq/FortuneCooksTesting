//
//  FeedSelectionVC.swift
//  Resturants
//
//  Created by Coder Crew on 17/05/2024.
//

import UIKit

protocol FeedDelegate {
    func collectionData(type: Int)
}
class FeedSelectionVC: UIViewController , UISearchTextFieldDelegate{

    //MARK: - @IBOutlets
    @IBOutlet weak var tblSelection: UITableView!
    @IBOutlet weak var lblHeader   : UILabel!
    @IBOutlet weak var txtSearch   : UITextField!
    
    //MARK: - Variables and Properties
    var type  = 0
    var delegate :FeedDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    @IBAction func ontapDone(_ sender: UIButton){
        self.dismiss(animated: true)
        
        delegate?.collectionData(type: type == 0 ? 0 : 1)
    }

}


//MARK: - Search TextField {}
extension FeedSelectionVC: UITextFieldDelegate {
    @objc func textFieldDidEndChange(_ textField: UITextField) {
        print(txtSearch.text!)
        tblSelection.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }
        filterContentForSearchText(searchText)
        return true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if type == 0{
            // Filter content based on the starting character
            UserManager.shared.filteredContent = UserManager.shared.arrContent.filter {
                $0[0].lowercased().hasPrefix(searchText.lowercased())
            }
            // Filter the selection status based on the filtered content
            for i in 0..<UserManager.shared.filteredContent.count {
                if let index = UserManager.shared.arrContent.firstIndex(where: { $0[0] == UserManager.shared.filteredContent[i][0] }) {
                    UserManager.shared.filteredContent[i][1] = UserManager.shared.arrContent[index][1]
                }
            }
            tblSelection.reloadData()
        }
        else{
            print(searchText.lowercased())
            // Filter account type based on the starting character in a case-insensitive manner
            UserManager.shared.filteredAccntType = UserManager.shared.arrAccntType.filter {
                $0[0].lowercased().hasPrefix(searchText.lowercased())
            }
            print(UserManager.shared.filteredAccntType)
            // Filter the selection status based on the filtered account type items
            for i in 0..<UserManager.shared.filteredAccntType.count {
                if let index = UserManager.shared.arrAccntType.firstIndex(where: { $0[0] == UserManager.shared.filteredAccntType[i][0] }) {
                    UserManager.shared.filteredAccntType[i][1] = UserManager.shared.arrAccntType[index][1]
                }
            }
            tblSelection.reloadData()
        }
    }
}

//MARK: - Custom Implementation {}
extension FeedSelectionVC{
   
    func onLaod() {
        setupView()
        txtSearch.addTarget(self, action: #selector(textFieldDidEndChange(_:)),
                                  for: .editingChanged)
        txtSearch.delegate = self
    }
    
    func onAppear() {
        UserManager.shared.filteredContent.removeAll()
        UserManager.shared.filteredAccntType.removeAll()
        
    }
    
    func setupView(){
        
        tblSelection.register(SelectioTCell.nib, forCellReuseIdentifier: SelectioTCell.identifier)
        tblSelection.delegate   = self
        tblSelection.dataSource = self
    }
}

//MARK: - TableView {}
extension FeedSelectionVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 0 {
            self.lblHeader.text  = "Cuisine"
            return UserManager.shared.filteredContent.count == 0 && txtSearch.text == "" ? UserManager.shared.arrContent.count : UserManager.shared.filteredContent.count
        }
        else{
            self.lblHeader.text  = "Cuisine"
            return UserManager.shared.filteredAccntType.count == 0 && txtSearch.text == "" ? UserManager.shared.arrAccntType.count : UserManager.shared.filteredAccntType.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectioTCell.identifier) as? SelectioTCell
            cell?.lbl.text = UserManager.shared.filteredContent.isEmpty && txtSearch.text == "" ? UserManager.shared.arrContent[indexPath.row][0] : UserManager.shared.filteredContent[indexPath.row][0]
            
            if let index = UserManager.shared.arrContent.firstIndex(where: { $0[0] == cell?.lbl.text }) {
                if UserManager.shared.arrContent[index][1] == "1" {
                    cell?.img.image = UIImage(systemName: "checkmark.square")
                } else {
                    cell?.img.image = UIImage(systemName: "square")
                }
            }
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectioTCell.identifier) as? SelectioTCell
            cell?.lbl.text = UserManager.shared.filteredAccntType.isEmpty && txtSearch.text == "" ? UserManager.shared.arrAccntType[indexPath.row][0] : UserManager.shared.filteredAccntType[indexPath.row][0]
            
            if let index = UserManager.shared.arrAccntType.firstIndex(where: { $0[0] == cell?.lbl.text }) {
                if UserManager.shared.arrAccntType[index][1] == "1" {
                    cell?.img.image = UIImage(systemName: "checkmark.square")
                } else {
                    cell?.img.image = UIImage(systemName: "square")
                }
            }
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! SelectioTCell
            let cuisineName: String
            if UserManager.shared.filteredContent.isEmpty {
                cuisineName = UserManager.shared.arrContent[indexPath.row][0]
            } else {
                cuisineName = UserManager.shared.filteredContent[indexPath.row][0]
            }
            
            if let index = UserManager.shared.arrContent.firstIndex(where: { $0[0] == cuisineName }) {
                if UserManager.shared.arrContent[index][1] == "1" {
                    UserManager.shared.arrContent[index][1] = "0"
                } else {
                    UserManager.shared.arrContent[index][1] = "1"
                }
            }
            tableView.reloadData()
        }
        else{
            let cell = tableView.cellForRow(at: indexPath) as! SelectioTCell
            let cuisineName: String
            if UserManager.shared.filteredAccntType.isEmpty {
                cuisineName = UserManager.shared.arrAccntType[indexPath.row][0]
            } else {
                cuisineName = UserManager.shared.filteredAccntType[indexPath.row][0]
            }
            
            if let index = UserManager.shared.arrAccntType.firstIndex(where: { $0[0] == cuisineName }) {
                if UserManager.shared.arrAccntType[index][1] == "1" {
                    UserManager.shared.arrAccntType[index][1] = "0"
                } else {
                    UserManager.shared.arrAccntType[index][1] = "1"
                }
            }
            tableView.reloadData()
        }
    }
}
