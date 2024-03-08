//
//  CameraConfiguration.swift
//  Resturants
//
//  Created by shah on 02/03/2024.
//

import Foundation
import AVFoundation
import UIKit
import MobileCoreServices
import Photos

class CameraConfiguration: NSObject {
    
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
    
    public enum OutputType {
        case photo
        case video
    }
    
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    var audioDevice: AVCaptureDevice?
    
    var currentCameraPosition: CameraPosition?
    var frontCameraInput: AVCaptureDeviceInput?
    var rearCameraInput: AVCaptureDeviceInput?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var flashMode: AVCaptureDevice.FlashMode = AVCaptureDevice.FlashMode.off
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var videoRecordCompletionBlock: ((URL?, Error?) -> Void)?
    let device = AVCaptureDevice.default(for: .video)
    var videoDevice: AVCaptureDevice?
    var videoOutput: AVCaptureMovieFileOutput?
    var audioInput: AVCaptureDeviceInput?
    var outputType: OutputType?
    
}

extension CameraConfiguration {
     
    func applyFilterToPreview(_ filterName: String) {
        guard let previewLayer = self.previewLayer else { return }
        
        // Create a filter
        guard let filter = CIFilter(name: filterName) else {
            print("Failed to create filter")
            return
        }
        
        // Apply the filter to the video preview
        previewLayer.filters = [filter]
    }
    
    func toggleFlashlight() {
           guard let device = videoDevice else { return }
           
           do {
               try device.lockForConfiguration()
               
               if device.torchMode == .off {
                   device.torchMode = .on
               } else {
                   device.torchMode = .off
               }
               
               device.unlockForConfiguration()
           } catch {
               print("Error toggling flashlight: \(error.localizedDescription)")
           }
       }

    func setup(handler: @escaping (Error?)-> Void ) {
        
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            let session = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
            
            let cameras = (session.devices.compactMap{$0})
            // Check if the device has a flashlight
            if let device = AVCaptureDevice.default(for: .video), device.hasTorch {
                self.videoDevice = device
            }
                    
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                if camera.position == .back {
                    self.rearCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
            self.audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
        }
        
        //Configure inputs with capture session
        //only allows one camera-based input per capture session at a time.
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            if let rearCamera = self.rearCamera {
                self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
                if captureSession.canAddInput(self.rearCameraInput!) {
                    captureSession.addInput(self.rearCameraInput!)
                    self.currentCameraPosition = .rear
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
            }
                
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                if captureSession.canAddInput(self.frontCameraInput!) {
                    captureSession.addInput(self.frontCameraInput!)
                    self.currentCameraPosition = .front
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
            }
                
            else {
                throw CameraControllerError.noCamerasAvailable
            }
            
            if let audioDevice = self.audioDevice {
                self.audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if captureSession.canAddInput(self.audioInput!) {
                    captureSession.addInput(self.audioInput!)
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
            }
        }
        
        //Configure outputs with capture session
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }
            
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg ])], completionHandler: nil)
            if captureSession.canAddOutput(self.photoOutput!) {
                captureSession.addOutput(self.photoOutput!)
            }
            self.outputType = .photo
            captureSession.startRunning()
        }
        func configureVideoOutput() throws {
            guard let captureSession = self.captureSession else {
                throw CameraControllerError.captureSessionIsMissing
            }

            self.videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(self.videoOutput!) {
                captureSession.addOutput(self.videoOutput!)
            }
            
            
            
//            let delayTime = dispatch_time(dispatch_time_t(DispatchTime.now()), Int64(5 * Double(NSEC_PER_SEC)))
//            dispatch_after(delayTime, dispatch_get_main_queue()) {
//                print("stopping")
//                self.movieOutput.stopRecording()
//            }
            
        }
        
        DispatchQueue(label: "setup").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
                try configureVideoOutput()
            } catch {
                DispatchQueue.main.async {
                    handler(error)
                }
                return
            }
            
            DispatchQueue.main.async {
                handler(nil)
            }
        }
    }

    func displayPreview(_ view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition, let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs
        
        func switchToFrontCamera() throws {
            guard let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),let frontCamera = self.frontCamera else { throw CameraControllerError.invalidOperation }
            captureSession.removeInput(rearCameraInput)
            self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                self.currentCameraPosition = .front
            }
            
            else { throw CameraControllerError.invalidOperation }
        }
        
        func switchToRearCamera() throws {
            guard let frontCameraInput = self.frontCameraInput, inputs.contains(frontCameraInput), let rearCamera = self.rearCamera else { throw CameraControllerError.invalidOperation }
            captureSession.removeInput(frontCameraInput)
            self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
            if captureSession.canAddInput(rearCameraInput!) {
                captureSession.addInput(rearCameraInput!)
                self.currentCameraPosition = .rear
            }
            
            else { throw CameraControllerError.invalidOperation }
        }
        
        switch currentCameraPosition {
        case .front:
            try switchToRearCamera()
            
        case .rear:
            try switchToFrontCamera()
        }
        captureSession.commitConfiguration()
    }

    
    func captureImage(completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        let settings = AVCapturePhotoSettings()
        settings.flashMode = self.flashMode
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    func recordVideo(completion: @escaping (URL?, Error?)-> Void) {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            completion(nil, CameraControllerError.captureSessionIsMissing)
            return
        }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.mp4")
        try? FileManager.default.removeItem(at: fileUrl)
        videoOutput!.startRecording(to: fileUrl, recordingDelegate: self)
        self.videoRecordCompletionBlock = completion
    }
    
    func stopRecording(completion: @escaping (Error?)->Void) {
        guard let captureSession = self.captureSession, captureSession.isRunning else {
            completion(CameraControllerError.captureSessionIsMissing)
            return
        }
        self.videoOutput?.stopRecording()
    }
}

