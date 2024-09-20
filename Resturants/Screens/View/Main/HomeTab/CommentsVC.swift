//
//  CommentsVC.swift
//  Resturants
//
//  Created by Coder Crew on 03/09/2024.
//

import UIKit
import FirebaseFirestoreInternal

class CommentsVC: UIViewController {

    @IBOutlet weak var lblCommentsCount: UILabel!
    @IBOutlet weak var customTable: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var viewForContent: UIView!
    
    @IBOutlet weak var lblReplyTitle: UILabel!
    @IBOutlet weak var lblReplyMessage: UILabel!
    @IBOutlet weak var viewForReply: UIView!
    
    var profileVideoModel: ProfileVideosModel? = nil
    var userProfileModel: UserProfileModel? = nil
    var arrayShowReplies: [Int] = []
    var replyIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let commentCount = profileVideoModel?.comments?.count ?? 0
        let totalRepliesCount = profileVideoModel?.comments?.reduce(0) { $0 + ($1.replies?.count ?? 0) }  ?? 0
        let totalComment = commentCount + totalRepliesCount
        lblCommentsCount.text = "\(totalComment) Comments"
        viewForContent.setCornerRadius(cornerRadius: 20, corners: [.TopLeft, .TopRight])
        print("** Date().timeIntervalSince1970: \(Date().timeIntervalSince1970)")
    }
    
    func setReply(title: String? , message: String?, section: Int) {
        lblReplyTitle.text = trim(title)
        lblReplyMessage.text = trim(message)
        replyIndex = section
        viewForReply.isHidden = false
        txtMessage.becomeFirstResponder()
    }
    
    @IBAction func endEditing(_ sender: UITextField) {
        
    }
    
    @IBAction func onClickEmoji(_ sender: UIButton) {
        let emoji = sender.titleLabel?.text
        txtMessage.text = trim(txtMessage.text) + trim(emoji)
    }
    
    @IBAction func onClickSend(_ sender: UIButton) {
        if !trim(txtMessage.text).isEmpty {
            if viewForReply.isHidden {
                uploadComment()
            } else {
                uploadReply()
            }
        }
    }
    
    @IBAction func onClickCancelReply() {
        viewForReply.isHidden = true
        replyIndex = -1
    }
    
    @objc func onClickReplies(_ sender: UIButton) {
        if self.arrayShowReplies.removeFirst(where: { $0 == sender.tag }) == nil {
            self.arrayShowReplies.append(sender.tag)
        }
        self.customTable.reloadData()
    }
}

//MARK: - tableView {}
extension CommentsVC: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileVideoModel?.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayShowReplies.contains(section) {
            let repliesCount = profileVideoModel?.comments?[section].replies?.count ?? 0
            return repliesCount + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = profileVideoModel?.comments?[indexPath.section]
        if indexPath.row == 0 {
            let cell: CommentsTCell  = tableView.cell(for: indexPath)
            cell.config(comments: comment, userProfileModel: userProfileModel)
            cell.btnReplies.tag = indexPath.section
            cell.btnReplies.addTarget(self, action: #selector(onClickReplies(_:)), for: .touchUpInside)
            
            cell.btnReply.addAction {
                guard let comment else { return }
                let isCurrentUser = trim(comment.uid) == trim(self.userProfileModel?.uid)
                self.setReply(title: isCurrentUser ? "You" : "User", message: trim(comment.text), section: indexPath.section)
            }
            cell.btnLike.addAction {
                self.likeCommentOrReply(commentId: comment?.id, replyId: nil)
            }
            return cell
        } else {
            let replies = comment?.replies?[indexPath.row - 1]
            let repliesCount = comment?.replies?.count ?? 0
            
            let cell: CommentRepliesCell  = tableView.cell(for: indexPath)
            cell.config(replies: replies, userProfileModel: userProfileModel, isLast: indexPath.row == repliesCount)
            cell.btnReply.addAction {
                guard let replies else { return }
                let isCurrentUser = trim(replies.uid) == trim(self.userProfileModel?.uid)
                self.setReply(title: isCurrentUser ? "You" : "User", message: trim(replies.text), section: indexPath.section)
            }
            cell.btnHideReplies.tag = indexPath.section
            cell.btnHideReplies.addTarget(self, action: #selector(onClickReplies(_:)), for: .touchUpInside)
            cell.btnLike.addAction {
                self.likeCommentOrReply(commentId: comment?.id, replyId: replies?.id)
            }
            return cell
        }
    }
}

//MARK: - Firestore -

extension CommentsVC {
    func uploadComment() {
        let db = Firestore.firestore()
        let newComment = CommentModel(id: uniqueID, likes: nil, replies: nil, text: trim(txtMessage.text), timestamp: Date().timeIntervalSince1970, uid: userProfileModel?.uid)
        
        if profileVideoModel?.comments == nil {
            profileVideoModel?.comments = []
        }
        profileVideoModel?.comments?.append(newComment)
        
        let commentsArray = profileVideoModel?.comments?.map { $0.toDictionary() }
        let documentPath = "Swifts/\(trim(profileVideoModel?.uid))/VideosData/\(trim(profileVideoModel?.id))"
        print("** documentPath: \(documentPath)")
        db.document(documentPath).setData(["commentList": commentsArray ?? []], merge: true) { error in
            if let error = error {
                print("Error uploading comment: \(error.localizedDescription)")
            } else {
                self.txtMessage.text = ""
                self.customTable.reloadData()
                print("Comment successfully uploaded and merged!")
            }
        }
    }
    
