//
//  LoginViewController.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit
import FirebaseAuth


class LoginVC: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPsd  : UITextField!
    @IBOutlet weak var btnToglePsd  : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CrtAccnt), name: NSNotification.Name("CrtAccnt"), object: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        
        self.navigationController?.dismiss(animated: true)
    }
    
    @objc func CrtAccnt(){
        self.dismiss(animated: true)
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CreatAccntVC") as? CreatAccntVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func ontapLogin(_ sender: UIButton){
        
        login()
    }
    
    @IBAction func ontapToglePsd(_ sender: UIButton){
        if txtPsd.isSecureTextEntry == false {

            txtPsd.isSecureTextEntry = true
            btnToglePsd.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        else if txtPsd.isSecureTextEntry == true {

            txtPsd.isSecureTextEntry = false
            btnToglePsd.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    @IBAction func ontapForgot(_ sender: UIButton) {
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC
        self.navigationController?.present(vc!, animated: true)
    }
    
    @IBAction func ontapCrtAccnt(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CreatAccntVC") as? CreatAccntVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

//MARK: - Call Login {}
extension LoginVC {
    
    func login(){
        
        if "".isValidEmailRegex(txtEmail.text!){
            self.startAnimating()
            Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPsd.text!) { response, error in
                
                if error == nil {
                    self.stopAnimating()
                    print("user successfully login")
                    var id = Auth.auth().currentUser?.uid ?? ""
                    UserDefault.token = id
                    UserDefault.isAuthenticated = true
                    let vc = Constants.TabControllerStoryBoard.instantiateViewController(withIdentifier: "TabbarController") as? TabbarController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                else{
                    self.stopAnimating()
                    print(error?.localizedDescription ?? "")
                    self.showToast(message: error?.localizedDescription ?? "", seconds: 2, clr: .red)
                }
            }
        }
    }
}
