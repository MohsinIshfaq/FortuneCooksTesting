//
//  EditVideoVC.swift
//  Resturants
//
//  Created by Coder Crew on 02/03/2024.
//

import UIKit
import AVKit
import Photos

class EditVideoVC: UIViewController, UINavigationControllerDelegate {

    //MARK: - @IBOutlets
    @IBOutlet weak var vwVideo   :  UIView!
    @IBOutlet weak var vwCollect :  UICollectionView!
    
    //MARK: - variables and Properties
    var urlVideo   : URL?     = nil
    var avplayer              = AVPlayer()
    var playerController      = AVPlayerViewController()
    var thumImg   : UIImage?  = nil
    var videoEditor           = VideoEditor()
    var videoPlayer           : AVPlayer!
    var avpController         : AVPlayerViewController!
    var avVideoComposition    : AVVideoComposition!
    var video                 : AVURLAsset?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapCancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapSave(_ sender: UIButton) {
        checkPhotoLibraryPermission()
    }

}

//MARK: - Extension of setup Data{}
extension EditVideoVC {
   
    func onLoad(){
        guard let url = urlVideo else {
            // Handle the case when the video URL is nil
            return
        }
        // Convert URL to NSURL
        let asset = AVURLAsset(url: url as URL)
        self.video = asset
        removeNavBackbuttonTitle()
        addVideoPlayer(videoUrl: video!, to: vwVideo, filterName: "")
        setupFilterCollection()
        if let url = self.urlVideo {
            self.thumImg  = generateThumbnail(path: url)
        }
    }
    
    func onAppear(){
    }
    
    func addVideoPlayer(videoUrl: AVURLAsset, to view: UIView , filterName: String) {
        let avPlayerItem = AVPlayerItem(asset: videoUrl)
        if filterName != "" {
            avVideoComposition = AVVideoComposition(asset: self.video!, applyingCIFiltersWithHandler: { request in
                let source = request.sourceImage.clampedToExtent()
                let filter = CIFilter(name:filterName)!
                filter.setDefaults()
                filter.setValue(source, forKey: kCIInputImageKey)
                let output = filter.outputImage!
                request.finish(with:output, context: nil)
            })
            avPlayerItem.videoComposition = avVideoComposition
            if self.videoPlayer == nil {
                self.videoPlayer = AVPlayer(playerItem: avPlayerItem)
                self.avpController = AVPlayerViewController()
                self.avpController.player = self.videoPlayer
                self.avpController.view.frame = vwVideo.bounds
                self.addChild(avpController)
                vwVideo.addSubview(avpController.view)
                videoPlayer.play()
            }
            else{
                videoPlayer.replaceCurrentItem(with: avPlayerItem)
                videoPlayer.play()
            }
        }
        else {
            self.videoPlayer = AVPlayer(playerItem: avPlayerItem)
            self.avpController = AVPlayerViewController()
            self.avpController.player = self.videoPlayer
            self.avpController.view.frame = vwVideo.bounds
            self.addChild(avpController)
            vwVideo.addSubview(avpController.view)
            videoPlayer.play()
        }
    }
    
    func setupFilterCollection(){
        
        vwCollect.register(FilterCCell.nib, forCellWithReuseIdentifier: FilterCCell.identifier)
        vwCollect.delegate   = self
        vwCollect.dataSource = self
    }
    
    //Exporting Video
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            exportFilteredVideo()
        case .denied, .restricted:
            showPermissionDeniedAlert()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.exportFilteredVideo()
                    } else {
                        self?.showPermissionDeniedAlert()
                    }
                }
            }
        @unknown default:
            break
        }
    }

    func exportFilteredVideo() {
        if let video = self.video , let compostion = avVideoComposition {
            video.exportFilterVideo(video: video, videoComposition: avVideoComposition , completion: { (url) in
            })
            self.dismiss(animated: true)
        }
        else{
            print("Please select filter")
        }
        
    }
    
    func showPermissionDeniedAlert() {
        let alertController = UIAlertController(
            title: "Photo Library Access Required",
            message: "Access to the photo library is required to save the video. Please grant permission in the device settings.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(
            title: "Open Settings",
            style: .default,
            handler: { _ in
                // Open the settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
        ))
        alertController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: - Extension of Filter {}
extension EditVideoVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.filterNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FilterCCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCCell.identifier, for: indexPath) as! FilterCCell
        cell.lbl_effectName.text    = UserManager.shared.filterDisplayNameList[indexPath.row]
        if let convertImage = thumImg {
            if indexPath.row != 0 {
                cell.effect_Imgvw.image = videoEditor.createFilteredImage(filterName: UserManager.shared.filterNameList[indexPath.row], image: convertImage)
            }
            else{
                cell.effect_Imgvw.image = convertImage
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            addVideoPlayer(videoUrl: self.video!, to: vwVideo, filterName:UserManager.shared.filterNameList[indexPath.row])
        }
        else{
            addVideoPlayer(videoUrl: self.video!, to: vwVideo, filterName:"")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4.0, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
