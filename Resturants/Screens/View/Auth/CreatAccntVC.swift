//
//  CreatAccntVC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit

protocol createAccntDelegate {
   
    func collectionData(arr: [String] , type: Int)
}

class CreatAccntVC: UIViewController , createAccntDelegate {
    func collectionData(arr: [String] , type: Int) {
        if type == 0{
            selectedCuisine    = arr
            CollectCuisine.reloadData()
        }
        else if type == 1{
            selectedEnviorment = arr
            CollectEnviorment.reloadData()
        }
        else{
            selectedFeature    = arr
            CollectFeature.reloadData()
        }
        
    }
    //MARK: - @IBOutlets
    @IBOutlet weak var txtAccnt           : UITextField!
    @IBOutlet weak var CollectCuisine     : UICollectionView!
    @IBOutlet weak var CollectEnviorment  : UICollectionView!
    @IBOutlet weak var CollectFeature     : UICollectionView!
    
    //MARK: - variables and Properties
    private var selectedCuisine   :[String]       = []
    private var selectedEnviorment:[String]       = []
    private var selectedFeature   :[String]       = []
    
    private var arrAccnt           = ["Restraurant", "Cafeteria", "Food Truck", " Hotels"]
    
    private var arrCuisine         = ["African", "American", "Asian", "Brazilian", "British", "Ethiopian", "European", "French", "From the Mediterranean", "Fusion/Crossover", "Greek", "Grilled", "Indian", "Italian", "Japanese", "Chinese", "Korean", "Latin American", "Lebanese", "Moroccan", "Mexican", "Oriental", "Pakistani", "Persian", "Peruvian", "Portuguese", "Swiss", "Scandinavian", "Spanish", "Steakhouse", "Swedish", "Somali", "Thai", "Traditional food", "Tunisian", "Turkish", "German", "Eastern European"]
    
    private var arrEnviorment      = ["Business dinner", "After work", "Brunch", "Wedding", "Buffet", "Central location", "Fantastic view", "Birthday", "Gastronomic", "Groups", "Hotel restaurant", "Tavern", "Live music", "With family","With friends", "Dinner cruise"," Modern food", "On the beach", "Raw food", "Street food", "Bachelor & bachelorette party", "Traditional", "Trendy", "Garden", "Outdoor seating", "By the sea", "By the water", "Wine bar Meals" , "Breakfast", "Brunch", "Lunch", "Dinner", "Dessert", "Coffe"]
    
    private var arrFeature         = ["Seating", "Reservations", "Takeout", "Delivery", "Buffet", "Accepts credit cards", "Outdoor seating", "Wheelchair accessible", "Highchairs available", "Free wifi", "Street parking", "Accepts American Express", "Dogs allowed", "Gift cards available", "Card payment only", "Cash only Specelize" ,  "Halal Options" , "Kosher options" , "Vegan options", "Vegetarian options", "Gluten-free options"]
        
