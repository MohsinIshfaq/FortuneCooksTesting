//
//  ResetPasswordVC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit
import FirebaseAuth

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var txtEmail  : UITextField!
    @IBOutlet weak var stackMail : UIStackView!
    @IBOutlet weak var lblReset  : UILabel!
    @IBOutlet weak var lblDescrip  : UILabel!
    @IBOutlet weak var btnSend   : UIButton!
    @IBOutlet weak var ConstraintTop   : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapDone(_ sender: UIButton){
        
        forgotPsd()
    }
}

//MARK: - Call Login {}
extension ResetPasswordVC {
    
    func forgotPsd(){
        
        if "".isValidEmailRegex(txtEmail.text!){
            self.startAnimating()
            Auth.auth().sendPasswordReset(withEmail: self.txtEmail.text!) { error in
                
                if error == nil {
                    self.stopAnimating()
                    self.btnSend.setTitle("Resend", for: .normal)
                    self.lblReset.text = "Email Sent!"
                    self.lblDescrip.text  = "We have sent recovery link to your email."
                   // self.showAlertWith(title: "FortuneCooks", message: "Kindly check your email for the password reset instructions.")
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
