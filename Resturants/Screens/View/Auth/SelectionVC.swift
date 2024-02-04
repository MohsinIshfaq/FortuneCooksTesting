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
    private var arrCuisine         = [["African" , "0"],
                                      ["American" , "0"],
                                      ["Asian" , "0"],
                                      ["Brazilian" , "0"],
                                      ["British" , "0"],
                                      ["Ethiopian" , "0"],
                                      ["European" , "0"],
                                      ["French" , "0"],
                                      ["From the Mediterranean" , "0"] , ["Fusion/Crossover" , "0"],
                                      ["Greek" , "0"],
                                      ["Grilled" , "0"],
                                      [ "Indian" , "0"],
                                      ["Italian" , "0"],
                                      ["Japanese" , "0"],
                                      ["Chinese" , "0"],
                                      ["Korean" , "0"],
                                      [ "Latin American" , "0"],
                                      ["Lebanese" , "0"],
                                      ["Moroccan" , "0"],
                                      ["Mexican" , "0"],
                                      ["Oriental" , "0"],
                                      ["Pakistani" , "0"],
                                      ["Persian" , "0"],
                                      ["Peruvian" , "0"],
                                      ["Portuguese" , "0"],
                                      ["Swiss" , "0"],
                                      [ "Scandinavian" , "0"],
                                      ["Spanish" , "0"],
                                      ["Steakhouse" , "0"],
                                      [ "Swedish" , "0"],
                                      ["Somali" , "0"],
                                      ["Thai" , "0"],
                                      [ "Traditional food" , "0"],
                                      ["Tunisian" , "0"],
                                      ["Turkish" , "0"],
                                      ["German" , "0"],
                                      ["Eastern European" , "0"]]
    
    private var arrEnviorment      = [["Business dinner" , "0"],
                                      [ "After work" , "0"],
                                      [ "Brunch" , "0"],
                                      ["Wedding" , "0"],
                                      ["Buffet" , "0"],
                                      ["Central location" , "0"],
                                      ["Fantastic view" , "0"],
                                      ["Birthday" , "0"],
                                      ["Gastronomic" , "0"],
                                      ["Groups" , "0"],
                                      ["Hotel restaurant" , "0"],
                                      ["Tavern" , "0"],
                                      ["Live music" , "0"],
                                      ["With family" , "0"],
                                      ["With friends" , "0"],
                                      ["Dinner cruise" , "0"],
                                      ["Modern food" , "0"],
                                      ["On the beach" , "0"],
                                      ["Raw food" , "0"],
                                      ["Street food" , "0"],
                                      ["Bachelor & bachelorette party" , "0"],
                                      ["Traditional" , "0"] ,
                                      ["Trendy" , "0"],
                                      ["Garden" , "0"],
                                      ["Outdoor seating" , "0"],
                                      ["By the sea" , "0"],
                                      ["By the water" , "0"],
                                      ["Wine bar Meals" , "0"] ,
                                      ["Breakfast" , "0"],
                                      ["Brunch" , "0"],
                                      ["Lunch" , "0"],
                                      ["Dinner" , "0"],
                                      ["Dessert" , "0"],
                                      ["Coffe" , "0"]]
    
    private var arrFeature         = [["Seating" , "0"],
                                      ["Reservations" , "0"],
                                      ["Takeout" , "0"],
                                      ["Delivery" , "0"],
                                      ["Buffet" , "0"],
                                      ["Accepts credit cards" , "0"],
                                      ["Outdoor seating" , "0"],
                                      ["Wheelchair accessible" , "0"],
                                      ["Highchairs available" , "0"],
                                      ["Free wifi" , "0"],
                                      ["Street parking" , "0"],
                                      ["Accepts American Express" , "0"],
                                      ["Dogs allowed" , "0"],
                                      ["Gift cards available" , "0"],
                                      ["Card payment only" , "0"],
                                      ["Cash only Specelize" , "0"] ,
                                      ["Halal Options" , "0"] ,
                                      ["Kosher options" , "0"] ,
                                      ["Vegan options" , "0"],
                                      ["Vegetarian options" , "0"],
                                      ["Gluten-free options" , "0"]]
    
    private var selectedCuisine:[String]       = []
    private var selectedEnviorment:[String]    = []
    private var selectedFeature:[String]       = []
    var delegate :createAccntDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }

    @IBAction func ontapDismiss(_ : UIButton){
        self.dismiss(animated: true)
        print(selectedCuisine)
    }
    @IBAction func ontapDone(_ sender: UIButton){
        self.dismiss(animated: true)
        if self.type == 0{
            delegate?.collectionData(arr: selectedCuisine , type: 0)
            selectedEnviorment.removeAll()
            selectedFeature.removeAll()
        }
        else if self.type == 1{
            delegate?.collectionData(arr: selectedEnviorment, type: 1)
            selectedFeature.removeAll()
            selectedCuisine.removeAll()
        }
        else{
            delegate?.collectionData(arr: selectedFeature, type: 2)
            selectedEnviorment.removeAll()
            selectedFeature.removeAll()
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
            return arrCuisine.count
        }
        else if type == 1 {
            return arrEnviorment.count
        }
        else {
            return arrFeature.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectioTCell.identifier) as? SelectioTCell
           if type == 0 {
               cell?.lbl.text = arrCuisine[indexPath.row][0]
               if arrCuisine[indexPath.row][1] == "1" {
                   cell?.img.image = UIImage(systemName: "checkmark.square")
               }
               else{
                   cell?.img.image = UIImage(systemName: "square")
               }
           }
           else if type == 1 {
               cell?.lbl.text = arrEnviorment[indexPath.row][0]
               if arrEnviorment[indexPath.row][1] == "1" {
                   cell?.img.image = UIImage(systemName: "checkmark.square")
               }
               else{
                   cell?.img.image = UIImage(systemName: "square")
               }
           }
           else {
               cell?.lbl.text = arrFeature[indexPath.row][0]
               if arrFeature[indexPath.row][1] == "1" {
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
            if arrCuisine[indexPath.row][1] == "1"{
                arrCuisine[indexPath.row][1] = "0"
            }
            else{
                arrCuisine[indexPath.row][1] = "1"
            }
            tableView.reloadData()
            if let index = self.selectedCuisine.firstIndex(of: arrCuisine[indexPath.row][0]) {
                self.selectedCuisine.remove(at: index)
            } else {
                // Cuisine is not selected, add it and show filled checkbox
                self.selectedCuisine.append(arrCuisine[indexPath.row][0])
            }
        }
        else if type == 1 {
            if arrEnviorment[indexPath.row][1] == "1"{
                arrEnviorment[indexPath.row][1] = "0"
            }
            else{
                arrEnviorment[indexPath.row][1] = "1"
            }
            tableView.reloadData()
            if let index = self.selectedEnviorment.firstIndex(of: arrEnviorment[indexPath.row][0]) {
                self.arrEnviorment.remove(at: index)
            } else {
                // Cuisine is not selected, add it and show filled checkbox
                self.selectedEnviorment.append(arrEnviorment[indexPath.row][0])
            }
        }
        else {
            if arrFeature[indexPath.row][1] == "1"{
                arrFeature[indexPath.row][1] = "0"
            }
            else{
                arrFeature[indexPath.row][1] = "1"
            }
            tableView.reloadData()
            if let index = self.selectedFeature.firstIndex(of: arrFeature[indexPath.row][0]) {
                self.selectedFeature.remove(at: index)
            } else {
                // Cuisine is not selected, add it and show filled checkbox
                self.selectedFeature.append(arrFeature[indexPath.row][0])
            }
        }
    }
}
