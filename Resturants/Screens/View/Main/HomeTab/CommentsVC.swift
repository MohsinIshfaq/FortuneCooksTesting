//
//  CommentsVC.swift
//  Resturants
//
//  Created by Coder Crew on 03/09/2024.
//

import UIKit

class CommentsVC: UIViewController {

    @IBOutlet weak var customTable: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var viewForContent: UIView!
    
    var profileVideoModel: ProfileVideosModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewForContent.setCornerRadius(cornerRadius: 20, corners: [.TopLeft, .TopRight])
    }
    
    
    @IBAction func onClickEmoji(_ sender: UIButton) {
        let emoji = sender.titleLabel?.text
        txtMessage.text = trim(txtMessage.text) + trim(emoji)
        
    }
    
    @IBAction func onClickSend(_ sender: UIButton) {
    }
}

//MARK: - tableView {}
extension CommentsVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return profileVideoModel?.comments?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: CommentsTCell  = tableView.cell(for: indexPath)
            return cell
        } else {
            let cell: CommentsTCell  = tableView.cell(for: indexPath)
            return cell
        }
    }
}
