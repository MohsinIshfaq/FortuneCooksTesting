//
//  CollectionContainer.swift
//  Resturants
//
//  Created by Coder Crew on 30/04/2024.
//

import UIKit

class CollectionContainer: UIViewController {

    @IBOutlet weak var vwCollection : UICollectionView!
    @IBOutlet weak var tblVIdeos    : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }

}


//MARK: - Setup view {}
extension CollectionContainer {
   
    func onload() {
       // self.navigationController?.removeBackground()
    }
    
    func onAppear() {
        
        vwCollection.register(SwiftCCell.nib, forCellWithReuseIdentifier: SwiftCCell.identifier)
        vwCollection.delegate   = self
        vwCollection.dataSource = self
        
        tblVIdeos.register(VideoTCell.nib, forCellReuseIdentifier: VideoTCell.identifier)
        tblVIdeos.delegate   = self
        tblVIdeos.dataSource = self
    }
}
//MARK: - collection view {}
extension CollectionContainer : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwiftCCell.identifier, for: indexPath) as! SwiftCCell
       // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoPostCCell.identifier, for: indexPath) as! NoPostCCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 250)
    }
    
}

extension CollectionContainer : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTCell.identifier, for: indexPath) as! VideoTCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
