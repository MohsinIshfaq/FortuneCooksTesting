//
//  UpdateProfileVC.swift
//  Resturants
//
//  Created by Coder Crew on 23/04/2024.
//

import UIKit

class UpdateProfileVC: UIViewController , TagPeopleDelegate{
    func reload() {
        collectTagPeople.reloadData()
    }
    
    //MARK: - IBOUtlet
    @IBOutlet weak var txtViewBio       : UITextView!
    @IBOutlet weak var collectTagPeople : UICollectionView!
    @IBOutlet weak var txtChannelNm     : UITextField!
    @IBOutlet weak var txtAddEmail      : UITextField!
    @IBOutlet weak var txtAddWebsite    : UITextField!
    @IBOutlet weak var txtAddPhoneNUmbr : UITextField!
    @IBOutlet weak var txtAddAddressLoc : UITextField!
    @IBOutlet weak var txtZipCode       : UITextField!
    @IBOutlet weak var txtCity          : UITextField!
    
    @IBOutlet weak var stackMonday      : UIStackView!
    @IBOutlet weak var stackTuesday     : UIStackView!
    @IBOutlet weak var stackWednesday   : UIStackView!
    @IBOutlet weak var stackThursday    : UIStackView!
    @IBOutlet weak var stackFriday      : UIStackView!
    @IBOutlet weak var stackSaturday    : UIStackView!
    @IBOutlet weak var stackSunday      : UIStackView!
    
    //MARK: - Variables and Properties
    let placeholder                        = "Enter Bio..."
    let placeholderColor                   = UIColor.lightGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    @IBAction func ontapScheduleSwitch(_ sender: UISwitch){
        
        switch sender.tag {
        case 0:
            stackMonday.isHidden = switchStack(sender: sender.isOn)
            break
        case 1:
            stackTuesday.isHidden = switchStack(sender: sender.isOn)
            break
        case 2:
            stackWednesday.isHidden = switchStack(sender: sender.isOn)
            break
        case 3:
            stackThursday.isHidden = switchStack(sender: sender.isOn)
            break
        case 4: 
            stackFriday.isHidden = switchStack(sender: sender.isOn)
            break
        case 5: 
            stackSaturday.isHidden = switchStack(sender: sender.isOn)
            break
        default: break
        }
    }
    
    @IBAction func ontapTagPeople(_ sender: UIButton) {
        
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
        vc?.delegate = self
        self.present(vc!, animated: true)
    }
    
    @IBAction func ontapAccountType(_ sender: UIButton){
        
    }
    
    @IBAction func ontapSelectDay(_ sender: UIButton){
        
    }
    
    @IBAction func ontapOpeningtime(_ sender: UIButton){
        
    }
    
    @IBAction func ontapClosingTime(_ sender: UIButton){
        
    }
    
    @IBAction func ontapOpeningMidday(_ sender: UIButton){
        
    }
    
    @IBAction func ontapClosingMidday(_ sender: UIButton){
        
    }
}

//MARK: - Setup Profile {}
extension UpdateProfileVC {
   
    func onload() {
        removeNavBackbuttonTitle()
        txtViewBio.delegate   = self
        setupPlaceholder()
        setupView()
    }
    
    func onAppear() {
    }
    
    func setupPlaceholder() {
        txtViewBio.text      = placeholder
        txtViewBio.textColor = placeholderColor
    }
    
    func setupView() {
        collectTagPeople.register(TagPeopleCCell.nib, forCellWithReuseIdentifier: TagPeopleCCell.identifier)
        collectTagPeople.delegate   = self
        collectTagPeople.dataSource = self

    }
    
    func switchStack(sender: Bool) -> Bool {
        if sender {
            return false
        }
        else{
            return true
        }
    }
}

//MARK: - Collection View Setup {}
extension UpdateProfileVC: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.totalTagPeople
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagPeopleCCell.identifier, for: indexPath) as! TagPeopleCCell
        return cell
    }
}

// MARK: - UITextViewDelegate {}
extension UpdateProfileVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text      = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setupPlaceholder()
        }
    }
}
