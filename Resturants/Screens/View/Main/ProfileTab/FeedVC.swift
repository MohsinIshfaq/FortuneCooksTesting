//
//  FeedVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit

class FeedVC: UIViewController , FeedDelegate , UITextFieldDelegate {
    func collectionData(type: Int) {
        if type == 0 {
            UserManager.shared.selectedContent.removeAll()
            arrSelectedContent.removeAll()
            for i in 0..<UserManager.shared.arrContent.count{
                if UserManager.shared.arrContent[i][1] == "1" {
                    self.arrSelectedContent.append(UserManager.shared.arrContent[i][0])
                }
            }
            CollectContent.reloadData()
        }
        else{
            UserManager.shared.selectedFeedAccnt.removeAll()
            arrSelectedAccntType.removeAll()
            for i in 0..<UserManager.shared.arrAccntType.count{
                if UserManager.shared.arrAccntType[i][1] == "1" {
                    self.arrSelectedAccntType.append(UserManager.shared.arrAccntType[i][0])
                }
            }
            CollectAccntType.reloadData()
        }
    }
    //MARK: - IBOUtlets
    @IBOutlet weak var CollectAccntType      : UICollectionView!
    @IBOutlet weak var CollectContent        : UICollectionView!
    @IBOutlet weak var btnAccntType          : UIButton!
    @IBOutlet weak var btnContent            : UIButton!
    @IBOutlet weak var btnTopAccntType       : UIButton!
    @IBOutlet weak var btnTopContent         : UIButton!
    @IBOutlet weak var txtLang               : UITextField!
    @IBOutlet weak var collectLangs          : UICollectionView!
    @IBOutlet weak var txtHastag             : UITextField!
    @IBOutlet weak var btnAddHastag          : UIButton!
    @IBOutlet weak var collectHastag         : UICollectionView!
    @IBOutlet weak var lblhastag             : UILabel!
    
    
    //MARK: - Variables and Properties
    var type                                = -1
    var arrSelectedAccntType  : [String]    = []
    var arrSelectedContent    : [String]    = []
    var arrSelectedLang       : [String]    = []
    var arrHastag             : [String]    = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapLangs(_ sender: UIButton){
        let actionClosure = { (action: UIAction) in
            self.txtLang.text = action.title // Update text field with selected option title
            self.arrSelectedLang.append(self.txtLang.text!)
            self.collectLangs.reloadData()
        }
        var menuChildren: [UIMenuElement] = []
        for meal in UserManager.shared.arrlanguages {
            menuChildren.append(UIAction(title: meal, handler: actionClosure))
        }
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func ontapAddContent(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "FeedSelectionVC") as! FeedSelectionVC
        vc.delegate = self
        vc.type     = 0
        self.type   = 0
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func ontapAddAccountType(_ sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "FeedSelectionVC") as! FeedSelectionVC
        vc.delegate = self
        vc.type     = 1
        self.type   = 1
        self.navigationController?.present(vc, animated: true)
    }
    
    @IBAction func ontapAddHastag(_ sender : UIButton) {
        if txtHastag.text             != "" {
            if arrHastag.count        <= 10 {
                let stringWithoutSpaces = txtHastag.text!.replacingOccurrences(of: " ", with: "")
                arrHastag.append("#\(stringWithoutSpaces)")
                collectHastag.reloadData()
                txtHastag.text        = ""
                btnAddHastag.isHidden = true
            }
        }
    }

}


//MARK: - Setup Profile {}
extension FeedVC {
   
    func onload() {
      
        self.navigationItem.title = "Feed"
        txtHastag.delegate        = self
        removeNavBackbuttonTitle()
        setupViews()
    }
    
    func setupViews() {
        CollectContent.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectContent.delegate      = self
        CollectContent.dataSource    = self
        
        CollectAccntType.register(CollectionCell.nib, forCellWithReuseIdentifier: CollectionCell.identifier)
        CollectAccntType.delegate    = self
        CollectAccntType.dataSource  = self
        
        collectLangs.register(HastagCCell.nib, forCellWithReuseIdentifier: HastagCCell.identifier)
        collectLangs.delegate        = self
        collectLangs.dataSource      = self
        
        collectHastag.register(HastagCCell.nib, forCellWithReuseIdentifier: HastagCCell.identifier)
        collectHastag.delegate      = self
        collectHastag.dataSource    = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = txtHastag.text, !text.isEmpty {
            // TextField is not empty
            btnAddHastag.isHidden = false
        } else {
            // TextField is empty
            print("TextField is empty")
            btnAddHastag.isHidden = true
        }
    }
    
    func onAppear() {
       
    }
}


//MARK: - Collection View Setup {}
extension FeedVC: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CollectContent {
            if arrSelectedContent.count == 0 {
                self.btnContent.isHidden = false
                self.btnTopContent.isHidden = true
                return 0
            }
            else{
                self.btnContent.isHidden = true
                self.btnTopContent.isHidden = false
                return arrSelectedContent.count
            }
        }
        else if collectionView == collectLangs {
            return self.arrSelectedLang.count
        }
        else if collectionView == collectHastag{
            //lblhastag.text = "\(arrHastag.count)/10"
            return arrHastag.count
        }
        else{
            if arrSelectedAccntType.count == 0 {
                self.btnAccntType.isHidden = false
                self.btnTopAccntType.isHidden = true
                return 0
            }
            else{
                self.btnAccntType.isHidden = true
                self.btnTopAccntType.isHidden = false
                return arrSelectedAccntType.count
            }
        }
    }
    @objc func onTapContent(sender: UIButton){
        for i in 0..<UserManager.shared.arrContent.count{
            if UserManager.shared.arrContent[i][0] == arrSelectedContent[sender.tag] {
                UserManager.shared.arrContent[i][1]  = "0"
            }
        }
        UserManager.shared.selectedContent.removeAll()
        arrSelectedContent.remove(at: sender.tag)
        CollectContent.reloadData()
    }
    @objc func onTapAccntType(sender: UIButton){
        for i in 0..<UserManager.shared.arrAccntType.count{
            if UserManager.shared.arrAccntType[i][0] == arrSelectedAccntType[sender.tag] {
                UserManager.shared.arrAccntType[i][1]  = "0"
            }
        }
        UserManager.shared.selectedFeedAccnt.removeAll()
        arrSelectedAccntType.remove(at: sender.tag)
        CollectAccntType.reloadData()
    }
    @objc func onTapHastag(sender: UIButton){
        arrSelectedLang.remove(at: sender.tag)
        collectLangs.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CollectContent {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            
            cell.lbl.text = arrSelectedContent[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapContent(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedCuisine.append(arrSelectedContent[indexPath.row])
            return cell
        }
        else if collectionView == collectLangs {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HastagCCell.identifier, for: indexPath) as! HastagCCell
            cell.lbl.text  = arrSelectedLang[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapHastag(sender:)), for: .touchUpInside)
            cell.btn.tag   = indexPath.row
            return cell
        }
        else if collectionView == collectHastag{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HastagCCell.identifier, for: indexPath) as! HastagCCell
            cell.lbl.text  = arrHastag[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapHastag(sender:)), for: .touchUpInside)
            cell.btn.tag   = indexPath.row
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            
            cell.lbl.text = arrSelectedAccntType[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapAccntType(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedFeedAccnt.append(arrSelectedAccntType[indexPath.row])
            return cell
        }
    }
}
