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
    
    func addStickerorTexttoVideo(textBgClr: UIColor , textForeClr: UIColor , fontNm: Int , videoUrl: URL, watermarkText text : String, imageName name : String, position : Int , xPosition : Int ,  success: @escaping ((URL) -> Void), failure: @escaping ((String?) -> Void)) {
        
        
        let asset = AVURLAsset(url: videoUrl)
        let composition = AVMutableComposition()
        composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let clipVideoTrack = asset.tracks(withMediaType: .video)[0]
        
        // Rotate to portrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        let videoTransform = clipVideoTrack.preferredTransform
        
        // Fix orientation
        var videoAssetOrientation = UIImage.Orientation.up
        var isVideoAssetPortrait = false
        
        if videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0 {
            videoAssetOrientation = UIImage.Orientation.right
            isVideoAssetPortrait = true
        }
        if videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0 {
            videoAssetOrientation = UIImage.Orientation.left
            isVideoAssetPortrait = true
        }
        if videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0 {
            videoAssetOrientation = UIImage.Orientation.up
        }
        if videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0 {
            videoAssetOrientation = UIImage.Orientation.down
        }
        
        transformer.setTransform(clipVideoTrack.preferredTransform, at: CMTime.zero)
        transformer.setOpacity(0.0, at: asset.duration)
        
        // Adjust the render size if necessary
        var naturalSize: CGSize
        if isVideoAssetPortrait {
            naturalSize = CGSize(width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.width)
        } else {
            naturalSize = clipVideoTrack.naturalSize
        }
        
        var renderWidth: CGFloat!
        var renderHeight: CGFloat!
        
        renderWidth = naturalSize.width
        renderHeight = naturalSize.height
        
        let parentlayer = CALayer()
        let videoLayer = CALayer()
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: renderWidth, height: renderHeight)
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.renderScale = 1.0
        
        parentlayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
        videoLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize)
        parentlayer.addSublayer(videoLayer)
        
        if name != "" {
            let stickerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: naturalSize))
            let sticker = UIImageView()
            sticker.image = UIImage(named: name)
            sticker.contentMode = .scaleAspectFit
            let stickerWidth = renderWidth / 6
            let stickerX = renderWidth * CGFloat(5 * (position % 3)) / 12
            let stickerY = (renderHeight - (renderHeight * CGFloat(position / 3) / 3)) - 150
            sticker.frame = CGRect(x:stickerX, y: stickerY, width: stickerWidth, height: stickerWidth)
            stickerView.addSubview(sticker)
            videoLayer.addSublayer(stickerView.layer)
        }
        
        // Create textFont variable
        let textFont: UIFont
        
        switch fontNm {
        case 0:
            textFont = UIFont(name: "HelveticaNeue", size: 60) ?? UIFont.systemFont(ofSize: 60)
        case 1:
            textFont = UIFont(name: "Helvetica-Bold", size: 60) ?? UIFont.systemFont(ofSize: 60)
        case 2:
            textFont = UIFont(name: "Helvetica-Oblique", size: 60) ?? UIFont.systemFont(ofSize: 60)
        case 3:
            textFont = UIFont(name: "TimesNewRomanPSMT", size: 60) ?? UIFont.systemFont(ofSize: 60)
        default:
            textFont = UIFont.systemFont(ofSize: 60)
        }
        
        if text != "" {
            // Remove any existing text layers
            parentlayer.sublayers?.forEach { layer in
                if layer is CATextLayer {
                    layer.removeFromSuperlayer()
                }
            }
            
            // Create text layer
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
            let textWidth = textSize.width + (2 * padding)
            let textHeight = textSize.height + (2 * padding)

            // Determine textX based on the 3 positions (left, center, right)
            let xSpacing = renderWidth / 3 // Equal spacing for x-axis

//            let textX: CGFloat
//            switch xPosition {
//            case 0:
//                textX = max(20, xSpacing - textWidth / 2) // Left
//            case 1:
//                textX = max(20, 2 * xSpacing - textWidth / 2) // Center
//            case 2:
//                textX = max(20, renderWidth - xSpacing - textWidth / 2) // Right
//            default:
//                textX = max(20, (renderWidth - textWidth) / 2) // Default to center if position is out of range
//            }

            // Determine textY based on the 12 vertical positions
            let ySpacing = renderHeight / 12 // Equal spacing for y-axis

            let textY: CGFloat
            switch position {
            case 0:
                textY = max(20, ySpacing - textHeight / 2) // Topmost
            case 1:
                textY = 1600 // Second position   //275
            case 2:
                textY = 1400
            case 3:
                textY = 1200
            case 4:
                textY = 1100
            case 5:
                textY = max(20, 6 * ySpacing - textHeight / 2) // Sixth position 915
            case 6:
                textY = 800 //max(20, 7 * ySpacing - textHeight / 2) // Seventh position
            case 7:
                textY = 700 //max(20, 8 * ySpacing - textHeight / 2) // Eighth position
            case 8:
                textY = 600 //max(20, 9 * ySpacing - textHeight / 2) // Ninth position
            case 9:
                textY = 400 //max(20, 10 * ySpacing - textHeight / 2) // Tenth position
            case 10:
                textY = 400 //max(20, 11 * ySpacing - textHeight / 2) // Eleventh position
            case 11:
                textY = 300 //max(20, renderHeight - ySpacing - textHeight / 2) // Bottommost
            default:
                textY = 200 //max(20, (renderHeight - textHeight) / 2) // Default to center if position is out of range
            }

            // Determine textX based on the 3 x-axis positions (leading, center, trailing)
            // Determine textX based on the 3 x-axis positions (leading, center, trailing)
            let viewWidth = self.view.bounds.width
           // let xSpacing = viewWidth / 3 // Divide width into three equal parts

            let textX: CGFloat
            print(xPosition)
            switch xPosition {
            case 0:
                textX = 10 // Leading side, 10 points from the leading edge
            case 1:
                textX = (viewWidth - textWidth) / 2 + 350 // Center, text layer is centered horizontally
            case 2:
                textX = (viewWidth - textWidth) / 2 + 500 // Trailing side, 10 points from the trailing edge
            default:
                textX = (viewWidth - textWidth) / 2 // Default to center if position is out of range
            }

            // Ensure text doesn't cross the top border
            textLayer.frame = CGRect(x: textX, y: textY, width: textWidth, height: textHeight)

            
//            // Adjust text layer size and position
//            let padding: CGFloat = 10
//            let textWidth = textSize.width + (2 * padding)
//            let textHeight = textSize.height + (2 * padding)
//            let textX = (renderWidth - textWidth) / 2
//
//            // Determine textY based on the 6 positions
//            let spacing = renderHeight / 6 // Equal spacing
//
//            let textY: CGFloat
//            switch position {
//            case 0:
//                textY = max(20, spacing - textHeight / 2) // Topmost
//            case 1:
//                textY = max(20, renderHeight - spacing - textHeight / 2) // Bottommost
//            case 2:
//                textY = max(20, 4 * spacing - textHeight / 2) // Middle bottom
//            case 3:
//                textY = max(20, 3 * spacing - textHeight / 2) // Middle top
//            case 4:
//                textY = 150
//            case 5:
//                textY = 20
//            default:
//                textY = max(20, (renderHeight - textHeight) / 2) // Default to center if position is out of range
//            }
//
//            // Ensure text doesn't cross the top border
//            textLayer.frame = CGRect(x: textX, y: textY, width: textWidth, height: textHeight)
//            
            textLayer.opacity = 1.0 // Set opacity to 1.0 to ensure full visibility
            textLayer.backgroundColor = textBgClr.cgColor
            textLayer.foregroundColor = textForeClr.cgColor
            textLayer.cornerRadius = 6
            
            parentlayer.addSublayer(textLayer)
        }
        
        // Create Directory path for Save
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var outputURL = documentDirectory.appendingPathComponent("StickerVideo")
        do {
            try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(outputURL.lastPathComponent).m4v")
        } catch let error {
            print(error)
        }
        
        // Remove existing file
        self.deleteFile(outputURL)
        
        // Add watermark to video
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentlayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputFileType = AVFileType.mov
        exporter?.outputURL = outputURL
        exporter?.videoComposition = videoComposition
        
        exporter?.exportAsynchronously(completionHandler: {() -> Void in
            
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
