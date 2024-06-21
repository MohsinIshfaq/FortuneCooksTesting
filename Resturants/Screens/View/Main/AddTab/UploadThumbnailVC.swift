//
//  UploadThumbnailVC.swift
//  Resturants
//
//  Created by Coder Crew on 27/03/2024.
//

import UIKit
import AVFoundation
import UIKit

class UploadThumbnailVC: UIViewController {

    @IBOutlet weak var imgPickFromVideo : UIImageView!
    @IBOutlet weak var imgPickOwn       : UIImageView!
    @IBOutlet weak var lblFromVideo     : UILabel!
    @IBOutlet weak var lblOwn           : UILabel!
    @IBOutlet weak var imgThumbnail     : UIImageView!
    @IBOutlet weak var videoSlider      : UISlider!
    
    private var thumImg     : UIImage?        = nil
    var delegate            : ReloadDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoSlider.minimumValue = 0
        videoSlider.maximumValue = 1
        
    }
    @IBAction func ontapSave(_ sender: UIButton){
        //UserManager.shared.thumbnail = thumImg
        delegate?.reload(img: thumImg)
        self.dismiss(animated: true)
    }
    
    @IBAction func ontapDismiss(_ sender: UIButton){
        self.dismiss(animated: true)
    }

    @IBAction func ontapPickImg(_ sender: UIButton){
        
        if sender.tag == 0 {
            videoSlider.isHidden    = false
            imgPickFromVideo.image  = UIImage(named: "selecPhoto")
            imgPickOwn.image        = UIImage(named: "unselecPhoto")
            lblFromVideo.textColor  = .ColorDarkBlue
            lblOwn.textColor        = .white
            if let url = UserManager.shared.finalURL {
                if let img = generateThumbnail(path: url) {
                    self.imgThumbnail.image  = img
                    self.thumImg             = img
                }
            }
        }
        else{
            videoSlider.isHidden    = true
            imgPickOwn.image        = UIImage(named: "selecPhoto")
            imgPickFromVideo.image  = UIImage(named: "unselecPhoto")
            lblFromVideo.textColor  = .white
            lblOwn.textColor        = .ColorDarkBlue
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate      = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType    = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        if imgPickFromVideo.image  == UIImage(named: "selecPhoto"){
            guard let videoURL = UserManager.shared.finalURL else { return }
            
            let time = Double(sender.value) * CMTimeGetSeconds(AVURLAsset(url: videoURL).duration)
            generateThumbnail(for: videoURL, at: time)
        }
    }
    
    func generateThumbnail(for videoURL: URL, at time: Double) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: cmTime, actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            imgThumbnail.image = thumbnail
            self.thumImg       = thumbnail
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
        }
    }
}
extension UploadThumbnailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.imgThumbnail.image = pickedImage
            self.thumImg             = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
