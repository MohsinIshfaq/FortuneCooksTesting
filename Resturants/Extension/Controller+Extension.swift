//
//  Controller+Extension.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation
import UIKit
import SDWebImage
import NVActivityIndicatorView
import AVFoundation

extension UIViewController {
    
    
    //MARK: - Navigation Handling {}
    func hideNavBar(){
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func showNavBar(){
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func removeNavBackbuttonTitle() {
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    func hideNavBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func popRoot() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popup() {
        self.navigationController?.popViewController(animated: true)
    }
    func isInvalidTimeString(_ timeString: String) -> Bool {
        // Check if the string starts with "00:"
        if timeString.hasPrefix("00:") {
            return true
        }
        return false
    }

    func isRestaurantOpen(timeRange: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // Split the input string into opening and closing times
        let times = timeRange.split(separator: "-")
        guard times.count == 2 else {
            Swift.print("Invalid time range format")
            return false
        }
        
        let openingTimeString = times[0].trimmingCharacters(in: .whitespaces)
        let closingTimeString = times[1].trimmingCharacters(in: .whitespaces)
        
        guard let openTime = dateFormatter.date(from: openingTimeString),
              let closeTime = dateFormatter.date(from: closingTimeString) else {
            Swift.print("Invalid time format")
            return false
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinute = calendar.component(.minute, from: currentDate)
        
        guard let currentTime = dateFormatter.date(from: String(format: "%02d:%02d", currentHour, currentMinute)) else {
            Swift.print("Could not form current time")
            return false
        }
        
        if currentTime >= openTime && currentTime <= closeTime {
            return true
        } else {
            return false
        }
    }
    
    func isOneHourOrLessLeft(timeRange: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // Remove any extra spaces in the time range
        let trimmedRange = timeRange.replacingOccurrences(of: " ", with: "")
        
        // Split the input string into opening and closing times
        let times = trimmedRange.split(separator: "-")
        guard times.count == 2 else {
            Swift.print("Invalid time range format")
            return false
        }
        
        let closingTimeString = String(times[1])
        
        guard let closeTime = dateFormatter.date(from: closingTimeString) else {
            Swift.print("Invalid time format for closing time: \(closingTimeString)")
            return false
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Get the current time components
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentMinute = calendar.component(.minute, from: currentDate)
        let currentTimeString = String(format: "%02d:%02d", currentHour, currentMinute)
        
        guard let currentTime = dateFormatter.date(from: currentTimeString) else {
            Swift.print("Invalid time format for current time: \(currentTimeString)")
            return false
        }
        
        // Debug prints
        Swift.print("Current time: \(currentTimeString)")
        Swift.print("Closing time: \(closingTimeString)")
        
        // Calculate the time difference in minutes
        let timeDifference = closeTime.timeIntervalSince(currentTime) / 60
        
        // Debug prints
        Swift.print("Time difference in minutes: \(timeDifference)")
        
        // Return true if there is 60 minutes or less left before closing
        return timeDifference <= 60 && timeDifference >= 0
    }

    func getCurrentDayOfWeek() -> (String, Int) {
        let date = Date()
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.string(from: date)
        
        // Adjusting to make Sunday = 6
        let dayIndex = (dayOfWeek + 5) % 7

        return (dayName, dayIndex)
    }

    func performAction(completion: @escaping () -> Void) {
            // Simulate a network request or any other action that takes time
            DispatchQueue.global().async {
                // Simulate a delay
                sleep(2)
                
                // Once the action is complete, call the completion handler
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    
    //MARK: - Button Animation {}
    func buttonaAnimation(Ontap:UIButton , completion: @escaping ((Bool)->Void)) {
        UIButton.animate(withDuration: 0.2,
                         animations: {
            Ontap.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                         completion: { _ in
            UIView.animate(withDuration: 0.2) {
                Ontap.transform = CGAffineTransform.identity
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    completion(true)
                }
            }
        })
    }
    
    func viewBounceAnimation(Ontap:UIView , completion: @escaping ((Bool)->Void)) {
        UIView.animate(withDuration: 0.2,
                         animations: {
            Ontap.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                        completion: { _ in
            UIView.animate(withDuration: 0.2) {
                Ontap.transform = CGAffineTransform.identity
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    completion(true)
                }
            }
        })
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
    
    func getVideoDimensions(url: URL) -> (width: Int, height: Int)? {
        let asset = AVAsset(url: url)
        guard let track = asset.tracks(withMediaType: .video).first else {
            return nil
        }
        let size = track.naturalSize.applying(track.preferredTransform)
        let width = abs(size.width)
        let height = abs(size.height)
        return (width: Int(width), height: Int(height))
    }
    
    func isReel(url: URL) -> Bool {
        guard let dimensions = getVideoDimensions(url: url) else {
            print("Unable to get video dimensions.")
            return false
        }
        
        return dimensions.height > dimensions.width
    }
    
    //MARK: - Navigation Title large Animation {}
    func scroll(_ scrollView: UIScrollView, _ title: String) {
        let scrollOffset = scrollView.contentOffset.y

        if scrollOffset > 0 {
            // Scrolling down
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.title = title
            
            // Customize font and size for small titles
            navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 17) ?? UIFont.boldSystemFont(ofSize: 17), // Change the font size as desired
                NSAttributedString.Key.foregroundColor: UIColor.black // Change the font color as desired
            ]
        } else {
            // Scrolling up or at the top
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = title
            
            // Customize font and size for large titles
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.font:  UIFont(name: "Poppins-Medium", size: 26) ?? UIFont.boldSystemFont(ofSize: 26), // Change the font size as desired
                NSAttributedString.Key.foregroundColor: UIColor.black // Change the font color as desired
            ]
        }
    }
    
    //MARK: - Error Handling and showing their response {}
    
    func showToast(message : String, seconds: Double , clr: UIColor){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = clr
        alert.view.alpha = 5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    func showAlertWith(title: String?, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showTwoWayAlert(title: String, message: String, on viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        // Create an alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add "OK" button with action
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion(true)
        }
        alertController.addAction(okAction)
        
        // Add "Cancel" button with action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        alertController.addAction(cancelAction)
        
        // Present the alert on the provided view controller
        viewController.present(alertController, animated: true, completion: nil)
    }

    
    
    //MARK: - print and share {}
    func screenShotAndShare(selectdVW:UIView) {
        
        let screenShot = selectdVW.takeScreenShot()
        let imageToShare = [ screenShot ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
 //Unauthenticated
  
}

//MARK: - Screen shot and Share it
extension UIView {
    
    func takeScreenShot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if img != nil {
            
            return img!
        }
        else {
            
            return UIImage()
            
        }
    }
}


//MARK: - Manage Animation {}
extension UIViewController : NVActivityIndicatorViewable {
    
    func showLoader() -> Void {
        self.startAnimating()
    }
    
    func hideLoader() -> Void {
        self.stopAnimating()
    }
    func applyLoaderToImageView(imageView : UIImageView) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
}
extension UITableViewCell : NVActivityIndicatorViewable {
    
    func applyLoaderToImageView(imageView : UIImageView) {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }
}
extension UINavigationController {
    
    func removeBackground() {
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        self.navigationBar.tintColor = .white
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
