//
//  NewPsdVC.swift
//  Resturants
//
//  Created by Coder Crew on 16/04/2024.
//

import UIKit

class NewPsdVC: UIViewController {

    //MARK: - IBOUTLETS
   @IBOutlet weak var txtPsd       : UITextField!
   @IBOutlet weak var btnToglePsd  : UIButton!
   @IBOutlet weak var txtConfrmPsd : UITextField!
   @IBOutlet weak var btnTogleConPsd  : UIButton!
   @IBOutlet weak var img8Charac   : UIImageView!
   @IBOutlet weak var img1Upper    : UIImageView!
   @IBOutlet weak var img1Lower    : UIImageView!
   @IBOutlet weak var img1number   : UIImageView!
    
    
    var checkvalidPsd: Bool        = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
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
    @IBAction func ontapTogleConPsd(_ sender: UIButton){
        if txtConfrmPsd.isSecureTextEntry == false {
            txtConfrmPsd.isSecureTextEntry = true
            btnTogleConPsd.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        else if txtConfrmPsd.isSecureTextEntry == true {
            txtConfrmPsd.isSecureTextEntry = false
            btnTogleConPsd.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
}

//MARK: - Cutom Implementation {}
extension NewPsdVC {
    
    func onLoad() {
        setupView()
    }
    func onAppear() {
        removeNavBackbuttonTitle()
        self.navigationItem.title  = "New Password"
    }
    func setupView() {
        txtPsd.delegate                          = self
        txtConfrmPsd.delegate                    = self
    }
}

//MARK: - Textfield Validation {}
extension NewPsdVC: UISearchTextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        validateTextField(updatedText)
        return true
    }
    func validateTextField(_ txtfld: String) {
        if txtfld.count >= 8 {
            updateValidationStatus(true, message: "8 characters done", image: img8Charac)
        } else {
            updateValidationStatus(false, message: "At least 8 characters required", image: img8Charac)
        }
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        updateValidationStatus(uppercasePredicate.evaluate(with: txtfld),
                                message: "Minimum 1 uppercase letter done",
                                image: img1Upper)
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        updateValidationStatus(lowercasePredicate.evaluate(with: txtfld),
                                message: "Minimum 1 lowercase letter done",
                                image: img1Lower)
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        updateValidationStatus(numberPredicate.evaluate(with: txtfld),
                                message: "Minimum 1 number done",
                                image: img1number)
        if uppercasePredicate.evaluate(with: txtfld) && lowercasePredicate.evaluate(with: txtfld) && numberPredicate.evaluate(with: txtfld) && txtfld.count >= 8 {
             checkvalidPsd = true
        }
    }
    func updateValidationStatus(_ isValid: Bool, message: String, image: UIImageView) {
        print(message)
        if isValid {
            image.image = UIImage(systemName: "checkmark.circle")
            image.tintColor = UIColor.ColorDarkGreen
        } else {
            image.image = UIImage(systemName: "multiply.circle")
            image.tintColor = .red
        }
    }
}
