//
//  ManageMenuVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/06/2024.
//

import UIKit

class ManageMenuVC: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var tblLocation: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }

}

//MARK: - Custom Implementation {}
extension ManageMenuVC {
    
    func onLoad() {
        setupView()
        self.navigationItem.title = "Add or manage"
        removeNavBackbuttonTitle()
    }
    
    func onAppear() {
        
    }
    
    func setupView() {
        
        tblLocation.register(LocationTCell.nib, forCellReuseIdentifier: LocationTCell.identifier)
        tblLocation.delegate   = self
        tblLocation.dataSource = self
    }
}

//MARK: - TableView {}
extension ManageMenuVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTCell.identifier, for: indexPath) as? LocationTCell
        cell?.btnManangeInfo.addTarget(self, action: #selector(ontapMangeInfo(sender:)), for: .touchUpInside)
        return cell!
    }
    
    @objc func ontapMangeInfo(sender: UIButton) {
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ManageInfoVC") as! ManageInfoVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
