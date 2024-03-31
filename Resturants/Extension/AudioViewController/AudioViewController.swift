//
//  AudioViewController.swift
//  Resturants
//
//  Created by Coder Crew on 17/03/2024.
//

import Foundation
import AVFAudio
import UIKit
import AVFoundation
import Photos

open class AudioViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: - Variables
    var recordingSession  : AVAudioSession!
    var audioRecorder     : AVAudioRecorder!
    var mutableVideoURL   = NSURL() //final video url
    
    //MARK: - Func {}
    func setupAudioRecording(){
        
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                    } else {
                        self.showAlertWith(title: "Error", message: "kindly Allow Permission for Audio Recording.")
                    }
                }
            }
        } catch {
            self.showAlertWith(title: "Error", message: "failed to record!")
            // failed to record!
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getRecordedAudioFile() -> URL? {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return audioFilename
    }
    
    func startAudioRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            //recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishAudioRecording(success: false)
        }
    }
    
    func finishAudioRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            //recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
           // recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishAudioRecording(success: false)
        }
    }
    
    func mergeAudioWithVideo(videoURL: URL, audioURL: URL, completion: @escaping (URL?) -> Void) {
        // Create AVURLAsset for the video and audio files
        let videoAsset = AVURLAsset(url: videoURL)
        let audioAsset = AVURLAsset(url: audioURL)
        
        // Create AVMutableComposition
        let composition = AVMutableComposition()
        
        // Add video track to the composition
        guard let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(nil)
            return
        }
        
        do {
            // Add video asset to the video track
            try videoTrack.insertTimeRange(CMTimeRange(start: .zero, duration: videoAsset.duration), of: videoAsset.tracks(withMediaType: .video)[0], at: .zero)
        } catch {
            completion(nil)
            return
        }
        
        // Add audio track to the composition
        guard let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid) else {
            completion(nil)
            return
        }
        
        do {
            // Add audio asset to the audio track
            try audioTrack.insertTimeRange(CMTimeRange(start: .zero, duration: audioAsset.duration), of: audioAsset.tracks(withMediaType: .audio)[0], at: .zero)
        } catch {
            completion(nil)
            return
        }
        
        // Create export session
        guard let exportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil)
            return
        }
        
        // Set output file URL
        let mergedURL = URL(fileURLWithPath: NSTemporaryDirectory() + "merged\(Int(arc4random_uniform(UInt32.max))).mov")
        exportSession.outputURL = mergedURL
        exportSession.outputFileType = .mov
        
        // Perform the export
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(mergedURL)
            default:
                completion(nil)
            }
        }
    }

    func removeAudioFromVideo(_ videoURL: URL, completion: @escaping (URL?, Error?) -> Void) {
        let inputVideoURL: URL = videoURL
        let sourceAsset = AVURLAsset(url: inputVideoURL)
        let sourceVideoTrack: AVAssetTrack? = sourceAsset.tracks(withMediaType: AVMediaType.video)[0]
        let composition : AVMutableComposition = AVMutableComposition()
        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let x: CMTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: sourceAsset.duration)
        _ = try? compositionVideoTrack!.insertTimeRange(x, of: sourceVideoTrack!, at: CMTime.zero)
        mutableVideoURL = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/FinalVideo.mp4")
        let exporter: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.outputFileType = AVFileType.mp4
        exporter.outputURL = mutableVideoURL as URL
        removeFileAtURLIfExists(url: mutableVideoURL)
        exporter.exportAsynchronously(completionHandler:
                                        {
            switch exporter.status
            {
            case AVAssetExportSession.Status.failed:
                print("failed \(exporter.error)")
                completion(nil , exporter.error)
            case AVAssetExportSession.Status.cancelled:
                print("cancelled \(exporter.error)")
                completion(nil , exporter.error)
            case AVAssetExportSession.Status.unknown:
                print("unknown\(exporter.error)")
                completion(nil , exporter.error)
            case AVAssetExportSession.Status.waiting:
                print("waiting\(exporter.error)")
                completion(nil , exporter.error)
            case AVAssetExportSession.Status.exporting:
                print("exporting\(exporter.error)")
                completion(nil , exporter.error)
            default:
                print("-----Mutable video exportation complete.")
                completion(self.mutableVideoURL as URL , nil)
            }
        })
    }

    func removeFileAtURLIfExists(url: NSURL) {
        if let filePath = url.path {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                do{
                    try fileManager.removeItem(atPath: filePath)
                } catch let error as NSError {
                    print("Couldn't remove existing destination file: \(error)")
                }
            }
        }
    }
    
    func addStickerorTexttoVideo(textBgClr: UIColor , textForeClr: UIColor , fontNm: Int , videoUrl: URL, watermarkText text : String, imageName name : String, position : Int,  success: @escaping ((URL) -> Void), failure: @escaping ((String?) -> Void)) {
        
        
        let asset          = AVURLAsset.init(url: videoUrl)
        let composition    = AVMutableComposition.init()
        composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let clipVideoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]
        
        // Rotate to potrait
        let transformer    = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        let videoTransform:CGAffineTransform = clipVideoTrack.preferredTransform
        
        
        //fix orientation
        var videoAssetOrientation            = UIImage.Orientation.up
        
        var isVideoAssetPortrait             = false
        
        if videoTransform.a                  == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0 {
            videoAssetOrientation            = UIImage.Orientation.right
            isVideoAssetPortrait             = true
        }
        if videoTransform.a  == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0 {
            videoAssetOrientation =  UIImage.Orientation.left
            isVideoAssetPortrait  = true
        }
        if videoTransform.a  == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0 {
            videoAssetOrientation =  UIImage.Orientation.up
        }
        if videoTransform.a  == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0 {
            videoAssetOrientation = UIImage.Orientation.down;
        }
        
        transformer.setTransform(clipVideoTrack.preferredTransform, at: CMTime.zero)
        transformer.setOpacity(0.0, at: asset.duration)
        
        //adjust the render size if neccessary
        var naturalSize: CGSize
        if(isVideoAssetPortrait){
            naturalSize = CGSize(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.width)
        } else {
            naturalSize = clipVideoTrack.naturalSize;
        }
        
        var renderWidth  : CGFloat!
        var renderHeight : CGFloat!
        
        renderWidth  = naturalSize.width
        renderHeight = naturalSize.height
        
        let parentlayer    = CALayer()
        let videoLayer     = CALayer()
        let watermarkLayer = CALayer()
        
        let videoComposition        = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: renderWidth, height: renderHeight)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.renderScale   = 1.0
        
        parentlayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
        videoLayer.frame  = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
        parentlayer.addSublayer(videoLayer)
        
        
        if name != "" {
            let stickerView:UIView = UIView.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize))
            let sticker:UIImageView = UIImageView.init()
            sticker.image       = UIImage(named: name)
            sticker.contentMode = .scaleAspectFit
            let stickerWidth = renderWidth / 6
            let stickerX     = renderWidth * CGFloat(5 * (position % 3)) / 12
            let stickerY     = (renderHeight - ( renderHeight * CGFloat(position / 3) / 3)) - 150
            sticker.frame    = CGRect(x:stickerX, y: stickerY, width: stickerWidth, height: stickerWidth)
            stickerView.addSubview(sticker)
            watermarkLayer.contents = stickerView.asImage().cgImage
            watermarkLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
            parentlayer.addSublayer(watermarkLayer)
        }
        
        // Create textFont variable outside the if block
        let textFont: UIFont

        if fontNm == 0 {
            textFont = CTFontCreateWithName("Helvetica" as CFString, 60, nil)
        } else if fontNm == 1 {
            textFont = CTFontCreateWithName("Helvetica-Bold" as CFString, 60, nil)
        } else if fontNm == 2 {
            textFont = CTFontCreateWithName("Helvetica-Oblique" as CFString, 60, nil)
        } else if fontNm == 3 {
            textFont = CTFontCreateWithName("TimesNewRomanPSMT" as CFString, 60, nil)
        } else {
            textFont = UIFont.systemFont(ofSize: 60)
        }

        if text != "" {
            // Remove any existing text layers from parentlayer
            parentlayer.sublayers?.forEach { layer in
                if layer is CATextLayer {
                    layer.removeFromSuperlayer()
                }
            }
            
            let textLayer = CATextLayer()
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: textFont,
                .foregroundColor: textForeClr
            ]
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            textLayer.string = attributedString
            
            // Calculate text size
            let textSize = attributedString.size()
            
            // Adjust text layer size and position
            let padding: CGFloat = 10
            let textWidth   = textSize.width + (3 * padding)
            let textHeight  = textSize.height + (2 * padding)
            let textX = (renderWidth - textWidth) / 2
            let textY = position == 0 ? renderHeight - textHeight - 80 : position == 1 ? (renderHeight - textHeight) / 2 :  20
                textLayer.frame = CGRect(x: textX + 10, y: textY + 20, width: textWidth + 20, height: textHeight + 60)
            
            textLayer.opacity = 0.6
            textLayer.backgroundColor = textBgClr.cgColor
            textLayer.foregroundColor = textForeClr.cgColor
            textLayer.cornerRadius = 6
            
            parentlayer.addSublayer(textLayer)
        }



        
        //Create Directory path for Save
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var outputURL = documentDirectory.appendingPathComponent("StickerVideo")
        do {
            try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(outputURL.lastPathComponent).m4v")
        }catch let error {
            print(error)
        }
        
        //Remove existing file
        self.deleteFile(outputURL)
        
        // Add watermark to video
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentlayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exporter = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputFileType = AVFileType.mov
        exporter?.outputURL = outputURL
        exporter?.videoComposition = videoComposition
        
        exporter!.exportAsynchronously(completionHandler: {() -> Void in
            
            switch exporter!.status {
            case .completed :
                success(outputURL)
            case .failed:
                if let _error = exporter?.error?.localizedDescription {
                    failure(_error)
                }
            case .cancelled:
                if let _error = exporter?.error?.localizedDescription {
                    failure(_error)
                }
            default:
                if let _error = exporter?.error?.localizedDescription {
                    failure(_error)
                }
            }
        })
    }
    
    func deleteFile(_ filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
}
