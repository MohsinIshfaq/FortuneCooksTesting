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
            arrSelectedCusisine.removeAll()
            for i in 0..<UserManager.shared.arrCuisine.count{
                if UserManager.shared.arrCuisine[i][1] == "1" {
                    self.arrSelectedCusisine.append(UserManager.shared.arrCuisine[i][0])
                }
            }
            CollectCuisine.reloadData()
        }
        else if type == 1{
            UserManager.shared.selectedEnviorment.removeAll()
            arrSelectedEnviorment.removeAll()
            for i in 0..<UserManager.shared.arrEnviorment.count{
                if UserManager.shared.arrEnviorment[i][1] == "1" {
                    self.arrSelectedEnviorment.append(UserManager.shared.arrEnviorment[i][0])
                }
            }
            CollectEnviorment.reloadData()
        }
        else if type == 2{
            UserManager.shared.selectedFeature.removeAll()
            arrSelectedFeature.removeAll()
            for i in 0..<UserManager.shared.arrFeature.count{
                if UserManager.shared.arrFeature[i][1] == "1" {
                    self.arrSelectedFeature.append(UserManager.shared.arrFeature[i][0])
                }
            }
            CollectFeature.reloadData()
        }
        else if type == 3{
            UserManager.shared.selectedMeals.removeAll()
            arrSelectedMeals.removeAll()
            for i in 0..<UserManager.shared.arrMeals.count{
                if UserManager.shared.arrMeals[i][1] == "1" {
                    self.arrSelectedMeals.append(UserManager.shared.arrMeals[i][0])
                }
            }
            CollectMeal.reloadData()
        }
        else{
            UserManager.shared.selectedSpecial.removeAll()
            arrSelectedSpecial.removeAll()
            for i in 0..<UserManager.shared.arrSpeacials.count{
                if UserManager.shared.arrSpeacials[i][1] == "1" {
                    self.arrSelectedSpecial.append(UserManager.shared.arrSpeacials[i][0])
                }
            }
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
    var type                              = -1
    var arrSelectedCusisine : [String]    = []
    var arrSelectedEnviorment : [String]  = []
    var arrSelectedMeals    : [String]    = []
    var arrSelectedFeature  : [String]    = []
    var arrSelectedSpecial  : [String]    = []
    
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
        for meal in UserManager.shared.arrAccnt {
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
        self.navigationController!.removeBackground()
        self.navigationItem.title  = "Create Account"
    }
    
    private func createLeftAlignedLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .estimated(40),
            heightDimension: .absolute(35)))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)),
          subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 20, bottom: 0, trailing: 20)
        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top)
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
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
            if arrSelectedCusisine.count == 0 {
                self.btnAddCusion.isHidden = false
                self.btnTopAddCusion.isHidden = true
                return 0
            }
            else{
                self.btnAddCusion.isHidden = true
                self.btnTopAddCusion.isHidden = false
                return arrSelectedCusisine.count
            }
        }
        else if collectionView == CollectEnviorment {
            if arrSelectedEnviorment.count == 0 {
                self.btnEnviorment.isHidden = false
                self.btnTopEnviorment.isHidden = true
                return 0
            }
            else{
                self.btnEnviorment.isHidden = true
                self.btnTopEnviorment.isHidden = false
               return arrSelectedEnviorment.count
            }
        }
        else if collectionView == CollectFeature {
            if arrSelectedFeature.count == 0 {
                self.btnFeature.isHidden = false
                self.btnTopFeature.isHidden = true
                return 0
            }
            else{
                self.btnFeature.isHidden = true
                self.btnTopFeature.isHidden = false
                return arrSelectedFeature.count
            }
        }
        else if collectionView == CollectMeal {
            if arrSelectedMeals.count == 0 {
                self.btnMeal.isHidden = false
                self.btnTopMeal.isHidden = true
                return 0
            }
            else{
                self.btnMeal.isHidden = true
                self.btnTopMeal.isHidden = false
               return arrSelectedMeals.count
            }
        }
        else{
            if arrSelectedSpecial.count == 0 {
                self.btnSpecial.isHidden = false
                self.btnTopSpecial.isHidden = true
                return 0
            }
            else{
                self.btnSpecial.isHidden = true
                self.btnTopSpecial.isHidden = false
               return arrSelectedSpecial.count
            }
        }
    }
    @objc func onTapCui(sender: UIButton){
        for i in 0..<UserManager.shared.arrCuisine.count{
            if UserManager.shared.arrCuisine[i][0] == arrSelectedCusisine[sender.tag] {
                UserManager.shared.arrCuisine[i][1]  = "0"
            }
        }
        UserManager.shared.selectedCuisine.removeAll()
        arrSelectedCusisine.remove(at: sender.tag)
        CollectCuisine.reloadData()
    }
    @objc func onTapEnvior(sender: UIButton){
        for i in 0..<UserManager.shared.arrEnviorment.count{
            if UserManager.shared.arrEnviorment[i][0] == arrSelectedEnviorment[sender.tag] {
                UserManager.shared.arrEnviorment[i][1]  = "0"
            }
        }
        UserManager.shared.selectedEnviorment.removeAll()
        arrSelectedEnviorment.remove(at: sender.tag)
        CollectEnviorment.reloadData()
    }
    @objc func onTapIden(sender: UIButton){
        for i in 0..<UserManager.shared.arrFeature.count{
            if UserManager.shared.arrFeature[i][0] == arrSelectedFeature[sender.tag] {
                UserManager.shared.arrFeature[i][1]  = "0"
            }
        }
        UserManager.shared.selectedFeature.removeAll()
        arrSelectedFeature.remove(at: sender.tag)
        CollectFeature.reloadData()
    }
    @objc func onTapMeal(sender: UIButton){
        for i in 0..<UserManager.shared.arrMeals.count{
            if UserManager.shared.arrMeals[i][0] == arrSelectedMeals[sender.tag] {
                UserManager.shared.arrFeature[i][1]  = "0"
            }
        }
        UserManager.shared.selectedMeals.removeAll()
        arrSelectedMeals.remove(at: sender.tag)
        CollectMeal.reloadData()
    }
    @objc func onTapSpecial(sender: UIButton){
        for i in 0..<UserManager.shared.arrSpeacials.count{
            if UserManager.shared.arrSpeacials[i][0] == arrSelectedSpecial[sender.tag] {
                UserManager.shared.arrSpeacials[i][1]  = "0"
            }
        }
        UserManager.shared.selectedSpecial.removeAll()
        arrSelectedSpecial.remove(at: sender.tag)
        CollectSpecial.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CollectCuisine {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            
            cell.lbl.text = arrSelectedCusisine[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapCui(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedCuisine.append(arrSelectedCusisine[indexPath.row])
            return cell
        }
        else if collectionView == CollectEnviorment {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            
            cell.lbl.text = arrSelectedEnviorment[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapEnvior(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedEnviorment.append(arrSelectedEnviorment[indexPath.row])
            return cell
        }
        else if collectionView == CollectFeature {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            cell.lbl.text = arrSelectedFeature[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapIden(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedFeature.append(arrSelectedFeature[indexPath.row])
            return cell
        }
        else if collectionView == CollectMeal {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            cell.lbl.text = arrSelectedMeals[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapMeal(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedMeals.append(arrSelectedMeals[indexPath.row])
            return cell
        }
        else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            cell.lbl.text = arrSelectedSpecial[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapSpecial(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedSpecial.append(arrSelectedSpecial[indexPath.row])
            return cell
        }
    }
}
