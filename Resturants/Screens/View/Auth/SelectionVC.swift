//
//  SelectionVC.swift
//  Resturants
//
//  Created by shah on 30/01/2024.
//

import UIKit

class SelectionVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tblSelection: UITableView!
    
    //MARK: - Variables and Properties
    var type  = 0
    var delegate :createAccntDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
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

//MARK: - Custom Implementation {}
extension SelectionVC{
   
    func onLaod() {
        setupView()
    }
    
    func onAppear() {
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
            return UserManager.shared.arrCuisine.count
        }
        else if type == 1 {
            return UserManager.shared.arrEnviorment.count
        }
        else if type == 2 {
            return UserManager.shared.arrFeature.count
        }
        else if type == 3 {
            return UserManager.shared.arrMeals.count
        }
        else{
            return UserManager.shared.arrSpeacials.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectioTCell.identifier) as? SelectioTCell
        if type == 0 {
            cell?.lbl.text = UserManager.shared.arrCuisine[indexPath.row][0]
            if UserManager.shared.arrCuisine[indexPath.row][1] == "1" {
                cell?.img.image = UIImage(systemName: "checkmark.square")
            }
            else{
                cell?.img.image = UIImage(systemName: "square")
            }
        }
        else if type == 1 {
            cell?.lbl.text = UserManager.shared.arrEnviorment[indexPath.row][0]
            if UserManager.shared.arrEnviorment[indexPath.row][1] == "1" {
                cell?.img.image = UIImage(systemName: "checkmark.square")
            }
            else{
                cell?.img.image = UIImage(systemName: "square")
            }
        }
        else if type == 2 {
            cell?.lbl.text = UserManager.shared.arrFeature[indexPath.row][0]
            if UserManager.shared.arrFeature[indexPath.row][1] == "1" {
                cell?.img.image = UIImage(systemName: "checkmark.square")
            }
            else{
                cell?.img.image = UIImage(systemName: "square")
            }
        }
        else if type == 3 {
            cell?.lbl.text = UserManager.shared.arrMeals[indexPath.row][0]
            if UserManager.shared.arrMeals[indexPath.row][1] == "1" {
                cell?.img.image = UIImage(systemName: "checkmark.square")
            }
            else{
                cell?.img.image = UIImage(systemName: "square")
            }
        }
        else{
            cell?.lbl.text = UserManager.shared.arrSpeacials[indexPath.row][0]
            if UserManager.shared.arrSpeacials[indexPath.row][1] == "1" {
                cell?.img.image = UIImage(systemName: "checkmark.square")
            }
            else{
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
        
        if type == 0 {
            if UserManager.shared.arrCuisine[indexPath.row][1] == "1"{
                UserManager.shared.arrCuisine[indexPath.row][1] = "0"
            }
            else{
                UserManager.shared.arrCuisine[indexPath.row][1] = "1"
            }
            tableView.reloadData()
        }
        else if type == 1 {
            if UserManager.shared.arrEnviorment[indexPath.row][1] == "1"{
                UserManager.shared.arrEnviorment[indexPath.row][1] = "0"
            }
            else{
                UserManager.shared.arrEnviorment[indexPath.row][1] = "1"
            }
            tableView.reloadData()
        }
        else if type == 2 {
            if UserManager.shared.arrFeature[indexPath.row][1] == "1"{
                UserManager.shared.arrFeature[indexPath.row][1] = "0"
            }
            else{
                UserManager.shared.arrFeature[indexPath.row][1] = "1"
            }
            tableView.reloadData()
        }
        else if type == 2 {
            if UserManager.shared.arrMeals[indexPath.row][1] == "1"{
                UserManager.shared.arrMeals[indexPath.row][1] = "0"
            }
            else{
                UserManager.shared.arrMeals[indexPath.row][1] = "1"
            }
            tableView.reloadData()
        }
        else{
            if UserManager.shared.arrSpeacials[indexPath.row][1] == "1"{
                UserManager.shared.arrSpeacials[indexPath.row][1] = "0"
            }
            else{
                UserManager.shared.arrSpeacials[indexPath.row][1] = "1"
            }
            tableView.reloadData()
        }
    }
}
