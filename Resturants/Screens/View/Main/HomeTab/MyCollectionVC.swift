//
//  MyCollectionVC.swift
//  Resturants
//
//  Created by Coder Crew on 29/08/2024.
//

import UIKit

class MyCollectionVC: UIViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var stackAddCollection: UIStackView!
    @IBOutlet weak var vwCOllections     : UICollectionView!
    
    //MARK: - Variables and Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapMore(_ : UIButton) {
        
    }
    
    @IBAction func ontapAddCollection(_ : UIButton) {
        
    }

}

//MARK: - Setup Profile {}
extension MyCollectionVC {
    
    func onload() {
        
    }
    
    func onAppear() {
        self.navigationItem.title  = "My Collections"
        removeNavBackbuttonTitle()
        setupCell()
    }
    
    func setupCell() {
        vwCOllections.register(CollectionsCCell.nib, forCellWithReuseIdentifier: CollectionsCCell.identifier)
        vwCOllections.delegate   = self
        vwCOllections.dataSource = self
    }
}

//MARK: - Setup Collection {}
extension MyCollectionVC: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionsCCell.identifier, for: indexPath) as? CollectionsCCell
        return cell!
    }
    
    
}
