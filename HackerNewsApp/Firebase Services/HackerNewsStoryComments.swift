//
//  HackerNewsStoryComments.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 23/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

protocol FirebaseUpdaterCommentsDelegate: class {
    func update(comments: [CommentStruct]?)
}

class HackerNewsStoryComments: NSObject {
    private var firebase = Firebase(url: "https://hacker-news.firebaseio.com/v0/")!
    private weak var delegate: FirebaseUpdaterCommentsDelegate?

    private var comments: [CommentStruct]! = []
    private var retrievingComments: Bool! = false
    private let ItemChildRef = "item"

    convenience init(parentId: Int, delegate: FirebaseUpdaterCommentsDelegate) {
        self.init()
        self.delegate = delegate
        loadCachedComments(parentId: parentId)
    }

    private func loadCachedComments(parentId: Int) {
        DispatchQueue.global(qos: .background).async {
            let story = try! Realm().object(ofType: StoryRealm.self, forPrimaryKey: parentId)!
            let validCachedComments = story.kids.filter { $0.text != nil }

            if validCachedComments.count > 0 {
                let commentStructs = validCachedComments.map { CommentStruct($0.toDictionary())! }
                self.comments = Array(commentStructs)
                
                DispatchQueue.main.async {
                    self.delegate?.update(comments: self.comments)
                }
            }

            let commentIds = Array(story.kids.map { $0.id })

            DispatchQueue.main.async {
                self.retrieveComments(for: commentIds)
            }
        }
    }


    private func retrieveComments(for ids: [Int]) {
        guard !retrievingComments else { return }

        retrievingComments = true

        var newCommentsDataMap = [Int: [String: Any]]()
        var newCommentsMap = [Int:CommentStruct]()
        var commentsCount = 0
        for commentId in ids {
            let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(commentId))
            query?.observeSingleEvent(of: .value, with: { snapshot in
                commentsCount += 1
                let data = snapshot!.value as! Dictionary<String, Any>
                if let commentStruct = self.extractComment(data) {
                    newCommentsDataMap[commentId] = data
                    newCommentsMap[commentId] = commentStruct
                }

                if ids.count == commentsCount {
                    var sortedDataObjects = [[String: Any]]()
                    var sortedComments = [CommentStruct]()

                    for id in ids {
                        guard let comment = newCommentsMap[id] else { continue }
                        sortedComments.append(comment)
                        sortedDataObjects.append(newCommentsDataMap[id]!)
                    }

                    let filteredComments = sortedComments.filter({ (comment) -> Bool in
                        return (self.comments.index(where: { $0.id == comment.id }) == nil)
                    })

                    self.comments = sortedComments

                    self.retrievingComments = false

                    DispatchQueue.main.async {
                        self.delegate?.update(comments: filteredComments)
                        self.writeToRealm(comments: sortedDataObjects)
                    }
                }
            }, withCancel: self.loadingFailed)
        }
    }


    private func extractComment(_ data: [String: Any]) -> CommentStruct? {
        let commentStruct = CommentStruct(data)

        return commentStruct
    }

    func loadingFailed(_ error: Error?) -> Void {
        self.delegate?.update(comments: nil)
        print("loading error \(String(describing: error))")
    }

    func writeToRealm(comments: [[String: Any]]) {
        guard comments.count > 0 else { return }

        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                let realm = try! Realm()

                try! realm.write {
                    for comment in comments {
                        guard let pKey = comment["id"] as? Int else { continue }

                        if let storedComment = realm.object(ofType: CommentRealm.self, forPrimaryKey: pKey) {
                            storedComment.update(fromDictionary: comment, realm: realm)
                            realm.add(storedComment, update: true)
                        } else {
                            let newComment = CommentRealm.fromDictionary(dictionary: comment, realm: realm)
                            realm.add(newComment)
                        }
                    }
                }
            }
        }
    }
}
