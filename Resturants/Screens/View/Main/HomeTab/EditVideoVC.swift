//
//  EditVideoVC.swift
//  Resturants
//
//  Created by Coder Crew on 02/03/2024.
//

import UIKit
import AVKit

class EditVideoVC: UIViewController {

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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
}

//MARK: - Extension of setup Data{}
extension EditVideoVC {
   
    func onLoad(){
        removeNavBackbuttonTitle()
        addVideoPlayer(videoUrl: urlVideo!, to: vwVideo, filterName: "")
        setupFilterCollection()
        if let url = self.urlVideo {
            self.thumImg  = generateThumbnail(path: url)
        }
    }
    
    func onAppear(){
    }
    
    func addVideoPlayer(videoUrl: URL, to view: UIView , filterName: String) {
        let videoUrl = videoUrl
        let asset = AVAsset(url: videoUrl)
        let avPlayerItem = AVPlayerItem(asset: asset)
        if filterName != "" {
            avVideoComposition = AVVideoComposition(asset: asset, applyingCIFiltersWithHandler: { request in
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
    
    //MARK: Thumbnail Image generate
    func generateThumbnail(path: URL) -> UIImage? {
        // getting image from video
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            self.showAlertWith(title: "Error", message: error.localizedDescription)
            return nil
        }
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
            addVideoPlayer(videoUrl: urlVideo!, to: vwVideo, filterName:UserManager.shared.filterNameList[indexPath.row])
        }
        else{
            addVideoPlayer(videoUrl: urlVideo!, to: vwVideo, filterName:"")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 4.0, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
