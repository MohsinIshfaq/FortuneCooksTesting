//
//  CrtProfile1VC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit

class CrtProfile1VC: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var txtAccntType  : UITextField!
    
    //MARK: - variables and Properties
    private var arrAccounts          = ["Private person",
                                        "Content Creator",
                                        "Restaurant",
                                        "Grocery store",
                                        "Cafeteria",
                                       "Wholesaler",
                                        "Bakery",
                                        "Food producer",
                                        "Beverage manufacturer",
                                        "Food truck",
                                        "Hotel"]
    
    private var AccntPicker          = UIPickerView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onlaod()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func ontapNextStep(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile2VC") as? CrtProfile2VC
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

//MARK: - Custom Implementation {}
extension CrtProfile1VC {
    
    func onlaod(){
      
        setupView()
    }
    func onAppear(){
        
    }
    func setupView() {
        txtAccntType.inputView  = AccntPicker
        AccntPicker.delegate    = self
        AccntPicker.backgroundColor = .white
    }
   }

   //MARK: - Gender Picker View Setup
   extension CrtProfile1VC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

       func textFieldDidBeginEditing(_ textField: UITextField) {
           // Set the appropriate data source based on the active text field
           AccntPicker.tag = textField.tag
           AccntPicker.reloadAllComponents()
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return arrAccounts.count
       }

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
          return arrAccounts[row]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
          var selectedValue = arrAccounts[row]
           txtAccntType.text  = selectedValue
           pickerView.resignFirstResponder()
       }
   }
