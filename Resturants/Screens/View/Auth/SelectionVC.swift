//
//  SelectionVC.swift
//  Resturants
//
//  Created by shah on 30/01/2024.
//

import UIKit

class SelectionVC: UIViewController , UISearchTextFieldDelegate {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tblSelection: UITableView!
    @IBOutlet weak var lblHeader   : UILabel!
    @IBOutlet weak var txtSearch   : UITextField!
    
    //MARK: - Variables and Properties
    var type  = 0
    var delegate :createAccntDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    @IBAction func ontapDismiss(_ : UIButton){
        self.dismiss(animated: true)
    }
    @IBAction func ontapDone(_ sender: UIButton){
        self.dismiss(animated: true)
        if self.type == 0{
            delegate?.collectionData(type: 0)
        }
        else if self.type == 1{
            delegate?.collectionData(type: 1)
        }
        else if self.type == 2{
            delegate?.collectionData(type: 2)
        }
        else if self.type == 3{
            delegate?.collectionData(type: 3)
        }
        else{
            delegate?.collectionData(type: 4)
        }
    }
}

//MARK: - Search TextField {}
extension SelectionVC: UITextFieldDelegate {
    @objc func textFieldDidEndChange(_ textField: UITextField) {
        print(txtSearch.text!)
        tblSelection.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let updatedText = currentText.replacingCharacters(in: range, with: string)
        filterContentForSearchText(updatedText)
        return true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if type == 0 {
            let lowercasedSearchText = searchText.lowercased()
            UserManager.shared.filteredCuisine = UserManager.shared.arrCuisine.filter { $0[0].lowercased().hasPrefix(lowercasedSearchText) }
            // Filter the selection status based on the filtered cuisine items
            for i in 0..<UserManager.shared.filteredCuisine.count {
                if let index = UserManager.shared.arrCuisine.firstIndex(where: { $0[0] == UserManager.shared.filteredCuisine[i][0] }) {
                    UserManager.shared.filteredCuisine[i][1] = UserManager.shared.arrCuisine[index][1]
                }
            }
        }
        else if type == 1 {
            let lowercasedSearchText = searchText.lowercased()
            UserManager.shared.filteredEnviorment = UserManager.shared.arrEnviorment.filter { $0[0].lowercased().hasPrefix(lowercasedSearchText) }
            // Filter the selection status based on the filtered cuisine items
            for i in 0..<UserManager.shared.filteredEnviorment.count {
                if let index = UserManager.shared.arrEnviorment.firstIndex(where: { $0[0] == UserManager.shared.filteredEnviorment[i][0] }) {
                    UserManager.shared.filteredEnviorment[i][1] = UserManager.shared.arrEnviorment[index][1]
                }
            }
        }
        else if type == 2 {
            let lowercasedSearchText = searchText.lowercased()
            UserManager.shared.filteredFeature = UserManager.shared.arrFeature.filter { $0[0].lowercased().hasPrefix(lowercasedSearchText) }
            // Filter the selection status based on the filtered cuisine items
            for i in 0..<UserManager.shared.filteredFeature.count {
                if let index = UserManager.shared.arrFeature.firstIndex(where: { $0[0] == UserManager.shared.filteredFeature[i][0] }) {
                    UserManager.shared.filteredFeature[i][1] = UserManager.shared.arrFeature[index][1]
                }
            }
        }
        else if type == 3 {
            let lowercasedSearchText = searchText.lowercased()
            UserManager.shared.filteredMeals = UserManager.shared.arrMeals.filter { $0[0].lowercased().hasPrefix(lowercasedSearchText) }
            // Filter the selection status based on the filtered cuisine items
            for i in 0..<UserManager.shared.filteredMeals.count {
                if let index = UserManager.shared.arrMeals.firstIndex(where: { $0[0] == UserManager.shared.filteredMeals[i][0] }) {
                    UserManager.shared.filteredMeals[i][1] = UserManager.shared.arrMeals[index][1]
                }
            }
        }
        else{
            let lowercasedSearchText = searchText.lowercased()
            UserManager.shared.filteredSpeacials = UserManager.shared.arrSpeacials.filter { $0[0].lowercased().hasPrefix(lowercasedSearchText) }
            // Filter the selection status based on the filtered cuisine items
            for i in 0..<UserManager.shared.filteredSpeacials.count {
                if let index = UserManager.shared.arrSpeacials.firstIndex(where: { $0[0] == UserManager.shared.filteredSpeacials[i][0] }) {
                    UserManager.shared.filteredSpeacials[i][1] = UserManager.shared.arrSpeacials[index][1]
                }
            }
        }
        // Reload table view to reflect the filtered data
        tblSelection.reloadData()
    }
}
//MARK: - Custom Implementation {}
extension SelectionVC{
   
