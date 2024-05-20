//
//  FeedVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit

class FeedVC: UIViewController , FeedDelegate {
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
    
    //MARK: - Variables and Properties
    var type                                = -1
    var arrSelectedAccntType  : [String]    = []
    var arrSelectedContent    : [String]    = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
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

}


//MARK: - Setup Profile {}
extension FeedVC {
   
    func onload() {
      
        self.navigationItem.title = "Feed"
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CollectContent {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
            
            cell.lbl.text = arrSelectedContent[indexPath.row]
            cell.btn.addTarget(self, action:#selector(onTapContent(sender:)), for: .touchUpInside)
            cell.btn.tag = indexPath.row
            UserManager.shared.selectedCuisine.append(arrSelectedContent[indexPath.row])
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
