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
    
    func addTextVideo(textBgClr: UIColor, textForeClr: UIColor, text: String, fontNm: String, videoURL: URL, completion: @escaping (URL?) -> Void) {
        let vidAsset = AVURLAsset(url: videoURL, options: nil)
        let composition = AVMutableComposition()
        
        // get video track
        guard let videoTrack = vidAsset.tracks(withMediaType: AVMediaType.video).first else {
            print("Unable to get video track")
            completion(nil)
            return
        }
        
        let vid_timerange = CMTimeRangeMake(start: CMTime.zero, duration: vidAsset.duration)
        
        let compositionvideoTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        do {
            try compositionvideoTrack?.insertTimeRange(vid_timerange, of: videoTrack, at: CMTime.zero)
            compositionvideoTrack?.preferredTransform = videoTrack.preferredTransform
        } catch {
            print("Error inserting video track")
            completion(nil)
            return
        }
        
        // Create text Layer
        let titleLayer = CATextLayer()
        titleLayer.backgroundColor = textBgClr.cgColor
        titleLayer.foregroundColor = textForeClr.cgColor
        titleLayer.string = text
        titleLayer.font = UIFont(name: fontNm, size: 20)
        titleLayer.shadowOpacity = 0.5
        titleLayer.alignmentMode = .center
        titleLayer.frame = CGRect(x: 0, y: 50, width: videoTrack.naturalSize.width, height: videoTrack.naturalSize.height / 6)
        
        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: videoTrack.naturalSize.width, height: videoTrack.naturalSize.height)
        parentlayer.addSublayer(titleLayer)
        
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        layercomposition.renderSize = videoTrack.naturalSize
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: parentlayer, in: parentlayer)
        
        // Instruction for watermark
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        instruction.layerInstructions = [layerinstruction]
        layercomposition.instructions = [instruction]
        
        // Create a new file to receive data
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        let movieFilePath = docsDir.appendingPathComponent("result.mov")
        let movieDestinationUrl = URL(fileURLWithPath: movieFilePath)
        
        // Use AVAssetExportSession to export video
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = .mov
        assetExport?.videoComposition = layercomposition
        assetExport?.outputURL = movieDestinationUrl
        
        // Check existence and remove old file
        FileManager.default.removeItemIfExisted(movieDestinationUrl)
        
        assetExport?.exportAsynchronously {
            switch assetExport!.status {
            case .failed:
                if let error = assetExport?.error {
                    print("Export failed with error: \(error)")
                } else {
                    print("Export failed with unknown error.")
                }
                completion(nil)
            case .cancelled:
                print("Export cancelled.")
                completion(nil)
            default:
                print("Movie export completed successfully.")
                completion(movieDestinationUrl)
                
                // Save video to photo library
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieDestinationUrl)
                }) { saved, error in
                    if saved {
                        print("Video saved to photo library.")
                    } else if let error = error {
                        print("Failed to save video to photo library: \(error)")
                    }
                }
            }
        }
    }



}