    private var DetailsPicker       = UIPickerView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 150))
    var type                        = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onlaod()
    }
    
    @IBAction func ontapNextStep(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile2VC") as? CrtProfile2VC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//MARK: - Custom Implementation {}
extension CreatAccntVC {
    
    func onlaod(){
      
        setupViews()
    }
    func onAppear(){
        
    }
    func setupViews() {
        txtAccnt.inputView           = DetailsPicker
           
        DetailsPicker.delegate       = self
        DetailsPicker.dataSource     = self
        DetailsPicker.backgroundColor = .white
        
        CollectCuisine.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectCuisine.delegate      = self
        CollectCuisine.dataSource    = self
        CollectCuisine.register(AddDataCell.nib, forCellWithReuseIdentifier: AddDataCell.identifier)
        CollectCuisine.delegate      = self
        CollectCuisine.dataSource    = self
        
        CollectEnviorment.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectEnviorment.delegate   = self
        CollectEnviorment.dataSource = self
        CollectEnviorment.register(AddDataCell.nib, forCellWithReuseIdentifier: AddDataCell.identifier)
        CollectEnviorment.delegate   = self
        CollectEnviorment.dataSource = self
        
        CollectFeature.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectFeature.delegate      = self
        CollectFeature.dataSource    = self
        CollectFeature.register(AddDataCell.nib, forCellWithReuseIdentifier: AddDataCell.identifier)
        CollectFeature.delegate      = self
        CollectFeature.dataSource    = self
        
    }
   }

   //MARK: - Gender Picker View Setup {}
   extension CreatAccntVC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {

       func textFieldDidBeginEditing(_ textField: UITextField) {
           // Set the appropriate data source based on the active text field
           DetailsPicker.tag = textField.tag
           DetailsPicker.reloadAllComponents()
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           switch pickerView.tag {
           case 0:
               return arrAccnt.count
           default:
               return 0
           }
       }

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           switch pickerView.tag {
           case 0:
               return arrAccnt[row]
           default:
               return nil
           }
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           let selectedValue: String
           switch pickerView.tag {
           case 0:
               selectedValue        = arrAccnt[row]
               txtAccnt.text        = selectedValue
               
           default:
               return
           }
           pickerView.resignFirstResponder()
       }
   }

//MARK: - Collection View Setup {}
extension CreatAccntVC: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CollectCuisine {
            return selectedCuisine.count == 0 ? 1 : selectedCuisine.count
        }
        else if collectionView == CollectEnviorment {
            return selectedEnviorment.count == 0 ? 1 : selectedEnviorment.count
        }
        else {
            return selectedFeature.count == 0 ? 1 : selectedFeature.count
        }
        
    }
    @objc func onTapCui(sender: UIButton){
        selectedCuisine.remove(at: sender.tag)
        CollectCuisine.reloadData()
    }
    @objc func onTapEnvior(sender: UIButton){
        selectedEnviorment.remove(at: sender.tag)
        CollectEnviorment.reloadData()
    }
    @objc func onTapIden(sender: UIButton){
        selectedFeature.remove(at: sender.tag)
        CollectFeature.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CollectCuisine {
            if selectedCuisine.count != 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
                cell.lbl.text = selectedCuisine[indexPath.row]
                cell.btn.addTarget(self, action:#selector(onTapCui(sender:)), for: .touchUpInside)
                cell.btn.tag = indexPath.row
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddDataCell.identifier, for: indexPath) as! AddDataCell
                return cell
            }
        }
        else if collectionView == CollectEnviorment {
            if selectedEnviorment.count != 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
                cell.lbl.text = selectedEnviorment[indexPath.row]
                cell.btn.addTarget(self, action:#selector(onTapEnvior(sender:)), for: .touchUpInside)
                cell.btn.tag = indexPath.row
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddDataCell.identifier, for: indexPath) as! AddDataCell
                return cell
            }
        }
        else {
            if selectedFeature.count != 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
                cell.lbl.text = selectedFeature[indexPath.row]
                cell.btn.addTarget(self, action:#selector(onTapIden(sender:)), for: .touchUpInside)
                cell.btn.tag = indexPath.row
                return cell
            }
            else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddDataCell.identifier, for: indexPath) as! AddDataCell
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CollectCuisine {
            if selectedCuisine.count != 0{
                
            }
            else{
                let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
                vc.delegate = self
                vc.type     = 0
                self.type   = 0
                self.navigationController?.present(vc, animated: true)
            }
        }
        else if collectionView == CollectEnviorment {
          
            if selectedEnviorment.count != 0{
                
            }
            else{
                let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
                vc.type     = 1
                self.type   = 1
                vc.delegate = self
                self.navigationController?.present(vc, animated: true)
            }
        }
        else {
            if selectedFeature.count != 0{
                
            }
            else{
                let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
                vc.type     = 2
                self.type   = 2
                vc.delegate = self
                self.navigationController?.present(vc, animated: true)
            }
        }
    }
}
