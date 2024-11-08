//
//  CommentApi.swift
//  Resturants
//
//  Created by Mohsin on 26/09/2024.
//

import Foundation
import FirebaseFirestore


func uploadComment(documentPath: String, arrayComment: [[String: Any]], handler: (([CommentModel]) -> Void)? = nil) {
    let db = Firestore.firestore()

    db.document(documentPath).setData(["commentList": arrayComment], merge: true) { error in
        if let error = error {
            print("Error uploading comment: \(error.localizedDescription)")
            return
        }
        
        print("Comment successfully uploaded and merged!")
        
        fetchUpdatedComments(documentPath, handler)
    }
}

func fetchUpdatedComments(_ documentPath: String,_ handler: (([CommentModel]) -> Void)? = nil) {
    let db = Firestore.firestore()
    
    db.document(documentPath).getDocument { (documentSnapshot, error) in
        if let error = error {
            print("Error fetching updated comments: \(error.localizedDescription)")
            return
        }
        
        guard let document = documentSnapshot, document.exists, let data = document.data() else {
            print("Document does not exist or contains no data.")
            return
        }
        
        if let commentListData = data["commentList"] as? [[String: Any]] {
            let updatedComments = commentListData.compactMap { parseCommentData(data: $0) }
            
            handler?(updatedComments)
            
            print("Comments successfully updated!")
        } else {
            print("No comments found in the document.")
        }
    }
}



func likeOrDislikeComment(documentPath: String, commentId: String, replyId: String?, userUID: String, completion: @escaping ([CommentModel]?) -> Void) {
    let db = Firestore.firestore()
    
    db.document(documentPath).getDocument { (document, error) in
        if let error = error {
//                completion(nil, error)
            print("** documentPath: \(documentPath) Error getting document: \(error)")
            return
        }
        
        guard let document = document, document.exists, var commentList = document.data()?["commentList"] as? [[String: Any]] else {
//                completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document or comments not found"]))
            print("** documentPath: \(documentPath) Document or comments not found")
            return
        }
        
        if let commentIndex = commentList.firstIndex(where: { $0["id"] as? String == commentId }) {
            var comment = parseCommentData(data: commentList[commentIndex])
            
            if let replyId = replyId {
                likeOrDislikeReply(&comment, replyId: replyId, userUID: userUID)
            } else {
                comment.likes = comment.likes ?? []
                toggleLike(&comment.likes!, userUID: userUID)
            }
            
            commentList[commentIndex] = comment.toDictionary()
            
            db.document(documentPath).updateData(["commentList": commentList]) { error in
                if let error = error {
                    print("After update not get comment: \(error)")
                    completion(nil)
                } else {
                    let updatedComments = commentList.map { parseCommentData(data: $0) }
                    completion(updatedComments)
                }
            }
        } else {
//                completion(nil, NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Comment not found"]))
            print("Comment not found")
        }
    }
}

private func likeOrDislikeReply(_ comment: inout CommentModel, replyId: String, userUID: String) {
    if let replyIndex = comment.replies?.firstIndex(where: { $0.id == replyId }) {
        var reply = comment.replies![replyIndex]
        
        reply.likes = reply.likes ?? []
        toggleLike(&reply.likes!, userUID: userUID)
        
        comment.replies![replyIndex] = reply
    }
}

private func toggleLike(_ likes: inout [String], userUID: String) {
    if let index = likes.firstIndex(of: userUID) {
        likes.remove(at: index)
    } else {
        likes.append(userUID)
    }
}
