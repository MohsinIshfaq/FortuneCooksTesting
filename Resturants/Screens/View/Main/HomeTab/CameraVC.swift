//
//  CameraVC.swift
//  Resturants
//
//  Created by Coder Crew on 07/03/2024.
//

import UIKit
import Photos
import AVFoundation
import AVKit
import MobileCoreServices

class CameraVC: FilterCamViewController {

    //MARK: - IBOUtlets
    @IBOutlet weak var btnRecord         : UIButton!
    @IBOutlet weak var progressRecording : UIProgressView!
    @IBOutlet weak var CollectFilter     :  UICollectionView!
    @IBOutlet weak var lblProgress       : UILabel!
    
    //MARK: - variables and Properties
    private var selected                 : Bool = false
    private var selectedRecord           : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    @objc func ontapCameraRoll() {
        
    }
    
    @objc func ontapFlash() {
     
    }
    
    @IBAction func ontapRecord(_ sender: UIButton){
        selectedRecord.toggle()
        btnRecord.backgroundColor = selectedRecord == true ? .red : .ColorDarkBlue
        if selectedRecord{
        }
        else{
        }
    }
    
}

//MARK: - Extension of setup Data{}
extension CameraVC {
    func onLoad() {
        removeNavBackbuttonTitle()
        NavigationRightBtns()
        setupFilterCollection()
        cameraDelegate = self
    }
    
    func onAppear() {
    }
    
    func setupFilterCollection(){
        
        CollectFilter.register(FrameFilterCell.nib, forCellWithReuseIdentifier: FrameFilterCell.identifier)
        CollectFilter.collectionViewLayout = UICollectionViewFlowLayout()
        CollectFilter.delegate   = self
        CollectFilter.dataSource = self
    }
    
    func NavigationRightBtns() {
        
        let imgCamera = UIImage(systemName: "arrow.triangle.2.circlepath")?.withRenderingMode(.automatic)
        let btnCamera = UIBarButtonItem(image: imgCamera, style: .plain, target: self, action: #selector(ontapCameraRoll))
        btnCamera.tintColor = .white
        let imgFlash = UIImage(systemName: "bolt.fill")?.withRenderingMode(.automatic)
        let btnFlash = UIBarButtonItem(image: imgFlash, style: .plain, target: self, action: #selector(ontapFlash))
        btnFlash.tintColor = selected == true ? .yellow : .white
        navigationItem.rightBarButtonItems = [btnCamera , btnFlash]
    }
}

//MARK: - Extension of Filter {}
extension CameraVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.FakefilterNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FrameFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FrameFilterCell.identifier, for: indexPath) as! FrameFilterCell
        if indexPath.row == 0 {
            cell.lblFilter.text = "Normal"
        }
        else{
            cell.lblFilter.text = "Filter \(indexPath.row)"
        }
        cell.lblFilter.textColor = UserManager.shared.FakefilterNameList[indexPath.row][1] as! Int == 1 ? .white : .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        for (index, _) in UserManager.shared.FakefilterNameList.enumerated() {
            if index == indexPath.row {
                UserManager.shared.FakefilterNameList[index][1] = 1
            } else {
                UserManager.shared.FakefilterNameList[index][1] = 0
            }
            if let name = UserManager.shared.FakefilterNameList[index][0] as? String{
                filters = [CIFilter(name: "CIPhotoEffectFade")!]
            }
        }
        CollectFilter.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 40)
    }
    
}

//MARK: - Extension of setup Data{}
extension CameraVC: FilterCamViewControllerDelegate{
    
    func filterCamDidStartRecording(_ filterCam: FilterCamViewController) {
        
    }

    func filterCamDidFinishRecording(_ filterCame: FilterCamViewController) {
        
    }

    func filterCam(_ filterCam: FilterCamViewController, didFailToRecord error: Error) {
        
    }

    func filterCam(_ filterCam: FilterCamViewController, didFinishWriting outputURL: URL) {
        
    }

    func filterCam(_ filterCam: FilterCamViewController, didFocusAtPoint tapPoint: CGPoint) {
        
    }
}
