//
//  SwiftsContainer.swift
//  Resturants
//
//  Created by Coder Crew on 23/04/2024.
//

import UIKit

class SwiftsContainer: UIViewController {

    @IBOutlet weak var vwCollection : UICollectionView!
    
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
extension SwiftsContainer {
   
    func onload() {
       // self.navigationController?.removeBackground()
    }
    
    func onAppear() {
        
        vwCollection.register(SwiftCCell.nib, forCellWithReuseIdentifier: SwiftCCell.identifier)
        vwCollection.delegate   = self
        vwCollection.dataSource = self
        
//        vwCollection.register(NoPostCCell.nib, forCellWithReuseIdentifier: NoPostCCell.identifier)
//        vwCollection.delegate   = self
//        vwCollection.dataSource = self
    }
}

//MARK: - collection view {}
extension SwiftsContainer : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
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
