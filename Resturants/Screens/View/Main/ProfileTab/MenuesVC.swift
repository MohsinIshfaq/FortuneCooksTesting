//
//  MenuVC.swift
//  Resturants
//
//  Created by Coder Crew on 08/08/2024.
//

import UIKit

class MenuesVC: UIViewController {

    //MARK: - IBOUtlets
      @IBOutlet weak var tblLocation: UITableView!
      
      
      override func viewDidLoad() {
          super.viewDidLoad()
          onLoad()
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          onAppear()
      }
      
      @IBAction func ontapAddNewLocation(_ sender: UIButton){
          let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ManageInfoVC") as! ManageInfoVC
          vc.isFromNewLocation        = true
          vc.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(vc, animated: true)
      }

  }

  //MARK: - Custom Implementation {}
  extension MenuesVC {
      
      func onLoad() {
          setupView()
          removeNavBackbuttonTitle()
      }
      
      func onAppear() {
          self.navigationItem.title = "Add or manage"
      }
      
      func setupView() {
          tblLocation.register(LocationTCell.nib, forCellReuseIdentifier: LocationTCell.identifier)
          tblLocation.delegate   = self
          tblLocation.dataSource = self
      }
  }

  //MARK: - TableView {}
  extension MenuesVC : UITableViewDelegate , UITableViewDataSource {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 3
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: LocationTCell.identifier, for: indexPath) as? LocationTCell
          cell?.btnManangeInfo.addTarget(self, action: #selector(ontapMangeInfo(sender:)), for: .touchUpInside)
          cell?.btnManageMenu.addTarget(self, action: #selector(ontapMangeMenu(sender:)), for: .touchUpInside)
          return cell!
      }
      
      @objc func ontapMangeInfo(sender: UIButton) {
          let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ManageInfoVC") as! ManageInfoVC
          vc.isFromNewLocation        = false
          vc.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(vc, animated: true)
      }
      
      @objc func ontapMangeMenu(sender: UIButton) {
          let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ManageMenuVC") as! ManageMenuVC
          vc.hidesBottomBarWhenPushed = true
          self.navigationController?.pushViewController(vc, animated: true)
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 150
      }
  }
