//
//  HomeVC.swift
//  Resturants
//
//  Created by shah on 03/02/2024.
//

import UIKit

class HomeVC: UIViewController , MenuVCDelegate {
    func crtAccnt() {
        let vc = Constants.authStoryBoard.instantiateViewController(withIdentifier: "LoginNC") as? LoginNC
        vc?.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc!, animated: true)
    }
    //MARK: - @IBOutlets
    
    //MARK: - variables and Properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onlaod()
    }
    
    @objc func ontapNavRight() {
        
        let vc = Constants.homeStoryBoard.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.delegate = self
        self.present(vc, animated: true)
    }

}

//MARK: - Custom Implementation {}
extension HomeVC {
    
    func onlaod(){
        
        setupViews()
    }
    func onAppear(){
        
        
    }
    func setupViews() {
        
        NavigationRightBtn()
    }
    func NavigationRightBtn() {
        
        let myimage = UIImage(systemName: "line.3.horizontal.decrease")?.withRenderingMode(.automatic)
        var first = UIBarButtonItem(image: myimage, style: .plain, target: self, action: #selector(ontapNavRight))
        navigationItem.rightBarButtonItem = first
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}
