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