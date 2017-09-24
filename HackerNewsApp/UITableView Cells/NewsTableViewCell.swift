//
//  NewsTableViewCell.swift
//  HackerNewsApp
//
//  Created by Vidhyadharan Mohanram on 24/09/17.
//  Copyright © 2017 Vidhyadharan. All rights reserved.
//

import UIKit
import SwiftDate
import Hero

class NewsTableViewCell: UITableViewCell {

    @IBOutlet fileprivate var scoreLabel: UILabel!
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var urlLabel: UILabel!
    @IBOutlet fileprivate var timeAndPosterNameLabel: UILabel!
    @IBOutlet fileprivate var commentsCountLabel: UILabel!

    internal var itemStruct: StoryStruct! {
        didSet {
            configureCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            titleLabel.heroID = "Title Label"
            if let count = urlLabel.text?.count, count > 0 {
                urlLabel.heroID = "URL Label"
            }
            timeAndPosterNameLabel.heroID = "Time And PostedBy Label"
        } else {
            titleLabel.heroID = ""
            urlLabel.heroID = ""
            timeAndPosterNameLabel.heroID = ""
        }
    }

    override func prepareForReuse() {
        titleLabel.heroID = ""
        urlLabel.heroID = ""
        timeAndPosterNameLabel.heroID = ""
    }

    internal func configureCell() {
        guard let item = itemStruct else { return }
        scoreLabel.text = "\(item.score ?? 0)"
        titleLabel.text = item.title

        if let urlVal = item.url {
            urlLabel.text = urlVal
        } else {
            urlLabel.text = ""
        }

        if let time = item.time, let by = item.by {
            let date = Date(timeIntervalSince1970: TimeInterval(time))
            let dateInRegion = DateInRegion(absoluteDate: date)
            let timeAgoText = try! dateInRegion.colloquialSinceNow().colloquial
            timeAndPosterNameLabel.text = "\(timeAgoText) • \(by)"
        }

        commentsCountLabel.text = "\(item.descendants ?? 0)"

    }

}
