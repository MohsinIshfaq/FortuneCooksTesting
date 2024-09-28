//
//  CommentsVC.swift
//  Resturants
//
//  Created by Coder Crew on 03/09/2024.
//

import UIKit
import FirebaseFirestoreInternal

enum CommentType {
    case Videos, Swift
    
    var url: String {
        switch self {
        case .Videos:
            return "Videos"
        case .Swift:
            return "Swifts"
        }
    }
}

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
    var arrayAllUsers: [UserModel] = []
    var arrayShowReplies: [Int] = []
    var commentType: CommentType = .Videos
    var replyIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTitleCount()
        fetchAllUsersData()
        viewForContent.setCornerRadius(cornerRadius: 20, corners: [.TopLeft, .TopRight])
    }
    
    func configTitleCount() {
        let commentCount = profileVideoModel?.comments?.count ?? 0
        let totalRepliesCount = profileVideoModel?.comments?.reduce(0) { $0 + ($1.replies?.count ?? 0) }  ?? 0
        let totalComment = commentCount + totalRepliesCount
        lblCommentsCount.text = "\(totalComment) Comments"
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
                submitComment()
            } else {
                submitReply(to: replyIndex)
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
            cell.config(comments: comment, arrayAllUsers: arrayAllUsers, userProfileModel: userProfileModel)
            cell.btnReplies.tag = indexPath.section
            cell.btnReplies.addTarget(self, action: #selector(onClickReplies(_:)), for: .touchUpInside)
            
            cell.btnReply.addAction {
                guard let comment else { return }
                let isCurrentUser = trim(comment.uid) == trim(self.userProfileModel?.uid)
                self.setReply(title: isCurrentUser ? "You" : "User", message: trim(comment.text), section: indexPath.section)
            }
            cell.btnLike.addAction {
                let documentPath = "\(self.commentType.url)/\(trim(self.profileVideoModel?.uid))/VideosData/\(trim(self.profileVideoModel?.id))"
                likeOrDislikeComment(documentPath: documentPath, commentId: trim(comment?.id), replyId: nil, userUID: trim(self.userProfileModel?.uid)) { arrayComment in
                    if let arrayComment {
                        self.profileVideoModel?.comments = arrayComment
                        self.customTable.reloadData()
                    }
                }
            }
            return cell
        } else {
            let replies = comment?.replies?[indexPath.row - 1]
            let repliesCount = comment?.replies?.count ?? 0
            
            let cell: CommentRepliesCell  = tableView.cell(for: indexPath)
            cell.config(replies: replies, arrayAllUsers: arrayAllUsers, userProfileModel: userProfileModel, isLast: indexPath.row == repliesCount)
            cell.btnReply.addAction {
                guard let replies else { return }
                let isCurrentUser = trim(replies.uid) == trim(self.userProfileModel?.uid)
                self.setReply(title: isCurrentUser ? "You" : "User", message: trim(replies.text), section: indexPath.section)
            }
            cell.btnHideReplies.tag = indexPath.section
            cell.btnHideReplies.addTarget(self, action: #selector(onClickReplies(_:)), for: .touchUpInside)
            cell.btnLike.addAction {
                let documentPath = "\(self.commentType.url)/\(trim(self.profileVideoModel?.uid))/VideosData/\(trim(self.profileVideoModel?.id))"
                print("** documentPath: \(documentPath)")
                likeOrDislikeComment(documentPath: documentPath, commentId: trim(comment?.id), replyId: replies?.id, userUID: trim(self.userProfileModel?.uid)) { arrayComment in
                    if let arrayComment {
                        self.profileVideoModel?.comments = arrayComment
                        self.customTable.reloadData()
                    }
                }
            }
            return cell
        }
    }
}

//MARK: - Firestore -

extension CommentsVC {
    
    func submitComment() {
        IQKeyboardManager.shared().resignFirstResponder()
        guard let userUID = userProfileModel?.uid, let videoID = profileVideoModel?.id, let videoOwnerUID = profileVideoModel?.uid else {
            print("Error: Missing user or video information.")
            return
        }
        
        let documentPath = "\(commentType.url)/\(videoOwnerUID)/VideosData/\(videoID)"
        print("** documentPath: \(documentPath)")
        let newComment = CommentModel(
            id: uniqueID,
            likes: [],
            replies: [],
            text: trim(txtMessage.text),
            timestamp: Date().timeIntervalSince1970,
            uid: userUID
        )
        print("** newComment: \(newComment)")
        
        var currentComments = profileVideoModel?.comments ?? []
        
        currentComments.append(newComment)
        
        let arrayComment = currentComments.map { $0.toDictionary() }
        print("** documentPath: \(documentPath) commentsArray: \(arrayComment)")
        
        uploadComment(documentPath: documentPath, arrayComment: arrayComment) { [weak self] arrayComment in
            guard let self = self else { return }
            self.txtMessage.text = ""
            profileVideoModel?.comments = arrayComment
            configTitleCount()
            self.customTable.reloadData()
        }
    }
    
    func submitReply(to commentIndex: Int) {
        IQKeyboardManager.shared().resignFirstResponder()
        guard
            let userUID = userProfileModel?.uid,
            let videoID = profileVideoModel?.id,
            let videoOwnerUID = profileVideoModel?.uid,
            let comments = profileVideoModel?.comments,
            commentIndex < comments.count else {
            print("Error: Missing user, video, or comment information.")
            return
        }

        let documentPath = "\(commentType.url)/\(videoOwnerUID)/VideosData/\(videoID)"
        print("Document Path: \(documentPath)")

        let newReply = ReplyModel(
            id: uniqueID,
            likes: [],
            text: trim(txtMessage.text),
            timestamp: Date().timeIntervalSince1970,
            uid: userUID
        )
        print("New Reply: \(newReply)")

        var updatedComments = comments
        updatedComments[commentIndex].replies?.append(newReply)

        let commentsArray = updatedComments.map { $0.toDictionary() }
        print("Updated Comments Array: \(commentsArray)")
        
        uploadComment(documentPath: documentPath, arrayComment: commentsArray) { [weak self] arrayComments in
            guard let self = self else { return }

            self.txtMessage.text = ""
            self.profileVideoModel?.comments = arrayComments
            configTitleCount()
            self.viewForReply.isHidden = true
            self.customTable.reloadData()
        }
    }
    
    func fetchAllUsersData() {
        fetchAllUsers { [weak self] arrayUser in
            guard let self = self else { return }
            self.arrayAllUsers = arrayUser
            customTable.reloadData()
        }
    }
}
