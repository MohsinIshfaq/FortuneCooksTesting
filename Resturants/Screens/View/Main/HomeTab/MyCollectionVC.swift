//
//  MyCollectionVC.swift
//  Resturants
//
//  Created by Coder Crew on 29/08/2024.
//

import UIKit

class MyCollectionVC: UIViewController , CollectionActionsDelegate, ConfirmationAutionsDelegate {
    func willDelete(_ condition: Bool) {
        if condition {
            self.dismiss(animated: true)
        }
        else{
            self.dismiss(animated: true)
        }
    }
    
    func collectionAction(_ type: String) {
        if type == "Edit" {
            self.dismiss(animated: true)
        }
        else{
            self.dismiss(animated: true)
            let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "ConfirmationActionVC") as? ConfirmationActionVC
            vc?.delegate = self
            self.present(vc!, animated: true)
        }
    }
    

    //MARK: - IBOUtlets
    @IBOutlet weak var stackAddCollection : UIStackView!
    @IBOutlet weak var vwCOllections      : UICollectionView!
     
    @IBOutlet weak var vwAll              : UIView!
    @IBOutlet weak var vwVidos            : UIView!
    @IBOutlet weak var vwSwift            : UIView!
           
    @IBOutlet weak var lblAll             : UILabel!
    @IBOutlet weak var lblVidos           : UILabel!
    @IBOutlet weak var lblSwift           : UILabel!
     
    @IBOutlet weak var stackTypeCollect   : UIStackView!
    
    //MARK: - Variables and Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapAddCollection(_ : UIButton) {
       
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CreateCollectionPopupVC") as? CreateCollectionPopupVC
        self.present(vc!, animated: true)
    }
    
    @objc func ontapMore(_ : UIButton) {
        
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CollectionsActionPopupVC") as? CollectionsActionPopupVC
        vc?.delegate = self
        self.present(vc!, animated: true)
    }
    
    @objc func ontapAdd(_ : UIButton) {
        
        let vc = Constants.homehStoryBoard.instantiateViewController(withIdentifier: "CreateCollectionPopupVC") as? CreateCollectionPopupVC
        self.present(vc!, animated: true)
    }
    
    
    @IBAction func ontapTypeCollection(_ sender: UIButton) {
      
        if sender.tag == 0 {
            vwAll.backgroundColor   = .white
            vwVidos.backgroundColor = .black
            vwSwift.backgroundColor = .black
            
            lblAll.textColor        = .black
            lblVidos.textColor      = .white
            lblSwift.textColor      = .white
        }
        else if sender.tag == 1 {
            vwAll.backgroundColor   = .black
            vwVidos.backgroundColor = .white
            vwSwift.backgroundColor = .black
            
            lblAll.textColor        = .white
            lblVidos.textColor      = .black
            lblSwift.textColor      = .white
        }
        else{
            vwAll.backgroundColor   = .black
            vwVidos.backgroundColor = .black
            vwSwift.backgroundColor = .white
            
            lblAll.textColor        = .white
            lblVidos.textColor      = .white
            lblSwift.textColor      = .black
        }
    }

}

//MARK: - Setup Profile {}
extension MyCollectionVC {
    
    func onload() {
        
    }
    
    func onAppear() {
        self.navigationItem.title  = "My Collections"
        removeNavBackbuttonTitle()
        NavigationRightBtn()
        setupCell()
        
        vwAll.backgroundColor   = .white
        vwVidos.backgroundColor = .black
        vwSwift.backgroundColor = .black

        lblAll.textColor        = .black
        lblVidos.textColor      = .white
        lblSwift.textColor      = .white
    }
    
    func setupCell() {
        vwCOllections.register(CollectionsCCell.nib, forCellWithReuseIdentifier: CollectionsCCell.identifier)
        vwCOllections.delegate   = self
        vwCOllections.dataSource = self
    }
    
    func NavigationRightBtn() {
        
        let moreImg = UIImage(named: "More")?.withRenderingMode(.automatic)
        var moreBtn = UIBarButtonItem(image: moreImg, style: .plain, target: self, action: #selector(ontapMore))
        
        let editImg = UIImage(systemName: "plus")?.withRenderingMode(.automatic)
        var editBtn = UIBarButtonItem(image: editImg, style: .plain, target: self, action: #selector(ontapAdd))
        navigationItem.rightBarButtonItems = [moreBtn , editBtn]
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}

//MARK: - Setup Collection {}
extension MyCollectionVC: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionsCCell.identifier, for: indexPath) as? CollectionsCCell
        cell?.vwBack.borderWidth  = 1
        cell?.vwBack.borderColor  = .ColorDarkBlue
        cell?.lblTitle.textColor  = .ColorDarkBlue
        cell?.imgCollection.image = UIImage(named: "SelectedCollection")
        return cell!
    }
    
    
}
