//
//  CommentsVC.swift
//  Resturants
//
//  Created by Coder Crew on 03/09/2024.
//

import UIKit

class CommentsVC: UIViewController {

    @IBOutlet weak var tblComments: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblComments.register(CommentsTCell.nib, forCellReuseIdentifier: CommentsTCell.identifier)
        tblComments.delegate  = self
        tblComments.dataSource = self
    }

}

//MARK: - tableView {}
extension CommentsVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tblComments.dequeueReusableCell(withIdentifier: CommentsTCell.identifier, for: indexPath) as? CommentsTCell
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
