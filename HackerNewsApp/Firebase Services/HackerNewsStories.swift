//
//  HackerNewsStories.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 23/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

protocol FirebaseUpdaterDelegate: class {
    func update(newItems: [StoryStruct]?)
}

class HackerNewsStories: NSObject {
    // MARK: Enums

    enum StoryType: String {
        case top = "topstories"
        case new = "newstories"
        case best = "beststories"
        case ask = "askstories"
        case show = "showstories"
        case job = "jobstories"
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

    private var queryLimit: UInt = 30

//  The StoryType can be changed here.
    private var storyType: StoryType! = .top

    convenience init(delegate: FirebaseUpdaterDelegate) {
        self.init()
        self.delegate = delegate
        self.loadCachedStories()
    }

    private func loadCachedStories() {
        let cachedStories = try! Realm().objects(StoryRealm.self)
        if cachedStories.count > 0 {
            let storyStructs = cachedStories.map { StoryStruct($0.toDictionary()) }
            self.stories = Array(storyStructs)
            self.delegate?.update(newItems: self.stories)
        }
        self.retrieveStories()
    }

    internal func retrieveStories() {
        guard !retrievingStories else { return }

        retrievingStories = true

        var query: FQuery? = nil
//        if let lastStory = self.stories.first {
//            let lastId = lastStory.id
//            query = firebase.child(byAppendingPath: storyType.rawValue).queryOrdered(byChild: "id")
//                .queryStarting(atValue: lastId)
//                .queryLimited(toFirst: queryLimit)
//        } else {
            query = firebase.child(byAppendingPath: storyType.rawValue).queryLimited(toFirst: queryLimit)
//        }

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
        var newStoriesDataMap = [Int: [String: Any]]()
        var newStoriesMap = [Int:StoryStruct]()
        var storiesCount = 0
        for storyId in ids {
            let query = self.firebase.child(byAppendingPath: self.ItemChildRef).child(byAppendingPath: String(storyId))
            query?.observeSingleEvent(of: .value, with: { snapshot in
                storiesCount += 1
                let storyDictionary = snapshot!.value as! Dictionary<String, Any>
                let itemStruct = self.extractStory(storyDictionary)
                let currentTopStory = self.stories.first

                if currentTopStory == nil || currentTopStory!.id != itemStruct.id {
                    newStoriesDataMap[storyId] = storyDictionary
                    newStoriesMap[storyId] = itemStruct
                }

                if storiesCount == ids.count {
                    var sortedDataObjects = [[String: Any]]()
                    var sortedStories = [StoryStruct]()

                    for storyId in ids {
                        guard let newStory = newStoriesMap[storyId] else { continue }
                        sortedStories.append(newStory)
                        sortedDataObjects.append(newStoriesDataMap[storyId]!)
                    }

                    let filteredStories = sortedStories.filter({ (story) -> Bool in
                        return (self.stories.index(where: { $0.id == story.id }) == nil)
                    })

                    if self.stories.count == 0 {
                        self.stories = sortedStories
                    } else {
                        self.stories.insert(contentsOf: sortedStories, at: 0)
                    }
                    self.retrievingStories = false

                    DispatchQueue.main.async {
                        self.delegate?.update(newItems: filteredStories)
                        self.writeToRealm(newStories: sortedDataObjects)
                    }
                }
            }, withCancel: self.loadingFailed)
        }
    }

    private func extractStory(_ data: [String: Any]) -> StoryStruct {
        let itemStory = StoryStruct(data)
        return itemStory
    }

    func loadingFailed(_ error: Error?) -> Void {
        self.delegate?.update(newItems: nil)
        print("loading error \(String(describing: error))")
    }

    func writeToRealm(newStories: [[String: Any]]) {
        guard newStories.count > 0 else { return }

        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                let realm = try! Realm()

                try! realm.write {
                    for story in newStories {
                        guard let pKey = story["id"] as? Int else { continue }

                        if let storedStory = realm.object(ofType: StoryRealm.self, forPrimaryKey: pKey) {
                            storedStory.update(fromDictionary: story, realm: realm)
                            realm.add(storedStory, update: true)
                        } else {
                            let newStory = StoryRealm.fromDictionary(dictionary: story, realm: realm)
                            realm.add(newStory)
                        }
                    }
                }
            }
        }
    }
}