    func uploadReply() {
        let db = Firestore.firestore()
        
        let newReply = ReplyModel(id: uniqueID, likes: [], text: trim(txtMessage.text), timestamp: Date().timeIntervalSince1970, uid: userProfileModel?.uid)
        
        if var comments = profileVideoModel?.comments {
            comments[replyIndex].replies?.append(newReply)
            
            let commentsArray = comments.map { $0.toDictionary() }
            
            let documentPath = "Swifts/\(trim(profileVideoModel?.uid))/VideosData/\(trim(profileVideoModel?.id))"
            print("** documentPath: \(documentPath)")
            db.document(documentPath).setData(["commentList": commentsArray], merge: true) { error in
                if let error = error {
                    print("Error uploading reply: \(error.localizedDescription)")
                } else {
                    print("** addeddCommentReplies: \(comments)")
                    self.profileVideoModel?.comments = comments
                    self.txtMessage.text = ""
                    self.viewForReply.isHidden = true
                    self.customTable.reloadData()
                    print("Reply successfully uploaded and merged!")
                }
            }
        }
    }
    
    func likeCommentOrReply(commentId: String?, replyId: String?) {
        let db = Firestore.firestore()
        var documentPath = ""
        
        if let commentId = commentId {
            if let replyId = replyId {
                documentPath = "Swifts/\(trim(profileVideoModel?.uid))/VideosData/\(trim(profileVideoModel?.id))/commentList/\(commentId)/replies/\(replyId)"
            } else {
                documentPath = "Swifts/\(trim(profileVideoModel?.uid))/VideosData/\(trim(profileVideoModel?.id))/commentList/\(commentId)"
            }
        }
        
        print("** documentPath: \(documentPath)")
        
        startAnimating()
        
        db.document(documentPath).getDocument { (document, error) in
            if let document = document {
                print("** MI document: \(document.data())")
                if document.exists {
                    
                    var arrayLikes = document.data()?["likes"] as? [String] ?? []
                    
                    if arrayLikes.removeFirst(where: { $0 == trim(self.userProfileModel?.uid) }) == nil {
                        arrayLikes.append(trim(self.userProfileModel?.uid))
                    }
                    
                    db.document(documentPath).updateData(["likes": arrayLikes]) { error in
                        if let error = error {
                            self.stopAnimating()
                            print("Error updating likes: \(error.localizedDescription)")
                        } else {
                            print("Successfully liked/disliked the comment or reply!")
                        }
                    }
                } else {
                    self.stopAnimating()
                }
            } else {
                self.stopAnimating()
                print("Document does not exist: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }



}
