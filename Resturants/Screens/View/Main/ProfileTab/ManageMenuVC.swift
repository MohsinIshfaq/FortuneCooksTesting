//
//  ManageMenuVC.swift
//  Resturants
//
//  Created by Coder Crew on 08/08/2024.
//

import UIKit
import FirebaseFirestoreInternal

class ManageMenuVC: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var vwCollect   : UICollectionView!
    @IBOutlet weak var btnCreateGrp: UIButton!
    @IBOutlet weak var btnCreate   : UIButton!
    @IBOutlet weak var btnAddItem  : UIButton!
    @IBOutlet weak var stackEdit   : UIStackView!
    @IBOutlet weak var stackGrpNm  : UIStackView!
    @IBOutlet weak var stackListNum: UIStackView!
    @IBOutlet weak var txtGrpNm    : UITextField!
    @IBOutlet weak var txtListNum  : UITextField!
    @IBOutlet weak var vwTblView   : UITableView!
    
    
    //MARK: - Variables and Properties
    var arr = [["Popular" , 0] ]
    var menuChildren: [UIMenuElement]      = []
    var selectedMenuIndex: Int             = 0
    var location : RestaurantLocation?     = nil
    var groups: [GroupsModel]              = []
    let uniqueID = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
//        menuGroups()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapList(_ sender: UIButton){
         var actionClosure = { (action: UIAction) in
            self.txtListNum.text = action.title
             self.menuChildren.removeAll()
             sender.menu = nil
        }
        
        // Regenerate the menu children
        for i in 1..<arr.count {
            menuChildren.append(UIAction(title: "#\(i)", handler: actionClosure))
        }
        
        // Assign the new menu
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
        
    }
    @IBAction func ontapEdit(_ sender: UIButton) {
        if selectedMenuIndex  != 0 {
            btnCreateGrp.isHidden = true
            btnAddItem.isHidden   = true
            stackGrpNm.isHidden   = false
            stackListNum.isHidden = false
            btnCreate.isHidden    = false
            txtGrpNm.text         = arr[self.selectedMenuIndex][0] as! String
            txtListNum.text       = "#\(self.selectedMenuIndex)"
        }
    }
    @IBAction func ontapAddItem(_ sender: UIButton){
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AddORUpdateItemVC") as! AddORUpdateItemVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func ontapNewGrp(_ sender: UIButton){
        vwTblView.isHidden    = true
        btnCreateGrp.isHidden = true
        stackGrpNm.isHidden   = false
        btnCreate.isHidden    = false
        if arr.count          > 1 {
            stackListNum.isHidden = false
        }
    }
    
    @IBAction func ontapCreate(_ sender: UIButton){
        if selectedMenuIndex != 0 {
            var a = ["\(txtGrpNm.text!)" , 0] as [Any]
            if txtListNum.text != "" {
                let array = Array(txtListNum.text!) // ["#", "3"]
                if Int(String(array[1])) == 0 {
                    arr.remove(at: self.selectedMenuIndex)
                    arr.insert( a , at: self.selectedMenuIndex)
                }
                else {
                    arr.remove(at: self.selectedMenuIndex)
                    var place = Int(String(array[1]))!
                    arr.insert(a, at: place)
                }
            }
        }
        else {
            if txtGrpNm.text != "" {
                var a = ["\(txtGrpNm.text!)" , 0] as [Any]
                if txtListNum.text != "" {
                    let array = Array(txtListNum.text!) // ["#", "3"]
                    if Int(String(array[1])) == 0 {
                        arr.append(a)
                    }
                    else {
                        var place = Int(String(array[1]))!
                        arr.insert(a, at: place)
                    }
                }
                else{
                    arr.append(a)
                    self.groups.append(GroupsModel(id: uniqueID, groupName: "\(a)", selected: 0))

                }
            }
        }
        vwCollect.reloadData()
        onAppear()
        txtGrpNm.text   = ""
        txtListNum.text = ""
        self.selectedMenuIndex  = 0
        vwTblView.isHidden    = false
    }
}

//MARK: - Collection View {}
extension ManageMenuVC{
    
    func onLoad() {
        setupCollectionView()
    }
    
    func setupCollectionView(){
        vwCollect.register(MenuCCell.nib, forCellWithReuseIdentifier: MenuCCell.identifier)
        vwCollect.delegate   = self
        vwCollect.dataSource = self
        
        vwTblView.register(MenuDishTCell.nib, forCellReuseIdentifier: MenuDishTCell.identifier)
        vwTblView.delegate   = self
        vwTblView.dataSource = self
    }
    
    func onAppear() {
        self.navigationItem.title  = "Vnista Pizza"
        
        if arr.count <= 1 {
            btnCreate.isHidden    = true
            btnCreateGrp.isHidden = false
            btnAddItem.isHidden   = true
            stackEdit.isHidden    = false
            stackGrpNm.isHidden   = true
            stackListNum.isHidden = true
        }
        else{
            btnCreate.isHidden    = true
            btnCreateGrp.isHidden = false
            btnAddItem.isHidden   = false
            stackGrpNm.isHidden   = true
            stackListNum.isHidden = true
        }
        getMenuGroup(id: location?.id ?? "")
    }
}

//MARK: - Table View {}
extension ManageMenuVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuDishTCell.identifier, for: indexPath) as? MenuDishTCell
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
    
}

//MARK: - Collection View {}
extension ManageMenuVC: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = vwCollect.dequeueReusableCell(withReuseIdentifier: MenuCCell.identifier, for: indexPath) as! MenuCCell
        cell.vwBack.isHidden = false
        cell.lbl.text = groups[indexPath.row].groupName
        if groups[indexPath.row].selected == 0 {
            cell.vwBack.backgroundColor = UIColor.ColorDarkBlack
            cell.lbl.textColor          = UIColor.white
        }
        else{
            cell.vwBack.backgroundColor = UIColor.white
            cell.lbl.textColor          = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<groups.count {
            groups[i].selected = 0
        }
        
        // Set the selected element to 1
        groups[indexPath.row].selected = 1
        selectedMenuIndex = indexPath.row
        
        // Reload the collection view to reflect the changes (optional)
        collectionView.reloadData()
    }
    
}

//MARK: - Get Videos / profile / change cover / change profile {}
extension ManageMenuVC {

    func getMenuGroup(id: String) {
        let db = Firestore.firestore()
        self.startAnimating()
        
        db.collection("groupsNames").document(id).getDocument { (document, error) in
            self.stopAnimating()
            if let error = error {
                print("Error retrieving document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                let uniqueID = data?["uniqueID"] as? String ?? ""
                let groupName = data?["groupName"] as? String ?? ""
                
                print("Unique ID: \(uniqueID)")
                print("Group Name: \(groupName)")
                self.groups.append(GroupsModel(id: uniqueID, groupName: groupName, selected: 0))
                // Use the retrieved data as needed
            } else {
                print("Document does not exist")
            }
            print(self.groups)
            self.vwCollect.reloadData()
        }
    }
}
