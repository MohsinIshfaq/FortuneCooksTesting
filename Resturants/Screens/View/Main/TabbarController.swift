//
//  TabbarController.swift
//  Resturants
//
//  Created by shah on 19/01/2024.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        tabBar.didTapButton = { [unowned self] in
            // self.selectedIndex = 2
            let vc = Constants.addStoryBoard.instantiateViewController(withIdentifier: "CameraNC") as? CameraNC
            vc?.modalPresentationStyle = .overFullScreen
            self.present(vc!, animated: true)
            
        }
    }

}
