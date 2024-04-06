//
//  ContentSelectionVC.swift
//  Resturants
//
//  Created by Coder Crew on 05/04/2024.
//

import UIKit

class ContentSelectionVC: UIViewController , UISearchTextFieldDelegate{

    @IBOutlet weak var tblSelection: UITableView!
    @IBOutlet weak var lblHeader   : UILabel!
    @IBOutlet weak var txtSearch   : UITextField!
    
    var delegate :createAccntDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapDone(_ sender: UIButton){
        self.dismiss(animated: true)
        delegate?.collectionData(type: 0)
    }
}

//MARK: - Custom Implementation {}
extension ContentSelectionVC{
    
    func onLaod() {
        setupView()
        txtSearch.addTarget(self, action: #selector(textFieldDidEndChange(_:)),
                            for: .editingChanged)
        txtSearch.delegate = self
    }
    
    func onAppear() {
        UserManager.shared.filteredSpeacials.removeAll()
    }
    func setupView(){
        
        tblSelection.register(SelectioTCell.nib, forCellReuseIdentifier: SelectioTCell.identifier)
        tblSelection.delegate   = self
        tblSelection.dataSource = self
    }
}

//MARK: - Search TextField {}
extension ContentSelectionVC: UITextFieldDelegate {
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
        UserManager.shared.filteredContent = UserManager.shared.arrContent.filter { $0[0].localizedCaseInsensitiveContains(searchText) }
        // Filter the selection status based on the filtered cuisine items
        for i in 0..<UserManager.shared.filteredContent.count {
            if let index = UserManager.shared.arrContent.firstIndex(where: { $0[0] == UserManager.shared.filteredContent[i][0] }) {
                UserManager.shared.filteredContent[i][1] = UserManager.shared.arrContent[index][1]
            }
        }
    }
}

//MARK: - TableView {}
extension ContentSelectionVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.lblHeader.text  = "Content"
        return UserManager.shared.filteredContent.count == 0 && txtSearch.text == "" ? UserManager.shared.arrContent.count : UserManager.shared.filteredContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectioTCell
        
        
        let cuisineName: String
        if UserManager.shared.filteredCuisine.isEmpty {
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
}
