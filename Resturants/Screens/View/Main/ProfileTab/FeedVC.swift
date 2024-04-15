//
//  FeedVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
}

//MARK: - Setup Profile {}
extension FeedVC {
   
    func onload() {
      
        self.navigationItem.title = "Feed"
        removeNavBackbuttonTitle()
    }
    
    func onAppear() {
       
    }
}

