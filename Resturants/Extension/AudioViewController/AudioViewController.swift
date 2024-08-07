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
        self.startAnimating()
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                self.stopAnimating()
                DispatchQueue.main.async {
                    if allowed {
                    } else {
                        self.showAlertWith(title: "Error", message: "kindly Allow Permission for Audio Recording.")
                    }
                }
            }
        } catch {
            self.stopAnimating()
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
    
    func getVideoDuration(from url: URL, completion: @escaping (Double?) -> Void) {
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let durationInSeconds = CMTimeGetSeconds(duration)
        completion(durationInSeconds)
    }
    
    //MARK: crop the video which you select portion
    func trimVideo(sourceURL: URL, startTime: Double, endTime: Double, success: @escaping ((URL) -> Void), failure: @escaping ((String?) -> Void)) {
        
        /// Asset
        let asset = AVAsset(url: sourceURL)
        _ = Float(asset.duration.value) / Float(asset.duration.timescale)
//        print("video length: \(length) seconds")
        
        //Create Directory path for Save
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var outputURL = documentDirectory.appendingPathComponent("TrimVideo")
        do {
            try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(outputURL.lastPathComponent).m4v")
        }catch let error {
            print(error)
        }
        
        //Remove existing file
        self.deleteFile(outputURL)
        
        //export the video to as per your requirement conversion
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else { return }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        let timeRange = CMTimeRange(start: CMTime(seconds: startTime, preferredTimescale: asset.duration.timescale),end: CMTime(seconds: endTime, preferredTimescale: asset.duration.timescale))
        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status {
            case .completed:
                success(outputURL)
                
            case .failed:
                failure(exportSession.error?.localizedDescription)
                
            case .cancelled:
                failure(exportSession.error?.localizedDescription)
                
            default:
                failure(exportSession.error?.localizedDescription)
            }
        })
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
    func addStickerorTexttoVideo(
        textBgClr: UIColor,
        textForeClr: UIColor,
        fontNm: Int,
        videoUrl: URL,
        watermarkText text: String,
        imageName name: String,
        position: CGFloat,
        xPosition: CGFloat,
        success: @escaping ((URL) -> Void),
        failure: @escaping ((String?) -> Void)
    ) {
        let asset = AVURLAsset(url: videoUrl)
        let composition = AVMutableComposition()
        let videoTrack = asset.tracks(withMediaType: .video)[0]
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoTrack.naturalSize
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        // Create a video layer and a parent layer
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        
        parentLayer.frame = CGRect(origin: .zero, size: videoTrack.naturalSize)
        videoLayer.frame = CGRect(origin: .zero, size: videoTrack.naturalSize)
        parentLayer.addSublayer(videoLayer)
        
        // Add sticker if provided
//        if !name.isEmpty {
//            let sticker = UIImageView(image: UIImage(named: name))
//            sticker.contentMode = .scaleAspectFit
//            let stickerWidth = videoComposition.renderSize.width / 6
//            let stickerX = videoComposition.renderSize.width * CGFloat(5 * (position % 3)) / 12
//            let stickerY = (videoComposition.renderSize.height - (videoComposition.renderSize.height * CGFloat(position / 3) / 3)) - 150
//            sticker.frame = CGRect(x: stickerX, y: stickerY, width: stickerWidth, height: stickerWidth)
//            
//            let stickerLayer = CALayer()
//            stickerLayer.contents = sticker.image?.cgImage
//            stickerLayer.frame = sticker.frame
//            parentLayer.addSublayer(stickerLayer)
//        }
        
        // Create text layer
        if !text.isEmpty {
            let textLayer = CATextLayer()
            
            // Determine font based on fontNm
            let font: UIFont
            switch fontNm {
            case 0:
                font = UIFont.systemFont(ofSize: 60)
            case 1:
                font = UIFont.boldSystemFont(ofSize: 60)
            case 2:
                font = UIFont.italicSystemFont(ofSize: 60)
            case 3:
                font = UIFont(name: "TimesNewRomanPSMT", size: 60) ?? UIFont.systemFont(ofSize: 60)
            case 4:
                font = UIFont.systemFont(ofSize: 60)
            default:
                font = UIFont.systemFont(ofSize: 60)
            }
            
            textLayer.string = text
            textLayer.font = font
            textLayer.fontSize = font.pointSize
            textLayer.foregroundColor = textForeClr.cgColor
            textLayer.backgroundColor = textBgClr.cgColor
            textLayer.alignmentMode = .center // Center alignment by default
            textLayer.cornerRadius = 6
            textLayer.isWrapped = true
            
            // Calculate text size
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textForeClr
            ]
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            let textSize = attributedString.size()
            let padding: CGFloat = 10
            let textWidth = textSize.width + (2 * padding)
            let textHeight = textSize.height + (2 * padding)
            
            // Determine text position based on xPosition and position
            let maxTextX = videoComposition.renderSize.width - textWidth
            var textX: CGFloat
            
            switch xPosition {
            case 0: // Leading
                textX = 0
               // textLayer.alignmentMode = .left
            case 1: // Center
                textX = (videoComposition.renderSize.width - textWidth) / 2
              //  textLayer.alignmentMode = .center
            case 2: // Trailing
                textX = maxTextX
               // textLayer.alignmentMode = .right
            default:
                textX = 0
               // textLayer.alignmentMode = .left
            }
            
            let ySpacing = videoComposition.renderSize.height / 12
            let textY: CGFloat
            switch position {
            case 0:
                textY = max(20, 12 * ySpacing - textHeight / 2)
            case 1:
                textY = 1700
            case 2:
                textY = 1600
            case 3:
                textY = 1400
            case 4:
                textY = 1200
            case 5:
                textY = 1000
            case 6:
                textY = 800
            case 7:
                textY = 600
            case 8:
                textY = 400
            case 9:
                textY = 330
            case 10:
                textY = 200
            case 11:
                textY = 10
            default:
                textY = 10
            }
            
            // Set the frame of the textLayer
            textLayer.frame = CGRect(x: textX, y: textY, width: textWidth, height: textHeight)
            textLayer.opacity = 1.0 // Set opacity to 1.0 to ensure full visibility
            
            // Set beginTime and duration to match the video duration
            textLayer.beginTime = AVCoreAnimationBeginTimeAtZero
            textLayer.duration = CFTimeInterval(asset.duration.seconds)
            
            // Force the layer to render its contents immediately
            DispatchQueue.main.async {
                textLayer.displayIfNeeded()
            }
            
            parentLayer.addSublayer(textLayer)
            
            print("Text Layer Frame: \(textLayer.frame)")  // Debugging log
            print("Text Layer Start Time: \(CMTime.zero)") // Log the start time of the text layer
        }


        
        // Add animation tool
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayers: [videoLayer], in: parentLayer)
        
        // Create video composition instruction
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)
        
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        transformer.setTransform(videoTrack.preferredTransform, at: .zero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        // Export the video
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var outputURL = documentDirectory.appendingPathComponent("StickerVideo")
        do {
            try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(outputURL.lastPathComponent).m4v")
        } catch let error {
            print(error)
        }
        
        deleteFile(outputURL)
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputFileType = .mov
        exporter?.outputURL = outputURL
        exporter?.videoComposition = videoComposition
        
        exporter?.exportAsynchronously {
            switch exporter?.status {
            case .completed:
                success(outputURL)
            case .failed:
                failure(exporter?.error?.localizedDescription)
            case .cancelled:
                failure(exporter?.error?.localizedDescription)
            default:
                failure(exporter?.error?.localizedDescription)
            }
        }
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
