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
    @IBOutlet weak var btnDelete   : UIButton!
    
    
    //MARK: - Variables and Properties
   // var arr = [["Popular" , 0] ]
    var menuChildren: [UIMenuElement]      = []
    var selectedMenuIndex: Int             = 0
    var selectedUniqueID                   = ""
    var location : RestaurantLocation?     = nil
    var groups: [GroupsModel]              = []
    let uniqueID = UUID().uuidString
    var groupItems: [GroupsItemModel?]    = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapDelete(_ sender: UIButton) {
        groups.remove(at: self.selectedMenuIndex)
        updateMenuGroups(id: location?.id ?? "")
        btnDelete.isHidden = true
    }
    @IBAction func ontapList(_ sender: UIButton){
         var actionClosure = { (action: UIAction) in
            self.txtListNum.text = action.title
             self.menuChildren.removeAll()
             sender.menu = nil
        }
        
        // Regenerate the menu children
        for i in 1..<groups.count {
            menuChildren.append(UIAction(title: "#\(i)", handler: actionClosure))
        }
        
        // Assign the new menu
        sender.menu = UIMenu(options: .displayInline, children: menuChildren)
        sender.showsMenuAsPrimaryAction = true
        
    }
    @IBAction func ontapEdit(_ sender: UIButton) {
        if selectedMenuIndex  != 0 {
            vwTblView.isHidden    = true
            btnCreateGrp.isHidden = true
            btnAddItem.isHidden   = true
            stackGrpNm.isHidden   = false
            stackListNum.isHidden = false
            btnCreate.isHidden    = false
            btnDelete.isHidden    = false
            txtGrpNm.text         = groups[self.selectedMenuIndex].groupName
            txtListNum.text       = "#\(self.selectedMenuIndex)"
            self.selectedUniqueID = groups[self.selectedMenuIndex].id
        }
        else{
            self.selectedUniqueID = groups[self.selectedMenuIndex].id
        }
    }
    @IBAction func ontapAddItem(_ sender: UIButton){
        if !(selectedUniqueID == "") {
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AddORUpdateItemVC") as! AddORUpdateItemVC
            vc.totalCount               = self.groupItems.count
            vc.id                       = selectedUniqueID
            vc.addNewItem               = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func ontapNewGrp(_ sender: UIButton){
        vwTblView.isHidden    = true
        btnCreateGrp.isHidden = true
        stackGrpNm.isHidden   = false
        btnCreate.isHidden    = false
        if groups.count          > 1 {
            stackListNum.isHidden = false
        }
    }
    @IBAction func ontapCreate(_ sender: UIButton){
        if selectedMenuIndex != 0 {
            _ = ["\(txtGrpNm.text!)" , 0] as [Any]
            if txtListNum.text != "" {
                let array = Array(txtListNum.text!) // ["#", "3"]
                if Int(String(array[1])) == 0 {
                    groups.remove(at: self.selectedMenuIndex)
                    groups.insert(GroupsModel(id: self.selectedUniqueID, groupName: "\(txtGrpNm.text!)", selected: 0) , at: self.selectedMenuIndex)
                }
                else {
                    groups.remove(at: self.selectedMenuIndex)
                    let place = Int(String(array[1]))!
//                    arr.insert(a, at: place)
                    groups.insert(GroupsModel(id: self.selectedUniqueID, groupName: "\(txtGrpNm.text!)", selected: 0) , at: place)
                }
            }
        }
        else {
            if txtGrpNm.text != "" {
                _ = ["\(txtGrpNm.text!)" , 0] as [Any]
                if txtListNum.text != "" {
                    let array = Array(txtListNum.text!) // ["#", "3"]
                    if Int(String(array[1])) == 0 {
                      //  arr.append(a)
                    }
                    else {
                        let place = Int(String(array[1]))!
//                        arr.insert(a, at: place)
//                        self.groups.append(GroupsModel(id: uniqueID, groupName: "\(txtGrpNm.text!)", selected: 0))
                        self.groups.insert(GroupsModel(id: uniqueID, groupName: "\(txtGrpNm.text!)", selected: 0), at: place)
                    }
                }
                else{
                   // arr.append(a)
                    self.groups.append(GroupsModel(id: uniqueID, groupName: "\(txtGrpNm.text!)", selected: 0))
                    print(groups)

                }
            }
        }
        vwCollect.reloadData()
       // onAppear()
        txtGrpNm.text   = ""
        txtListNum.text = ""
        self.selectedMenuIndex  = 0
        vwTblView.isHidden    = false
        updateMenuGroups(id: location?.id ?? "")
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
        self.navigationItem.title  = "Add Item"
        getMenuGroup(id: location?.id ?? "")
        groupItems.removeAll()
        vwTblView.reloadData()
        removeNavBackbuttonTitle()
        
       
    }
}

//MARK: - Table View {}
extension ManageMenuVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuDishTCell.identifier, for: indexPath) as? MenuDishTCell
        cell?.lblName.text      = groupItems[indexPath.row]?.title ?? ""
        cell?.lblDescrip.text   = groupItems[indexPath.row]?.descrip ?? ""
        cell?.lblMostLiked.text = "#\(groupItems[indexPath.row]?.mostLiked ?? "") most liked"
        cell?.lblSek.text       = "\(groupItems[indexPath.row]?.price ?? "") \(groupItems[indexPath.row]?.currency ?? "")"
        DispatchQueue.main.async {
            if let profileURL = self.groupItems[indexPath.row]?.img, let urlProfile1 = URL(string: profileURL) {
                cell?.imgDish.sd_setImage(with: urlProfile1)
            }
        }
        cell?.btnEdit.addTarget(self, action: #selector(ontapEditItem(_ :)), for: .touchUpInside)
        cell?.btnEdit.tag = indexPath.row
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
    
    @objc func ontapEditItem(_ sender: UIButton){
        if !(selectedUniqueID == "") {
            let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "AddORUpdateItemVC") as! AddORUpdateItemVC
            vc.totalCount               = self.groupItems.count
            vc.id                       = selectedUniqueID
            vc.addNewItem               = false
            vc.GroupsItem               = self.groupItems[sender.tag]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        groupItems.removeAll()
        for i in 0..<groups.count {
            groups[i].selected = 0
        }
        
        // Set the selected element to 1
        groups[indexPath.row].selected = 1
        selectedMenuIndex = indexPath.row
        self.selectedUniqueID = groups[indexPath.row].id
        self.fetchGroupItems()
        
        // Reload the collection view to reflect the changes (optional)
        collectionView.reloadData()
        vwTblView.reloadData()
    }
    
}

