//
//  FeedBackVC.swift
//  Resturants
//
//  Created by Coder Crew on 24/06/2024.
//

import UIKit

class FeedBackVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        onLoad()
    }
    
    @IBAction func ontapDiscoveredBug(_ sender: UIButton){
        
        let vc = Constants.ProfileStoryBoard.instantiateViewController(withIdentifier: "ResonOfBugVC") as! ResonOfBugVC
        vc.hidesBottomBarWhenPushed = true
        vc.tag = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

//MARK: - Custom Implementation {}
extension FeedBackVC{
   
    func onLoad() {
        self.navigationItem.title = "Feedback"
        removeNavBackbuttonTitle()
    }
}
