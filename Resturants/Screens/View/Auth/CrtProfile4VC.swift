//
//  CrtProfile4VC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit

class CrtProfile4VC: UIViewController {
    
     //MARK: - IBOUTLETS
    @IBOutlet weak var txtPsd       : UITextField!
    @IBOutlet weak var txtConfrmPsd : UITextField!
    @IBOutlet weak var img8Charac   : UIImageView!
    @IBOutlet weak var img1Upper    : UIImageView!
    @IBOutlet weak var img1Lower    : UIImageView!
    @IBOutlet weak var img1number   : UIImageView!
    
    @IBOutlet weak var imgTrms      : UIImageView!
    @IBOutlet weak var imgPrivacy   : UIImageView!
    
    //MARK: - PROPERTIES
    let gestureTrms       = UITapGestureRecognizer(target: self, action:#selector(gestureTrms(_:)))
    let gesturePrivacy    = UITapGestureRecognizer(target: self, action:#selector(gesturePrivacy(_:)))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    @IBAction func ontapNextStep(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile5VC") as? CrtProfile5VC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func gestureTrms(_ gesture:UITapGestureRecognizer){
        
        if imgTrms.image      == UIImage(systemName: "checkmark.square") {
            imgTrms.image      = UIImage(systemName: "square")
        }
        else{
            imgTrms.image      = UIImage(systemName: "checkmark.square")
        }
    }
    @objc func gesturePrivacy(_ gesture:UITapGestureRecognizer){
        
        if imgPrivacy.image      == UIImage(systemName: "checkmark.square") {
            imgPrivacy.image      = UIImage(systemName: "square")
        }
        else{
            imgPrivacy.image      = UIImage(systemName: "checkmark.square")
        }
    }

}

//MARK: - Cutom Implementation {}
extension CrtProfile4VC {
    
    func onLoad() {
      
        setupView()
    }
    
    func onAppear() {
        
    }
    
    func setupView() {
        
        txtPsd.delegate                          = self
        self.gestureTrms.numberOfTouchesRequired = 1
        self.gestureTrms.numberOfTapsRequired    = 1
        imgTrms.addGestureRecognizer(self.gestureTrms)
        imgTrms.isUserInteractionEnabled         = true
        
        self.gesturePrivacy.numberOfTouchesRequired = 1
        self.gesturePrivacy.numberOfTapsRequired    = 1
        imgPrivacy.addGestureRecognizer(self.gesturePrivacy)
        imgPrivacy.isUserInteractionEnabled         = true
    }
}
//MARK: - Textfield Validation {}
extension CrtProfile4VC: UISearchTextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the updated text field content
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        // Use your validation function here
        validateTextField(updatedText)
        // Return true to allow the text field to be updated
        return true
    }
    
    func validateTextField(_ txtfld: String) {
        // Check if the text field contains at least 8 characters
        if txtfld.count >= 8 {
            updateValidationStatus(true, message: "8 characters done", image: img8Charac)
        } else {
            updateValidationStatus(false, message: "At least 8 characters required", image: img8Charac)
        }

        // Check if the text field contains at least 1 uppercase letter
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        updateValidationStatus(uppercasePredicate.evaluate(with: txtfld),
                                message: "Minimum 1 uppercase letter done",
                                image: img1Upper)

        // Check if the text field contains at least 1 lowercase letter
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        updateValidationStatus(lowercasePredicate.evaluate(with: txtfld),
                                message: "Minimum 1 lowercase letter done",
                                image: img1Lower)

        // Check if the text field contains at least 1 number
        let numberPredicate = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
        updateValidationStatus(numberPredicate.evaluate(with: txtfld),
                                message: "Minimum 1 number done",
                                image: img1number)
    }

    // Helper function to update validation status
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