//MARK: - Get Videos / profile / change cover / change profile {}
extension ManageMenuVC {

    func getMenuGroup(id: String) {
        self.groups.removeAll()
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
                let groupsData = data?["groups"] as? [[String: Any]] ?? []
                
                for groupData in groupsData {
                    let uniqueID = groupData["uniqueID"] as? String ?? ""
                    let groupName = groupData["groupName"] as? String ?? ""
                    self.groups.append(GroupsModel(id: uniqueID, groupName: groupName, selected: 0))
                }
                
                print(self.groups)
                self.vwCollect.reloadData()
                if self.groups.count <= 1 {
                    self.btnCreate.isHidden    = true
                    self.btnCreateGrp.isHidden = false
                    self.btnAddItem.isHidden   = true
                    self.stackEdit.isHidden    = false
                    self.stackGrpNm.isHidden   = true
                    self.stackListNum.isHidden = true
                }
                else{
                    self.btnCreate.isHidden    = true
                    self.btnCreateGrp.isHidden = false
                    self.btnAddItem.isHidden   = false
                    self.stackGrpNm.isHidden   = true
                    self.stackListNum.isHidden = true
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    func updateMenuGroups(id: String) {
        let db = Firestore.firestore()
        self.startAnimating()
        
        // Prepare the array of groups to be saved
        var groupArray: [[String: Any]] = []
        
        for group in groups {
            var groupDict: [String: Any] = [
                "uniqueID": group.id,
                "groupName": group.groupName
            ]
            groupArray.append(groupDict)
        }
        
        // Update the document with the new array of groups
        let updatedData: [String: Any] = ["groups": groupArray]
        print(updatedData)
        db.collection("groupsNames").document(id).setData(updatedData) { error in
            self.stopAnimating()
            if let error = error {
                print("Error updating document with ID \(id): \(error.localizedDescription)")
            } else {
                print("Document with ID \(id) successfully updated!")
                self.onAppear()
            }
        }
    }
    func fetchGroupItems() {
        self.startAnimating()
        let db = Firestore.firestore()
        
        let collectionPath = "group_Items/\(self.selectedUniqueID)/Items"
        db.collection(collectionPath).getDocuments { (querySnapshot, error) in
            self.stopAnimating()
            
            if let error = error {
                print("Error getting documents: \(error.localizedDescription)")
            } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                // If documents exist, process them
                for document in documents {
                    let data = document.data()
                    let id           = data["uniqueID"] as? String ?? ""
                    let title        = data["title"] as? String ?? ""
                    let img          = data["img"] as? String ?? ""
                    let description  = data["description"] as? String ?? ""
                    let price        = data["price"] as? String ?? ""
                    let currency     = data["currency"] as? String ?? ""
                    let mostLiked    = data["mostLiked"] as? String ?? ""
                    
                    self.groupItems.append(GroupsItemModel(id: id, title: title, img: img, descrip: description, price: price, currency: currency, mostLiked: mostLiked))
                }
                self.vwTblView.reloadData()
            } else {
                // No documents exist in the collection
                print("No items found for this group.")
            }
        }
    }
}
