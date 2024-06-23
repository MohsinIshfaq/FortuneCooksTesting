//
//  AccontVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class UpdateMenuVC: UIViewController {
    
    //MARK: IBOUtlets
    @IBOutlet weak var txtAccnttype : UITextField!
    @IBOutlet weak var txtCuisine   : UITextField!
    @IBOutlet weak var txtEnviorment: UITextField!
    @IBOutlet weak var txtMeals     : UITextField!
    @IBOutlet weak var txtFeature   : UITextField!
    @IBOutlet weak var txtSpecial   : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapChangeAccntType(_ sender: UIButton){
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ChangePsdVC") as? ChangePsdVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func ontapCrntAccntType(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtAccnttype.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.arrAccnt {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapTypeofCuzn(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtCuisine.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.listCuisine {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapEnviorment(_ sender: UIButton){
        
        let actionClosure = { (action: UIAction) in
            self.txtEnviorment.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.listEnviorment {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapMeal(_ sender: UIButton){
        
        let actionClosure = { (action: UIAction) in
            self.txtMeals.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.listMeals {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapFeature(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtMeals.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.listFeature {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapSpecialize(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtSpecial.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.listSpeacials {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
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
}
