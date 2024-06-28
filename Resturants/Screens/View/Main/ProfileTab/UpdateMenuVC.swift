//
//  AccontVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class UpdateMenuVC: UIViewController, verifyPasswordDelegate, createAccntDelegate {
    func collectionData(type: Int) {
        <#code#>
    }
    
    func verified() {
        popup()
        passwordVerfied = true
    }
    
    //MARK: IBOUtlets
    @IBOutlet weak var txtAccnttype : UITextField!
    
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
    
    var profileModel                : UserProfileModel? = nil
    var passwordVerfied             : Bool              = false
    var type                                            = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapChangeAccntType(_ sender: UIButton){
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "VerifyPasswordVC") as? VerifyPasswordVC
        vc?.profileModel = self.profileModel
        vc?.delegate     = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func ontapCrntAccntType(_ sender: UIButton){
        if passwordVerfied {
            let actionClosure = { (action: UIAction) in
                self.txtAccnttype.text = action.title // Update text field with selected option title
                self.setupAccountTypes(action.title)
            }
            var menuChildren: [UIMenuElement] = []
            for meal in UserManager.shared.arrAccnt {
                menuChildren.append(UIAction(title: meal, handler: actionClosure))
            }
            sender.menu = UIMenu(options: .displayInline, children: menuChildren)
            sender.showsMenuAsPrimaryAction = true
        }
        else{
            self.showToast(message: "Please verify your account.", seconds: 2, clr: .red)
        }
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

//MARK: - Setup Profile {}
extension UpdateMenuVC {
    
    func onload() {
        removeNavBackbuttonTitle()
        self.navigationItem.title = "Edit or change account type"
    }
    
    func onAppear() {
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
