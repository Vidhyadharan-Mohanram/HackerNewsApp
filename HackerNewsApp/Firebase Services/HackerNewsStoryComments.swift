//
//  HackerNewsStoryComments.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 23/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseUpdaterCommentsDelegate: class {
    func update(newComments: [CommentStruct]?)
}

class HackerNewsStoryComments: NSObject {
    private var firebase = Firebase(url: "https://hacker-news.firebaseio.com/v0/")!
    private weak var delegate: FirebaseUpdaterCommentsDelegate?

    private var comments: [CommentStruct]! = []
    private var retrievingComments: Bool! = false
    private let ItemChildRef = "item"

    convenience init(commentIds: [Int], delegate: FirebaseUpdaterCommentsDelegate) {
        self.init()
        self.delegate = delegate
        self.retrieveComments(for: commentIds)
    }

    private func retrieveComments(for ids: [Int]) {
        var newCommentsMap = [Int:CommentStruct]()
        var commentsCount = 0
        for commentId in ids {
            let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(commentId))
            query?.observeSingleEvent(of: .value, with: { snapshot in
                commentsCount += 1
                if let commentStruct = self.extractComment(snapshot!) {
                    newCommentsMap[commentId] = commentStruct
                }

                if ids.count == commentsCount {
                    var sortedComments = [CommentStruct]()
                    for id in ids {
                        guard let comment = newCommentsMap[id] else { continue }
                        sortedComments.append(comment)
                    }

                    self.comments = sortedComments

                    self.delegate?.update(newComments: sortedComments)
                    self.retrievingComments = false
                }
            }, withCancel: self.loadingFailed)
        }
    }


    private func extractComment(_ snapshot: FDataSnapshot) -> CommentStruct? {
        let data = snapshot.value as! Dictionary<String, Any>
        let commentStruct = CommentStruct(fromDictionary: data)

        return commentStruct
    }

    func loadingFailed(_ error: Error?) -> Void {
        self.delegate?.update(newComments: nil)
        print("loading error \(String(describing: error))")
    }
}
