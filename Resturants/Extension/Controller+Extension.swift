//
//  Controller+Extension.swift
//  Resturants
//
//  Created by shah on 15/01/2024.
//

import Foundation
import UIKit

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
import SDWebImage
import NVActivityIndicatorView
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
