//
//  OtherLocVC.swift
//  Resturants
//
//  Created by Coder Crew on 10/05/2024.
//

import UIKit

class OtherLocVC: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var tblLocation: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onLoad()
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

//MARK: - Custom Implementation {}
extension OtherLocVC {
    
    func onLoad() {
        setupView()
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
extension OtherLocVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTCell.identifier, for: indexPath) as? LocationTCell
        cell?.stackBtns.isHidden = true
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
}
