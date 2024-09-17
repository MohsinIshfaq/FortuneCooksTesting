//
//  CommentsVC.swift
//  Resturants
//
//  Created by Coder Crew on 03/09/2024.
//

import UIKit

class CommentsVC: UIViewController {

    @IBOutlet weak var lblCommentsCount: UILabel!
    @IBOutlet weak var customTable: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var viewForContent: UIView!
    
    
    var profileVideoModel: ProfileVideosModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let count = profileVideoModel?.comments?.count ?? 0
        lblCommentsCount.text = "\(count) Comments"
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileVideoModel?.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentsTCell  = tableView.cell(for: indexPath)
        cell.config(comments: profileVideoModel?.comments?[indexPath.row])
        return cell
        
    }
}
