//
//  VideosCotnior.swift
//  Resturants
//
//  Created by Coder Crew on 23/04/2024.
//

import UIKit

class VideosContainer: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var tblVIdeos: UITableView!
    
    //MARK: - variables and Properties
    var arr   = ["" , "" , ""  , ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLaod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }

}

//MARK: - setupView {}
extension VideosContainer {
    
    func setupView() {
        tblVIdeos.register(VideoTCell.nib, forCellReuseIdentifier: VideoTCell.identifier)
        tblVIdeos.delegate   = self
        tblVIdeos.dataSource = self
        
        tblVIdeos.register(NoPostTCell.nib, forCellReuseIdentifier: NoPostTCell.identifier)
        tblVIdeos.delegate   = self
        tblVIdeos.dataSource = self
        
        tblVIdeos.register(VideosHeaderView.nib, forHeaderFooterViewReuseIdentifier: VideosHeaderView.identifier)
    }
    
    func onLaod() {
    }
    
    func onAppear() {
        setupView()
        self.navigationController?.removeBackground()
    }
}

//MARK: - TableVew {}
extension VideosContainer : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arr.count == 0 {
            return 0
        }
        else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr.count == 0 {
            return 0
        }
        else{
            return arr.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "VideosHeaderView") as! VideosHeaderView
    return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 300
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arr.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoPostTCell.identifier, for: indexPath) as! NoPostTCell
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: VideoTCell.identifier, for: indexPath) as! VideoTCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
