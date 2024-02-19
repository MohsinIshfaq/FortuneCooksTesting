//
//  CreatAccntVC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit

protocol createAccntDelegate {
   
    func collectionData(type: Int)
}

class CreatAccntVC: UIViewController , createAccntDelegate {
    func collectionData(type: Int) {
        if type == 0{
            UserManager.shared.selectedCuisine.removeAll()
            CollectCuisine.reloadData()
        }
        else if type == 1{
            UserManager.shared.selectedEnviorment.removeAll()
            CollectEnviorment.reloadData()
        }
        else if type == 2{
            UserManager.shared.selectedFeature.removeAll()
            CollectFeature.reloadData()
        }
        else if type == 3{
            UserManager.shared.selectedMeals.removeAll()
            CollectMeal.reloadData()
        }
        else{
            UserManager.shared.selectedSpecial.removeAll()
            CollectSpecial.reloadData()
        }
    }
    //MARK: - @IBOutlets
    @IBOutlet weak var txtAccnt           : UITextField!
    @IBOutlet weak var CollectCuisine     : UICollectionView!
    @IBOutlet weak var CollectEnviorment  : UICollectionView!
    @IBOutlet weak var CollectFeature     : UICollectionView!
    @IBOutlet weak var CollectMeal        : UICollectionView!
    @IBOutlet weak var CollectSpecial     : UICollectionView!
    @IBOutlet weak var btnAddCusion       : UIButton!
    @IBOutlet weak var btnEnviorment      : UIButton!
    @IBOutlet weak var btnFeature         : UIButton!
    @IBOutlet weak var btnMeal            : UIButton!
    @IBOutlet weak var btnSpecial         : UIButton!
    @IBOutlet weak var btnTopAddCusion    : UIButton!
    @IBOutlet weak var btnTopEnviorment   : UIButton!
    @IBOutlet weak var btnTopFeature      : UIButton!
    @IBOutlet weak var btnTopMeal         : UIButton!
    @IBOutlet weak var btnTopSpecial      : UIButton!
    
    @IBOutlet weak var stackCuisine       : UIStackView!
    @IBOutlet weak var stackEnviorment    : UIStackView!
    @IBOutlet weak var stackFeature       : UIStackView!
    @IBOutlet weak var stackMeal          : UIStackView!
    @IBOutlet weak var stackSpeaical      : UIStackView!
    
    
    //MARK: - variables and Properties
    private var arrAccnt                                  = [
        "Private person",
        "Content Creator",
        "Restaurant",
        "Cafeteria",
        "Grocery_store",
        "Wholesaler",
        "Bakery",
        "Food_producer",
        "Beverage_manufacturer",
        "Food_truck",
        "Hotel"
    ]
    
