//
//  NotificationsVC.swift
//  Resturants
//
//  Created by Coder Crew on 15/04/2024.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet weak var switchAllNotifications : UISwitch!
    @IBOutlet weak var switchFollow           : UISwitch!
    @IBOutlet weak var switchPost             : UISwitch!
    @IBOutlet weak var switchComment          : UISwitch!
    @IBOutlet weak var switchUpload           : UISwitch!
    @IBOutlet weak var switchSaved            : UISwitch!
    @IBOutlet weak var switchshared           : UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear()
    }
    
    @IBAction func ontapAllNotifications(_ sender: UISwitch){
        switchAllNotifications.isOn = switchAllNotifications.isOn
        switchFollow.isOn           = switchAllNotifications.isOn
        switchPost.isOn             = switchAllNotifications.isOn
        switchComment.isOn          = switchAllNotifications.isOn
        switchSaved.isOn            = switchAllNotifications.isOn
        switchUpload.isOn           = switchAllNotifications.isOn
        switchshared.isOn           = switchAllNotifications.isOn
    }
}

//MARK: - Setup Profile {}
extension NotificationsVC {
   
    func onload() {
      
        self.navigationItem.title = "Notifications"
        removeNavBackbuttonTitle()
    }
    
    func onAppear() {
    }
}