extension CameraConfiguration: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
        if let data = photo.fileDataRepresentation() {
            let image = UIImage(data: data)
            self.photoCaptureCompletionBlock?(image, nil)
        }
        else {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
        }
    }
    
    func convert(cmage:CIImage) -> UIImage
    {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    
}

extension CameraConfiguration: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if error == nil {
            self.videoRecordCompletionBlock?(outputFileURL, nil)
        } else {
            self.videoRecordCompletionBlock?(nil, error)
        }
    }
}

extension CameraConfiguration: AVCaptureVideoDataOutputSampleBufferDelegate {
    
}


enum Media {
    
    static let AllowedMediaTypes = [kUTTypeMovie as String]
    static let VideoQualityPreset = [
        0: AVAssetExportPreset640x480,
        1: AVAssetExportPreset1280x720,
        2: AVAssetExportPreset1920x1080
    ]
    static let ChunkSize = 10000000 // 10MB in Bytes
}
import Photos
extension AVAsset {

    func exportFilterVideo(video: AVURLAsset, videoComposition: AVVideoComposition, completion: @escaping (_ success: Bool) -> Void) {
        
        let exportSession = AVAssetExportSession(asset: video, presetName: AVAssetExportPresetHighestQuality)!
        let croppedOutputFileUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString + ".mp4")
        exportSession.outputURL = croppedOutputFileUrl
        exportSession.outputFileType = .mp4 // Adjust file type if needed
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously {
            DispatchQueue.main.async {
                guard exportSession.status == .completed, FileManager.default.fileExists(atPath: croppedOutputFileUrl.path) else {
                    completion(false)
                    return
                }
                
                // Save to photo library
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: croppedOutputFileUrl)
                }) { success, error in
                    if success {
                        completion(true)
                    } else {
                        print("Error saving video to photo library: \(error?.localizedDescription ?? "Unknown error")")
                        completion(false)
                    }
                }
            }
        }
    }


    
    static func squareCropVideo(inputURL: NSURL, completion: @escaping (_ outputURL : NSURL?) -> ())
    {
        let videoAsset: AVAsset = AVAsset( url: inputURL as URL )
        let clipVideoTrack = videoAsset.tracks( withMediaType: AVMediaType.video ).first! as AVAssetTrack
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize( width: clipVideoTrack.naturalSize.height, height: clipVideoTrack.naturalSize.height )
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration)
        
        transformer.setTransform(configureTransformation(clipVideoTrack: clipVideoTrack), at: CMTime.zero)
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exportSession = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)!
        let fileName: String = NSUUID().uuidString
        let croppedOutputFileUrl = URL( fileURLWithPath: NSTemporaryDirectory() + fileName + ".mov")
        
        exportSession.outputURL = croppedOutputFileUrl
        exportSession.outputFileType = AVFileType.mov
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously(completionHandler: {
            print("completion")
            if exportSession.status == .completed {
                DispatchQueue.main.async(execute: {
                    completion(croppedOutputFileUrl as NSURL)
                })
                return
            } else if exportSession.status == .failed {
                print("Export failed - \(String(describing: exportSession.error))")
            }
            
            completion(nil)
            return
        })
    }
    
    static func configureTransformation(clipVideoTrack:AVAssetTrack) -> CGAffineTransform {
        
        if(clipVideoTrack.naturalSize.width == clipVideoTrack.naturalSize.height){
            return clipVideoTrack.preferredTransform
        }
        
        let videoTransform:CGAffineTransform = clipVideoTrack.preferredTransform
        let orientation:UIInterfaceOrientation = getVideoOrientation(transform: videoTransform, track: clipVideoTrack)
        let transform1: CGAffineTransform
        var transform2: CGAffineTransform
        switch(orientation){
        case .portrait:
            transform1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
            transform2 = transform1.rotated(by: .pi/2)
            break
        case .portraitUpsideDown:
            transform1 = CGAffineTransform(translationX: 0, y:clipVideoTrack.naturalSize.width - ((clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2))
            transform2 = transform1.rotated(by: -.pi/2)
            break
        case .landscapeLeft:
            transform1 = CGAffineTransform(translationX:clipVideoTrack.naturalSize.width - ((clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2), y: clipVideoTrack.naturalSize.height)
            transform2 = transform1.rotated(by: .pi)
            break
        case .landscapeRight:
            transform1 = CGAffineTransform(translationX:0 - ((clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2),y: 0);
            transform2 =  transform1.rotated(by: 0)
            break
        default:
            transform1 = videoTransform
            transform2 = transform1.rotated(by: 0)
            break
        }
        
        return transform2
    }
    
    static func getVideoOrientation(transform:CGAffineTransform, track: AVAssetTrack) -> UIInterfaceOrientation {
        switch (transform.tx, transform.ty) {
        case (0, 0):
            return .landscapeRight
        case (track.naturalSize.width, track.naturalSize.height):
            return .landscapeLeft
        case (0, track.naturalSize.width):
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
}