    var type                                              = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onlaod()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapNextStep(_ sender: UIButton){
        
        UserManager.shared.selectedAccountType    = self.txtAccnt.text!
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile2VC") as? CrtProfile2VC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func ontapAccnt(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtAccnt.text = action.title // Update text field with selected option title
            self.setupAccountTypes(action.title)
        }
        var menuChildren: [UIMenuElement] = []
        for meal in arrAccnt {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    @IBAction func ontapAddCuision(_ sender: UIButton){
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        vc.delegate = self
        vc.type     = 0
        self.type   = 0
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func ontapEnviorment(_ sender: UIButton){
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        vc.type     = 1
        self.type   = 1
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func ontapFeature(_ sender: UIButton){
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        vc.type     = 2
        self.type   = 2
        vc.delegate = self
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func onTapMeals(_ sender: UIButton) {
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        vc.delegate = self
        vc.type     = 3
        self.type   = 3
        self.navigationController?.present(vc, animated: true)
    }
    @IBAction func onTapSpecail(_ sender: UIButton) {
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionVC
        vc.delegate = self
        vc.type     = 4
        self.type   = 4
        self.navigationController?.present(vc, animated: true)
    }

}

//MARK: - Custom Implementation {}
extension CreatAccntVC {
    
    func onlaod(){
        
        setupViews()
        
    }
    func onAppear(){
        removeNavBackbuttonTitle()
        self.navigationItem.title  = "Create Account"
    }
    func setupViews() {
        
        CollectCuisine.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectCuisine.delegate      = self
        CollectCuisine.dataSource    = self
        
        CollectEnviorment.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectEnviorment.delegate   = self
        CollectEnviorment.dataSource = self
        
        CollectFeature.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectFeature.delegate      = self
        CollectFeature.dataSource    = self
        
        CollectMeal.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectMeal.delegate         = self
        CollectMeal.dataSource       = self
        
        CollectSpecial.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectSpecial.delegate      = self
        CollectSpecial.dataSource    = self
    }
    
    func setupAccountTypes(_ string : String){
        
        switch string {
        case "Private person" , "Content Creator" :
            stackCuisine.isHidden     = true
            stackEnviorment.isHidden  = true
            stackFeature.isHidden     = true
            stackMeal.isHidden        = true
            stackSpeaical.isHidden    = true
        case "Restaurant" , "Food_truck" , "Hotel":
            stackCuisine.isHidden     = false
            stackEnviorment.isHidden  = false
            stackFeature.isHidden     = false
            stackMeal.isHidden        = false
            stackSpeaical.isHidden    = false
        case "Cafeteria":
            stackCuisine.isHidden     = true
            stackEnviorment.isHidden  = false
            stackFeature.isHidden     = false
            stackMeal.isHidden        = false
            stackSpeaical.isHidden    = false
        default:
            print("default")
            stackCuisine.isHidden     = false
            stackEnviorment.isHidden  = false
            stackFeature.isHidden     = false
            stackMeal.isHidden        = false
            stackSpeaical.isHidden    = false
        }
    }
}

//MARK: - Collection View Setup {}
extension CreatAccntVC: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CollectCuisine {
            let totalCount = UserManager.shared.arrCuisine.reduce(0) { (totalCount, array) in
                // Check if the second element of the array is equal to 1
                return totalCount + (array[1] == "1" ? 1 : 0)
            }
            if totalCount == 0 {
                self.btnAddCusion.isHidden = false
                self.btnTopAddCusion.isHidden = true
                return 0
            }
            else{
                self.btnAddCusion.isHidden = true
                self.btnTopAddCusion.isHidden = false
               return totalCount
            }
        }
        else if collectionView == CollectEnviorment {
            let totalCount = UserManager.shared.arrEnviorment.reduce(0) { (totalCount, array) in
                // Check if the second element of the array is equal to 1
                return totalCount + (array[1] == "1" ? 1 : 0)
            }
            if totalCount == 0 {
                self.btnEnviorment.isHidden = false
                self.btnTopEnviorment.isHidden = true
                return 0
            }
            else{
                self.btnEnviorment.isHidden = true
                self.btnTopEnviorment.isHidden = false
               return totalCount
            }
        }
        else if collectionView == CollectFeature {
            let totalCount = UserManager.shared.arrFeature.reduce(0) { (totalCount, array) in
                // Check if the second element of the array is equal to 1
                return totalCount + (array[1] == "1" ? 1 : 0)
            }
            if totalCount == 0 {
                self.btnFeature.isHidden = false
                self.btnTopFeature.isHidden = true
                return 0
            }
            else{
                self.btnFeature.isHidden = true
                self.btnTopFeature.isHidden = false
               return totalCount
            }
        }
        else if collectionView == CollectMeal {
            let totalCount = UserManager.shared.arrMeals.reduce(0) { (totalCount, array) in
                // Check if the second element of the array is equal to 1
                return totalCount + (array[1] == "1" ? 1 : 0)
            }
            if totalCount == 0 {
                self.btnMeal.isHidden = false
                self.btnTopMeal.isHidden = true
                return 0
            }
            else{
                self.btnMeal.isHidden = true
                self.btnTopMeal.isHidden = false
               return totalCount
            }
        }
        else{
            let totalCount = UserManager.shared.arrSpeacials.reduce(0) { (totalCount, array) in
                // Check if the second element of the array is equal to 1
                return totalCount + (array[1] == "1" ? 1 : 0)
            }
            if totalCount == 0 {
                self.btnSpecial.isHidden = false
                self.btnTopSpecial.isHidden = true
                return 0
            }
            else{
                self.btnSpecial.isHidden = true
                self.btnTopSpecial.isHidden = false
               return totalCount
            }
        }
    }
    @objc func onTapCui(sender: UIButton){
        UserManager.shared.arrCuisine[sender.tag][1] = "0"
       // selectedCuisine.remove(at: sender.tag)
        CollectCuisine.reloadData()
    }
    @objc func onTapEnvior(sender: UIButton){
        UserManager.shared.arrEnviorment[sender.tag][1] = "0"
       // selectedEnviorment.remove(at: sender.tag)
        CollectEnviorment.reloadData()
    }
    @objc func onTapIden(sender: UIButton){
        UserManager.shared.arrFeature[sender.tag][1] = "0"
       // selectedFeature.remove(at: sender.tag)
        CollectFeature.reloadData()
    }
    @objc func onTapMeal(sender: UIButton){
        UserManager.shared.arrMeals[sender.tag][1] = "0"
       // selectedFeature.remove(at: sender.tag)
        CollectMeal.reloadData()
    }
    
    @objc func onTapSpecial(sender: UIButton){
        UserManager.shared.arrSpeacials[sender.tag][1] = "0"
       // selectedFeature.remove(at: sender.tag)
        CollectSpecial.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CollectCuisine {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            if UserManager.shared.arrCuisine[indexPath.row][1] == "1" {
                cell.lbl.text = UserManager.shared.arrCuisine[indexPath.row][0]
                UserManager.shared.selectedCuisine.append(UserManager.shared.arrCuisine[indexPath.row][0])
                cell.btn.addTarget(self, action:#selector(onTapCui(sender:)), for: .touchUpInside)
                cell.btn.tag = indexPath.row
            }
            return cell
        }
        else if collectionView == CollectEnviorment {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            
            if UserManager.shared.arrEnviorment[indexPath.row][1] == "1" {
                cell.lbl.text = UserManager.shared.arrEnviorment[indexPath.row][0]
                UserManager.shared.selectedEnviorment.append(UserManager.shared.arrEnviorment[indexPath.row][0])
            }
            cell.btn.addTarget(self, action:#selector(onTapEnvior(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            return cell
        }
        else if collectionView == CollectFeature {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            if UserManager.shared.arrFeature[indexPath.row][1] == "1" {
                cell.lbl.text = UserManager.shared.arrFeature[indexPath.row][0]
                UserManager.shared.selectedFeature.append(UserManager.shared.arrFeature[indexPath.row][0])
            }
            cell.btn.addTarget(self, action:#selector(onTapIden(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            return cell
        }
        else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            if UserManager.shared.arrSpeacials[indexPath.row][1] == "1" {
                cell.lbl.text = UserManager.shared.arrSpeacials[indexPath.row][0]
                UserManager.shared.selectedSpecial.append(UserManager.shared.arrSpeacials[indexPath.row][0])
            }
            cell.btn.addTarget(self, action:#selector(onTapSpecial(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            return cell
        }
    }
}
