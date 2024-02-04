//
//  CrtProfile2VC.swift
//  Resturants
//
//  Created by shah on 18/01/2024.
//

import UIKit

class CrtProfile2VC: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var txtYear  : UITextField!
    
    //MARK: - variables and Properties
    private var arrDate         = Array(1...31)
    private var arrmonths       = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    private var birthYears      = Array(1950...2024)
    
    private var genderPicker    = UIPickerView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 150))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onlaod()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    @IBAction func ontapNextStep(_ sender: UIButton){
        
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "CrtProfile3VC") as? CrtProfile3VC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//MARK: - Custom Implementation {}
extension CrtProfile2VC {
    
    func onlaod(){
      
        setupView()
    }
    func onAppear(){
        
    }
    func setupView() {
        txtYear.inputView  = genderPicker
        genderPicker.delegate   = self
        genderPicker.dataSource = self
        txtYear.delegate        = self
        genderPicker.backgroundColor = .white
    }
   }

   //MARK: - Gender Picker View Setup
extension CrtProfile2VC: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    // ... (existing code)

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return arrDate.count
        } else if component == 1 {
            return arrmonths.count
        } else {
            return birthYears.count
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(arrDate[row])
        } else if component == 1 {
            return arrmonths[row]
        } else {
            return String(birthYears[row])
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedDay = String(arrDate[pickerView.selectedRow(inComponent: 0)])
        let selectedMonth = arrmonths[pickerView.selectedRow(inComponent: 1)]
        let selectedYear = String(birthYears[pickerView.selectedRow(inComponent: 2)])

        let selectedDate = "\(selectedDay) / \(selectedMonth) / \(selectedYear)"
        txtYear.text = selectedDate
    }
}
