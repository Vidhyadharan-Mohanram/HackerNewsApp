//
//  HackerNewsStories.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 23/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit
import Firebase

protocol FirebaseUpdaterDelegate: class {
    func update(newItems: [StoryStruct]?)
}

class HackerNewsStories: NSObject {
    // MARK: Enums

    enum StoryType: String {
        case top = "topstories"
        case new = "newstories"
        case show = "showstories"
    }

    enum ItemType: String {
        case job = "job"
        case story = "story"
        case comment = "comment"
        case poll = "poll"
        case pollopt = "pollopt"
    }

    private var firebase = Firebase(url: "https://hacker-news.firebaseio.com/v0/")!

    private weak var delegate: FirebaseUpdaterDelegate?

    private var stories: [StoryStruct]! = []
    private var retrievingStories: Bool! = false
    private let ItemChildRef = "item"

    private var queryLimit: UInt!
    private var storyType: StoryType!

    convenience init(storyType type: StoryType = .top, queryLimit: UInt = 30, delegate: FirebaseUpdaterDelegate) {
        self.init()
        self.storyType = type
        self.queryLimit = queryLimit
        self.delegate = delegate
        self.retrieveStories()
    }

    internal func retrieveStories() {
        guard !retrievingStories else { return }

        retrievingStories = true

        var query: FQuery? = nil
        if let lastStory = self.stories.first {
            let lastStoryTimeInterval = lastStory.time
            query = firebase.child(byAppendingPath: storyType.rawValue).queryOrdered(byChild: "time")
                .queryStarting(atValue: lastStoryTimeInterval)
                .queryLimited(toFirst: queryLimit)
        } else {
            query = firebase.child(byAppendingPath: storyType.rawValue).queryLimited(toFirst: queryLimit)
        }

        query?.observeSingleEvent(of: .value, with: { snapshot in
            guard let snapshotItem = snapshot, snapshotItem.exists() else {
                self.retrievingStories = false
                self.delegate?.update(newItems: nil)
                return
            }
            let storyIds = snapshotItem.value as! [Int]
            self.retrieveItems(for: storyIds)
        }, withCancel: self.loadingFailed)
    }

    private func retrieveItems(for ids: [Int]) {
        var newStoriesMap = [Int:StoryStruct]()
        var storiesCount = 0
        for storyId in ids {
            let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(storyId))
            query?.observeSingleEvent(of: .value, with: { snapshot in
                storiesCount += 1
                let itemStruct = self.extractStory(snapshot!)
                let currentTopStory = self.stories.first
                if currentTopStory == nil || currentTopStory!.id != itemStruct.id {
                    newStoriesMap[storyId] = self.extractStory(snapshot!)
                }

                if storiesCount == ids.count {
                    var sortedStories = [StoryStruct]()
                    for storyId in ids {
                        sortedStories.append(newStoriesMap[storyId]!)
                    }
                    if self.stories.count == 0 {
                        self.stories = sortedStories
                    } else {
                        self.stories.insert(contentsOf: sortedStories, at: 0)
                    }
                    self.delegate?.update(newItems: sortedStories)
                    self.retrievingStories = false
                }
            }, withCancel: self.loadingFailed)
        }
    }


    private func extractStory(_ snapshot: FDataSnapshot) -> StoryStruct {
        let data = snapshot.value as! Dictionary<String, Any>
        let itemStory = StoryStruct(fromDictionary: data)

        return itemStory
    }

    func loadingFailed(_ error: Error?) -> Void {
        self.delegate?.update(newItems: nil)
        print("loading error \(String(describing: error))")
    }
}
