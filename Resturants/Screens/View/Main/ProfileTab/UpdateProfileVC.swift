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
    @IBOutlet weak var txtAccntType     : UITextField!
    
    @IBOutlet weak var stackMonday      : UIStackView!
    @IBOutlet weak var lblMonday        : UILabel!
    @IBOutlet weak var stackTuesday     : UIStackView!
    @IBOutlet weak var lblTuesday       : UILabel!
    @IBOutlet weak var stackWednesday   : UIStackView!
    @IBOutlet weak var lblWednesday     : UILabel!
    @IBOutlet weak var stackThursday    : UIStackView!
    @IBOutlet weak var lblThursday      : UILabel!
    @IBOutlet weak var stackFriday      : UIStackView!
    @IBOutlet weak var lblFriday        : UILabel!
    @IBOutlet weak var stackSaturday    : UIStackView!
    @IBOutlet weak var lblSaturday      : UILabel!
    @IBOutlet weak var stackSunday      : UIStackView!
    @IBOutlet weak var lblSunday        : UILabel!
    @IBOutlet weak var imgProfile       : UIImageView!
    @IBOutlet weak var imgBig           : UIImageView!
    
    //MARK: - Variables and Properties
    let placeholder                        = "Enter Bio..."
    let placeholderColor                   = UIColor.lightGray
    var currentImage                       : UIImage!
    var CurrentTagImg                      : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapAddProfileImg(_ sender: UIButton){
        CurrentTagImg = sender.tag
        pickImg()
    }
    
    @IBAction func ontapAccnt(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtAccntType.text = action.title // Update text field with selected option title
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.arrAccnt {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapScheduleSwitch(_ sender: UISwitch){
        
        switch sender.tag {
        case 0:
            lblMonday.isHidden   = sender.isOn
            stackMonday.isHidden = switchStack(sender: sender.isOn)
            break
        case 1:
            lblTuesday.isHidden   = sender.isOn
            stackTuesday.isHidden = switchStack(sender: sender.isOn)
            break
        case 2:
            lblWednesday.isHidden   = sender.isOn
            stackWednesday.isHidden = switchStack(sender: sender.isOn)
            break
        case 3:
            lblThursday.isHidden   = sender.isOn
            stackThursday.isHidden = switchStack(sender: sender.isOn)
            break
        case 4: 
            lblFriday.isHidden   = sender.isOn
            stackFriday.isHidden = switchStack(sender: sender.isOn)
            break
        case 5: 
            lblSaturday.isHidden   = sender.isOn
            stackSaturday.isHidden = switchStack(sender: sender.isOn)
            break
        case 6:
            lblSunday.isHidden   = sender.isOn
            stackSunday.isHidden = switchStack(sender: sender.isOn)
            break
        default: break
        }
    }
    
    @IBAction func ontapTagPeople(_ sender: UIButton) {
        
        let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "TagPeopleVC") as? TagPeopleVC
        vc?.delegate = self
       // vc.showTagUsers
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

//MARK: - Protocol Image Picker {}
extension UpdateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func pickImg() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        currentImage = image
        if CurrentTagImg == 0 {
            imgProfile.image = currentImage
        }
        else {
            imgBig.image     = currentImage
        }
    }
}