    func onLaod() {
        setupView()
        txtSearch.addTarget(self, action: #selector(textFieldDidEndChange(_:)),
                                  for: .editingChanged)
        txtSearch.delegate = self
    }
    
    func onAppear() {
        UserManager.shared.filteredCuisine.removeAll()
        UserManager.shared.filteredEnviorment.removeAll()
        UserManager.shared.filteredFeature.removeAll()
        UserManager.shared.filteredMeals.removeAll()
        UserManager.shared.filteredSpeacials.removeAll()
    }
    
    func setupView(){
        
        tblSelection.register(SelectioTCell.nib, forCellReuseIdentifier: SelectioTCell.identifier)
        tblSelection.delegate   = self
        tblSelection.dataSource = self
    }
}

//MARK: - TableView {}
extension SelectionVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 0 {
            self.lblHeader.text  = "Cuisine"
            return UserManager.shared.filteredCuisine.count == 0 && txtSearch.text == "" ? UserManager.shared.arrCuisine.count : UserManager.shared.filteredCuisine.count
        }
        else if type == 1 {
            self.lblHeader.text  = "Enviornment"
            return UserManager.shared.filteredEnviorment.count == 0 && txtSearch.text == "" ? UserManager.shared.arrEnviorment.count : UserManager.shared.filteredEnviorment.count
           // return UserManager.shared.arrEnviorment.count
        }
        else if type == 2 {
            self.lblHeader.text  = "Feature"
            return UserManager.shared.filteredFeature.count == 0 && txtSearch.text == "" ? UserManager.shared.arrFeature.count : UserManager.shared.filteredFeature.count
           // return UserManager.shared.arrFeature.count
        }
        else if type == 3 {
            self.lblHeader.text  = "Meal"
            return UserManager.shared.filteredMeals.count == 0 && txtSearch.text == "" ? UserManager.shared.arrMeals.count : UserManager.shared.filteredMeals.count
           // return UserManager.shared.arrMeals.count
        }
        else{
            self.lblHeader.text  = "Specailization"
            return UserManager.shared.filteredSpeacials.count == 0 && txtSearch.text == "" ? UserManager.shared.arrSpeacials.count : UserManager.shared.filteredSpeacials.count
            //return UserManager.shared.arrSpeacials.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectioTCell.identifier) as? SelectioTCell
        if type == 0 {
            cell?.lbl.text = UserManager.shared.filteredCuisine.isEmpty && txtSearch.text == "" ? UserManager.shared.arrCuisine[indexPath.row][0] : UserManager.shared.filteredCuisine[indexPath.row][0]
            
            if let index = UserManager.shared.arrCuisine.firstIndex(where: { $0[0] == cell?.lbl.text }) {
                if UserManager.shared.arrCuisine[index][1] == "1" {
                    cell?.img.image = UIImage(systemName: "checkmark.square")
                } else {
                    cell?.img.image = UIImage(systemName: "square")
                }
            }
        }
        else if type == 1 {
            
            cell?.lbl.text = UserManager.shared.filteredEnviorment.isEmpty && txtSearch.text == "" ? UserManager.shared.arrEnviorment[indexPath.row][0] : UserManager.shared.filteredEnviorment[indexPath.row][0]
            
            if let index = UserManager.shared.arrEnviorment.firstIndex(where: { $0[0] == cell?.lbl.text }) {
                if UserManager.shared.arrEnviorment[index][1] == "1" {
                    cell?.img.image = UIImage(systemName: "checkmark.square")
                } else {
                    cell?.img.image = UIImage(systemName: "square")
                }
            }
        }
        else if type == 2 {
            cell?.lbl.text = UserManager.shared.filteredFeature.isEmpty && txtSearch.text == "" ? UserManager.shared.arrFeature[indexPath.row][0] : UserManager.shared.filteredFeature[indexPath.row][0]
            
            if let index = UserManager.shared.arrFeature.firstIndex(where: { $0[0] == cell?.lbl.text }) {
                if UserManager.shared.arrFeature[index][1] == "1" {
                    cell?.img.image = UIImage(systemName: "checkmark.square")
                } else {
                    cell?.img.image = UIImage(systemName: "square")
                }
            }
        }
        else if type == 3 {
            cell?.lbl.text = UserManager.shared.filteredMeals.isEmpty && txtSearch.text == "" ? UserManager.shared.arrMeals[indexPath.row][0] : UserManager.shared.filteredMeals[indexPath.row][0]
            
            if let index = UserManager.shared.arrMeals.firstIndex(where: { $0[0] == cell?.lbl.text }) {
                if UserManager.shared.arrMeals[index][1] == "1" {
                    cell?.img.image = UIImage(systemName: "checkmark.square")
                } else {
                    cell?.img.image = UIImage(systemName: "square")
                }
            }
        }
        else{
            cell?.lbl.text = UserManager.shared.filteredSpeacials.isEmpty && txtSearch.text == "" ? UserManager.shared.arrSpeacials[indexPath.row][0] : UserManager.shared.filteredSpeacials[indexPath.row][0]
            
            if let index = UserManager.shared.arrSpeacials.firstIndex(where: { $0[0] == cell?.lbl.text }) {
                if UserManager.shared.arrSpeacials[index][1] == "1" {
                    cell?.img.image = UIImage(systemName: "checkmark.square")
                } else {
                    cell?.img.image = UIImage(systemName: "square")
                }
            }
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectioTCell
            
        if type == 0 {
            let cuisineName: String
            if UserManager.shared.filteredCuisine.isEmpty {
                cuisineName = UserManager.shared.arrCuisine[indexPath.row][0]
            } else {
                cuisineName = UserManager.shared.filteredCuisine[indexPath.row][0]
            }
            
            if let index = UserManager.shared.arrCuisine.firstIndex(where: { $0[0] == cuisineName }) {
                if UserManager.shared.arrCuisine[index][1] == "1" {
                    UserManager.shared.arrCuisine[index][1] = "0"
                } else {
                    UserManager.shared.arrCuisine[index][1] = "1"
                }
            }
            tableView.reloadData()
        }
        else if type == 1 {
            let cuisineName: String
            if UserManager.shared.filteredEnviorment.isEmpty {
                cuisineName = UserManager.shared.arrEnviorment[indexPath.row][0]
            } else {
                cuisineName = UserManager.shared.filteredEnviorment[indexPath.row][0]
            }
            
            if let index = UserManager.shared.arrEnviorment.firstIndex(where: { $0[0] == cuisineName }) {
                if UserManager.shared.arrEnviorment[index][1] == "1" {
                    UserManager.shared.arrEnviorment[index][1] = "0"
                } else {
                    UserManager.shared.arrEnviorment[index][1] = "1"
                }
            }
            tableView.reloadData()
        }
        else if type == 2 {
            let cuisineName: String
            if UserManager.shared.filteredFeature.isEmpty {
                cuisineName = UserManager.shared.arrFeature[indexPath.row][0]
            } else {
                cuisineName = UserManager.shared.filteredFeature[indexPath.row][0]
            }
            
            if let index = UserManager.shared.arrFeature.firstIndex(where: { $0[0] == cuisineName }) {
                if UserManager.shared.arrFeature[index][1] == "1" {
                    UserManager.shared.arrFeature[index][1] = "0"
                } else {
                    UserManager.shared.arrFeature[index][1] = "1"
                }
            }
            tableView.reloadData()
        }
        else if type == 3 {
            let cuisineName: String
            if UserManager.shared.filteredMeals.isEmpty {
                cuisineName = UserManager.shared.arrMeals[indexPath.row][0]
            } else {
                cuisineName = UserManager.shared.filteredMeals[indexPath.row][0]
            }
            
            if let index = UserManager.shared.arrMeals.firstIndex(where: { $0[0] == cuisineName }) {
                if UserManager.shared.arrMeals[index][1] == "1" {
                    UserManager.shared.arrMeals[index][1] = "0"
                } else {
                    UserManager.shared.arrMeals[index][1] = "1"
                }
            }
            tableView.reloadData()
        }
        else{
            let cuisineName: String
            if UserManager.shared.filteredSpeacials.isEmpty {
                cuisineName = UserManager.shared.arrSpeacials[indexPath.row][0]
            } else {
                cuisineName = UserManager.shared.filteredSpeacials[indexPath.row][0]
            }
            
            if let index = UserManager.shared.arrSpeacials.firstIndex(where: { $0[0] == cuisineName }) {
                if UserManager.shared.arrSpeacials[index][1] == "1" {
                    UserManager.shared.arrSpeacials[index][1] = "0"
                } else {
                    UserManager.shared.arrSpeacials[index][1] = "1"
                }
            }
            tableView.reloadData()
        }
    }
}
